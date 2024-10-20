//Developed by A. Tiroumalechetty for Dittman Lab to process Olympus laser scan confocal images (.oif) into Tiff Stacks and Z-projections for 
//files with 1 or two channels

//This requires the Bioformats macro extensions for FIJI

//INPUT: Dataset directory containing individual subdirectories for each genotype which themselves contain olympus .oif files and their associated folders
//		 Selection of which type of Z projection to use
//OUTPUT: 1 Channel .oif files: A. Directory named Tiff Stacks containing stacks in .tif format
//								B. Directory named Z Projection Tiffs containing the maximum Z projection tiffs
//OUTPUT: 2 Channel .oif files: A. Directory named Tiff Stacks containing stacks in .tif format
//								B. Directory named Multichannel Z Projection Tiffs containing the maximum Z projection tiffs
//								C. Directory named C1 Z Projection Tiffs containing the maximum Z projection tiffs of Channel 1
//								D. Directory named C2 Z Projection Tiffs containing the maximum Z projection tiffs of Channel 2

//Expected setup: [Dataset Directory]/[Individual Genotype Directories containing .oif files and associated folders]
//The name of the resulting tiff stacks are obtained from the Dataset directory name, 
//Genotype Directory name and extracted from the digits of the .oif file
//Example: Stacks and Z-projections from 20230909 Dataset/nrx-1(wy1155)/dnc32.oif will be named  20230909 Dataset - nrx-1(wy1155) - Position 32.tif

//For some reason, the FV1000Reader.java script within the bioformats importer sets the LaserMedium value to the DyeName value in the .oif file. 
//This leads to a [WARN] message on the console such as:  
//"[WARN] Unknown LaserMedium value '[DyeName]' will be stored as "Other"" 
//This should not lead to any downstream issues for analysis and can be safely ignored



//Select The type of z-projection you want to use
// Options are "Sum Slices", "Average Intensity", "Max Intensity", "Min Intensity", "Standard Deviation", "Median"
// Note: Sum Slices seems to work best for the test files Jeremy sent me
projection_type="Sum Slices";



//Convert submitted Projection type into input for z-project version 
ZprojectInput="projection=["+ projection_type +"]";

//Defining directories for saving and analysis
OlympusDir = getDirectory("Select the directory with .oif files and associated folders");
files = getFileList(OlympusDir);
saveDir = OlympusDir + "/Tiff Stacks/";
dir2= OlympusDir + "Z Projection Tiffs/";
dir3= OlympusDir + "Multichannel Z Projection Tiffs/";
dir4= OlympusDir + "C1 Z Projection Tiffs/";
dir5= OlympusDir + "C2 Z Projection Tiffs/";


//Create the defined directories
File.makeDirectory(saveDir);
File.makeDirectory(dir2);
File.makeDirectory(dir3);
File.makeDirectory(dir4);
File.makeDirectory(dir5);

//Get Dataset Name from Olympus Directory
Dataset_name=File.getName(OlympusDir);
//Get list of folders in directory
folders = getFileList(OlympusDir)

//Process each subdirectory
for (ff = 0; ff < folders.length; ff++) {
	if (File.isDirectory(OlympusDir+folders[ff])) {
	
		Current_Dir=OlympusDir+folders[ff];
		
		//Get Genotype name from subdirectory name
		Genotype_name=File.getName(Current_Dir);
		//Get list of files
		files = getFileList(Current_Dir);	
	
		//Batch process .tif extraction
		setBatchMode(true); //turn batch mode on
		k=0;
		run("Bio-Formats Macro Extensions");
	
		for(f=0; f<files.length; f++) {
			//Only consider files ending with .oif
			if(endsWith(files[f], ".oif")) {
				k++;
				id = Current_Dir+files[f];
				Ext.setId(id); 
				//run Bioformats importer to create a virtual stack
				//open only series 1 as this is the one with the ROI 
				run("Bio-Formats Importer", "open=["+id+"] color_mode=Default view=Hyperstack stack_order=XYCZT use_virtual_stack series_1"+(1));//open only series 1
				// get image title
				Title = getTitle();
				//print(Title);
				//parse Title for MATLAB
				Title=split(getTitle(),".");
				//print(Title[0]);
				//Extract Position number by deleting non numeric characters
				Position_num=replace(Title[0],"[^0-9]*", "");
				//print(Position_num);
				//Create Matlab compatible save name
				saveName= Dataset_name + " - " + Genotype_name + " - " + "Position " + Position_num;
				print(saveName);
				//save z-stack
				saveAs("tiff", saveDir+saveName+".tif");
				//run maximum intensity z-projection 
				run("Z Project...", ZprojectInput);
				//Check number of channels in image and if 2, save to multichannel directory and appropriate 1 channel directory
				//else save to 'Max Projection Tiffs directory
				if(nSlices==1){
					saveAs("TIFF", dir2+saveName+".tif");
					close(); // close maximum projection image
				} else {
					if (nSlices==2) {
					saveAs("TIFF", dir3+saveName+".tif");
					run("Stack to Images");
					saveAs("TIFF", dir4+saveName+".tif");
					close(); // close channel 1 maximum projection
					saveAs("TIFF", dir5+saveName+".tif");
					close(); // close channel 2 maximum projection
					}					
				}
				close(); // close Z-stack
				Ext.close();
			}
		}
		setBatchMode(false);
	}
}

			
