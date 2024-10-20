//This macro requires the SlideBook plugin for the BioFormats macro extensions, which is found through the ImageJ/Help/Update... menu
 //select  Langauage as IJ1 Macro to run
//Developed by E. Frankel and A. Tiroumalechetty to perform streamlined axon tracing from slidebook files. 


 
//Defining directories for saving and analysis
dir1 = getDirectory("Select a directory containing one or several .sld files");
files = getFileList(dir1);
saveDir = dir1 + "/Extracted Max Tifs/";
dir2= dir1 + "/Multichannel_Straightened Lines/";
dir3= dir1 + "/C1_Straightened lines/";
dir4= dir1 + "/C2_Straightened lines/";
dir5= dir1 + "/Straightened lines/";
File.makeDirectory(saveDir);
File.makeDirectory(dir2);
File.makeDirectory(dir3);
File.makeDirectory(dir4);
File.makeDirectory(dir5);
//Batch process .tif extraction
setBatchMode(false);
k=0;
n=0;
run("Bio-Formats Macro Extensions");

for(f=0; f<files.length; f++) {
	if(endsWith(files[f], ".sld")) {
		k++;
		id = dir1+files[f];
		Ext.setId(id);
		Ext.getSeriesCount(seriesCount);
		n+=seriesCount;
		print(seriesCount);
		for (i=0; i<seriesCount; i++) {
			run("Bio-Formats Importer", "open=["+id+"] color_mode=Default view=Hyperstack stack_order=XYCZT use_virtual_stack series_"+(i+1));
			Title = getTitle();
			print(i);
			//check if image is already a Max Intensity projection and skip if so
			if(nSlices==1){
				print("Tiff was a Max Projection and was skipped");
				continue;
			}
			run("Z Project...", "projection=[Max Intensity]");
			saveAs("tiff", saveDir+Title+".tif");
			run("Brightness/Contrast...");
			if(nSlices==2){
				setSlice(2);
				run("Enhance Contrast", "saturated=0.35");
				run("Enhance Contrast", "saturated=0.35");
				run("Enhance Contrast", "saturated=0.35");
				run("Enhance Contrast", "saturated=0.35");
				run("Enhance Contrast", "saturated=0.35");
				setTool("polyline");
				//Prompt user to trace axons and if 'okay' is clicked without
				//a selection, prompt user again (up to 4 times)
				for (j=0; selectionType() != 6 && j!=3; j++) {
					waitForUser("Trace Axon. If you want to skip or exit, hit ok 3x");	
					}
				//if user clicks ok without a selection 4 times, give option
				//to skip this tiff or exit the program
				if (selectionType() != 6 && j==3){
							close(); //close MaxProjection
							close(); //close stack
							Dialog.create("Skip or Exit?");
							Dialog.addMessage("Click OK to skip to next tif or cancel to exit program");
							Dialog.show()
							continue 
							}	
				run("Straighten...");
				saveAs("TIFF", dir2+Title+".tif");
				run("Stack to Images");
				saveAs("TIFF", dir4+Title+".tif");
				close();
				saveAs("TIFF", dir3+Title+".tif");
				close();
				 close();
				  close();
				} else{
				run("Enhance Contrast", "saturated=0.35");
				run("Enhance Contrast", "saturated=0.35");
				run("Enhance Contrast", "saturated=0.35");
				run("Enhance Contrast", "saturated=0.35");
				run("Enhance Contrast", "saturated=0.35");
				setTool("polyline");
				for (j=0; selectionType() !=6 && j!=3; j++) {
					waitForUser("Trace Axon. If you want to skip or exit, hit ok 3x ");	
					}
				//if user clicks ok without a selection 4 times, give option
				//to skip this tiff or exit the program
				if (selectionType() != 6 && j==3){
							close(); //close MaxProjection
							close(); //close stack
							Dialog.create("Skip or Exit?");
							Dialog.addMessage("Click OK to skip to the next tif or cancel to exit program");
							Dialog.show()
							continue
							}
				
				run("Straighten...");
				saveAs("TIFF", dir5+Title+".tif");
			 	close(); //close linescan
				close(); //close MaxProjection
				close(); //close stack
				}
		}
		//delete any directories that were not populated
		File.delete(dir2);
		File.delete(dir3);
		File.delete(dir4);
		File.delete(dir5);
      		run("Close All");
     		}	
		}
	

