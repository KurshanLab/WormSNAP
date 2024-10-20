# WormSNAP Quick Guide

*WormSNAP (Worm SyNapse Analysis Program)* is a software that allows for
code free fluorescent puncta detection in *C. elegans* confocal 1 and
2 channel images based on local means thresholding algorithm.

# Getting Started

WormSNAP can be either installed as a matlab app or as a standalone
desktop app. The first requires you to already have Matlab installed
(minimum of Matlab 2022a) with the Image Processing and Statistics and
Machine learning toolbox installed. For more on system requirements,
please check the full documentation. Otherwise, just download the
appropriate file - WormSNAP.mlappinstall for the Matlab App or either
the WindowsIntaller_web or MacOSIntaller_web and run it, following the
instructions for the installers.

Note: You will also need to have FIJI with the Bioformats plugin
installed if your files are not in a .tiff format.

# Inputs

WormSNAP uses a directory of 1 or 2 channel Z-projected tiff files as
input. The filename convention for these tiff files is
<p align="center">
[Dataset Name] – [Genotype Name] – Position [WormNumber].tif
</p>


Where:

\[Dataset Name\] is the name of the dataset (can be any text as long as
‘ – ‘ is not included)

\[Genotype Name\] is the name of the genotype (can be any text as long
as ‘ – ‘ is not included)

WormNumber is the number of the worm in digits, repeats are not expected
within a genotype.

Note: If your files are in another format, please check the Formats
folder for FIJI Macros that can be used to convert your files into the
appropriate format.

# Quick Guide to WormSNAP

<img align="right" height="100" alt="ROI Detection Tab" src="Docs/Images/Folder selection window.png">


Launch the WormSNAP application from the MATLAB App Toolstrip or the
application file.
This will open a folder selection dialog box. Navigate your way to your
directory containing the tiffs of interest and click open/select folder.


## Preprocessing Tab

<img align="top" width="901" alt="ROI Detection Tab" src="Docs/Images/PreprocessingTab and crops.png">

This will load in the tiffs into the app’s Display Panel (right), split into
genotypes in different tabs. If any crops should be excluded from
analysis, click on the crop which should turn it invisible.

In the Settings Panel (left), the Preprocessing Tab will be available. 

### Channel Naming Panel
Here, you can edit the channel name as needed. If there
are more than one channel, you can switch between the channels using the
‘channel list’ dropdown. You can save the name(s) as a preset by clicking 'Save Set'

### Genotype Renaming Panel
Here, you can rename Genotypes. This is done by clicking on the Original
Genotype name on the left list, writing in the new name in the input
field next to the ‘New Genotype Name’ and pressing Enter. The New Name
should then be visible in the ‘Renamed Genotype’ list. These will be
used as headers when calculating the different output metrics.

### Resolution Panel

The Resolution panel allows for specifying the Resolution of the image
in px/µm. The default option is ‘Automated’ which will check the tiff
files for the information and use it if the resolution is available (and
consistent across all images included). Otherwise, it will set the
resolution to 0. The Manual option allows you to type in your own values
and the other options (‘100 X Mag, 63 X Mag, 2.5 X Mag) use some common
default values for different magnification of a confocal scope. The
Resolution will be used for calculating normalized output variables
normalized such as ‘RoiCountper100µm’. In case the Resolution is 0, the
normalized outputs will be normalized to pixels instead.

After you are done, click on ‘Preprocessing Completed’ to load the ROI
detection tab.

## ROI Detection Tab
<img align="right" width="350" alt="ROI Detection Tab" src="Docs/Images/ROI Detection Tab.png">

### ROI Channel Panel
Here, you can select which channel to detect ROIs in. 

### ROI Settings Presets Panel

To detect ROIs either select one of the presets in the Saved Settings Dropdown or
use your own combination of settings from the  as needed and then click
‘UpdateROIs’. You can save any new settings you use by typing in the
Settings Name field and then clicking ‘Save Settings’.

### Thresholding Parameters Panel 

This panel contains the 3 ROI thresholding settings for the local mean
thresholding algorithm.

The Sensitivity ranges from 0-1 and is a measure of how likely a given
pixel is to be thresholded as signal with higher values leading to
thresholding more pixels as foreground.

The Neighbhorhood Size refers to the number of neighboring pixels used
to calculate the threshold for a given pixel. Its values can only be odd
integers as it includes the pixel of interest.

Watershed is an option that applies a watershed transform to the ROIs,
which allows for separating close by puncta that get thresholded
together.

### Crop Restriction Parameters Panel 

This panel contains restriction parameters that allows users to restrict
ROIs based on their given location in the crop.

The ‘Exclude y edge px’ option excludes any ROIs that are a within a
given number of pixels away from the top and bottom edges of the crops.

The ‘Exclude x start px’ option excludes any ROIs that are within a
given number of pixels from the start of the image. If the resolution is
not 0, these values are also calculated in microns. Checking the
‘Visualize Cutoffs on crops’ allows users to see where the cutoffs are
currently placed. Solid lines are used for applied settings and dotted
lines for current settings. These are assumed to apply identically to
each channel.

### ROI Restriction Parameters Panel 

This panel contains restriction parameters that allows users to restrict
ROIs based on their individual properties.

Min Area excludes any ROIs having a given area or less in
pixels<sup>2</sup> (with conversion to µm<sup>2</sup> if resolution
\>0).

Max L/W ratio excludes any ROI having a given maximum length/width
ratio or higher. Here, the length/width ratio refers to the ratio of the
maximum ferret diameter (largest dimension/major axis for an ellipse) to
the ratio of the minimum ferret diameter (smallest dimension/minor axis
for an ellipse)) or higher.

Min Circularity excludes any ROIs with a circularity below the
specified value. Circularity ranges from 0 (perfect line) to 1(perfect
circle). Not recommended for small ROIs (such as 3x3 squares), as the
computed circularity can be greater than 1.

Min Coeff of Var excludes any ROIs with a coefficient of variance
above a given value. The coefficient of variance or relative standard
deviation is the ratio of the standard deviation of the pixel
intensities to the mean of pixel intensities. This measure can be used
to exclude background signal that has relatively constant intensities.

Exclude dist. outliers option, when selected, excludes any ROI
whose distance to their nearest neighbor is three scaled median
deviations away from the median distance to the nearest neighbor for the
ROIs in each crop.

<img align="bottom" width="901" alt="ROI Detection Tab" src="Docs/Images/ROIDetectionTabandROI.png">


Once you are done detecting ROIs in all the channels available, the
‘Proceed to Results’ button is enabled. Clicking on this brings you to
the final tab, the Results Tab.

## Results Tab
<img align="right" width="350" alt="ROI Detection Tab" src="Docs/Images/Results Tab.png">

### ROI Display Panel

Here, you can view the crop and ROIs in various configurations,

The ‘Crop Channel’ dropdown selects the channel of the crop.

The ‘ROI Visibility’ dropdown selects which ROIs are overlaid on the
crops, with All ROIs showing all thresholded ROIs, restricted ROIs
showing only ROIs that satisfy the restriction parameters and No ROIs
(Crops Only) showing no ROIs.

The ‘ROI Channel’ dropdown allows you to pick which channel the ROIs you
are viewing are from. If you pick the ‘Both Channels’ option when
looking at 2 channel images, the restricted ROIs of the first channel
will be shown in green and those of the second channel in red.

### Intensity Normalization panel

The Intensity Normalization panel lets you normalize the intensities of
your crops based on either a specific genotype (the values used will be
the median minimum intensity and median maximum intensity) or intensity
values.

### Export Settings Panel

The Export Settings panel allows you to pick the types of output you
want.

The ‘Create Prism files’ option creates ready for prism .csv files that
can be directly imported to prism or other plotting software.

The ‘Create Individual Crop Figures’ option creates individual .pdf
figures for each crop with overlays of the ROIs.

Selecting ‘Save Current Crop Display’ will save the current view shown
in the display panel as a .pdf file.

Selecting ‘Create Crop Montage’ will create a montage of the crops for
each channel based on the selected Normalization. Note: This is not
currently recommended for Normalization across two channels.

The ‘save analysis as a ‘.mat’ file will save a file which contains the
full analysis parameters if needed.

Selecting ‘Calculate Overlap Metrics’ calculates metrics for overlap
between the ROIs in each channel. The selected Overlap Threshold is used
to calculate R1 and R2 (See Outputs for more details).

Once you are done making your selections, Click ‘Process All Crops’ to
start analyzing the crops and associated ROIs.

# Outputs

<img align="right" width="400" alt="ROI Detection Tab" src="Docs/Images/AnalysisOutputFolder.png">

A ‘Matlab Output’ folder will be created in the directory containing the
tiff files the first time a dataset is analyzed.

Each Analysis is saved within that folder as its own folder named
\[Datetime\]ROI Analysis.

Each analysis folder contains an ‘Output Settings.txt’ file that
contains all the settings used for the analysis. It also contains 1
folder per channel named \[ChannelName\] Channel ROIs as well as three
other folders depending on the export settings chosen.

## Channel Folders

<img align="right" width="400" alt="ROI Detection Tab" src="Docs/Images/SingleChannelFolder.png">

Each Channel Folder contains two .csv files, \[Datetime\]roi_table which
contains the properties of every restricted ROI and
\[Datetime\]summary_table which contains the calculated variables for
every crop as well as a png file called Output Variables of interest
which contains boxplots of a few of the variables.

If the ‘Create Prism files’ option was checked, a folder named Prism
Data is included which contains .csv files for different variables that
can be easily imported into Prism or other plotting software. See end of
the Outputs section for more details on the

If the ‘Create Individual Crop Figures’ option was checked, a folder
named *Individual ROI files* is included which contains .pdf files
showing the ROIs for each crop. Note: These files can be opened in
illustrator or most figure making software.

If the ‘Save Analysis as .mat file’ option was selected, a file named
\[Datetime\]savedstate will be included. This file can be opened in
matlab to access all the information of the analysis.

## Display Folder

The ‘Display’ folder is included if ‘Save Current Crop Display’ was
checked in export settings and contains .pdf files of the Display Panel
with the same combination of channel and ROI view chosen.

## Montages Folder

The ‘Montages’ folder is included if ‘Create Crop Montage’ was checked
in export settings and contains .pdf files of the crops with no ROIs
normalized as per the settings chosen in the Results Tab. Note: This
currently should not be used for 2 channel images.

## Overlap folder

The Overlap folder is included if ‘Calculate Overlap Metrics’ was
selected for a 2 channel image. The overlap threshold used is appended
to the name of the folder.

This folder contains a csv file named \[Datetime\]summarytable which
contains the calculated colocalization variables for every crop and an
Overlap Metrics png file which contains boxplots of the colocalization
metrics.

If the ‘Create Prism files’ option was checked, a folder named Prism
Data is included which contains .csv files for the colocalization
metrics.

If the ‘Create Individual Crop Figures’ option was checked, a folder
named *Individual ROI files* is included which contains .pdf files
showing the ROIs for each crop. In each file, the Restricted ROIs are
shown overlaid on their respective channel, then the unique ROI areas
are shown for each channel and finally the unique ROIs based on the
Overlap Threshold chosen are shown.

## Files in Channel Prism Data folder

<img align="right" width="400" alt="ROI Detection Tab" src="Docs/Images/PrismDataFolder.png">

**avgRawRoiIntensity.csv**

Average of the Raw Intensity of the ROI pixels in each crop (no
background subtraction)

**avgRoiCircularity.csv**

Average Circularity of the ROIs in each crop. Circularity ranges from 0
(perfect line) to 1 (perfect circle). Note that circularity can go above
1 for very small ROIs.

$`Circularity = \frac{4\pi Area}{{Perimeter}^{2}}(1 - \frac{1}{2r})`$
where $`r = \frac{Perimeter}{2\pi} + \frac{1}{2}`$

**avgRoiIntensity.csv**

Average of the Intensity of the ROI pixels in each crop.

**avgstdInt.csv**

Average Standard Deviation of pixel intensities in the ROIs in each
crop.

**CoeffofVar.csv**

Average Coefficient of Variance of pixel intensities of ROIs in each
crop.

**RoiAreaRatio.csv**

Ratio of the total area of all ROIs found in each crop to the area of
said crop.

**roiCount.csv**

Number of ROIs in each crop.

**RoiIntensityRatioBackground.csv**

Ratio of total ROI Intensity to that of the total background intensity
used to calculate the ROI intensity.

``` math
RoiIntensityRatioBackground = \frac{sumRawRoiIntensity}{sumRawRoiIntensity - sumRoiIntensity}
```

**RoiIntensityRatio.csv**

Ratio of total Raw ROI intensity to that of total fluorescence of the
crop.

**totalFluorescence.csv**

Total intensity of all pixels in the crop.

For the parameters that rely on the dimensions of the crops, if a
resolution is included, they will be calculated in microns (or per 100
microns) otherwise they will be calculated in pixels (or per 500
pixels).

**Asynapticlength(Microns/Pixels).csv**

X Distance from start of the crop to the first ROI in pixels or microns.

**avgRoiArea(Microns/Pixels).csv**

Average area of the ROI in each crop

**interRoiDistance(Microns/Pixels).csv**

Average distance between an ROI and subsequent ROI based on their
weighted centroid (center weighted by pixel intensity values) position
in each crop.

**length(Microns/Pixels).csv**

Length of crop.

**synapticlength(Microns/Pixels) .csv**

X Distance from the first ROI to the last ROI in pixels or microns.

**NormalizedFluorescencePer(100Microns/500 Pixels).csv**

Total Fluorescence of each crop normalized to 100 Microns (500 Pixels).

**NormalizedroiCountPer(100Microns/500 Pixels).csv**

Number of ROIs in each crop normalized to 100 Microns (500 Pixels).

**NormalizedsumRawRoiIntensityPer(100Microns/500 Pixels) .csv**

Sum of Raw intensity (no background subtraction) of all ROI pixels in
each crop normalized to 100 Microns (500 Pixels).

**NormalizedsumRoiIntensityPer(100Microns/500 Pixels).csv**

Sum of intensity of all ROI pixels in each crop normalized to 100
Microns (500 Pixels).

## Files in the Overlap Prism Data folder

There are 5 metrics calculated for channel colocalization purposes, the
Pearson’s Correlation Coefficient, the Manders’ Correlation Coefficients
M1 and M2 and the ROI Overlap Coefficients R1 and R2.

### Manders’ Colocalization Coefficients

**M1_c1roiAreaOverlapratio.csv**

Manders’ Colocalization Coefficient M1 which is the fraction of signal
pixels in channel 1 that are also signal pixels in channel 2

``` math
M1 = \frac{\sum_{i}^{}{C1}_{i,coloc}}{\sum_{i}^{}{C1}_{i}}
```

Where:

> $`{C1}_{i} = 1`$ if pixel $`i`$ is thresholded as signal in Channel 1
> and $`{C1}_{i} = 0`$ otherwise
>
> $`{C1}_{i,coloc} = 1`$ if pixel $`i`$ is thresholded as signal in both
> channels and $`{C1}_{i,coloc} = 0`$ otherwise

**M2_c2roiAreaOverlapratio.csv**

Manders’ Colocalization Coefficient M2 which is the fraction of signal
pixels in channel 2 that are also signal pixels in channel 1

``` math
M2 = \frac{\sum_{i}^{}{C2}_{i,coloc}}{\sum_{i}^{}{C2}_{i}}
```

Where:

> $`{C2}_{i} = 1`$ if pixel $`i\ `$is thresholded as signal in Channel 2
> and $`{C2}_{i} = 0`$ otherwise
>
> $`{C2}_{i,coloc} = 1`$ if pixel $`i\ `$is thresholded as signal in
> both channels and $`{C2}_{i,coloc} = 0`$ otherwise

### Pearson’s Correlation Coefficient

**PCC.csv**

Pearson’s Correlation Coefficient determines how linear the relationship
between two variables in this case the intensity in Channel 1 and
intensity in Channel 2 is.

``` math
PCC = \frac{\sum_{i = 1}^{n}{({C1}_{i} - \overline{{C1}_{n}})({C2}_{i} - \overline{{C2}_{n}})}}{\sqrt{\sum_{i = 1}^{n}{({C1}_{i} - \overline{{C1}_{n}})}^{2}\sum_{j = 1}^{n}{({C2}_{j} - \overline{{C2}_{n}})}^{2}}}
```

Where

>$`n`$ is the total number of pixels in the crop
>$`{C1}_{i}`$ is the intensity of pixel $`i`$ Channel 1
>$`{C2}_{i}`$ is the intensity of pixel $`i`$ Channel 2
>$`\overline{{C1}_{n}}`$ is the average intensity of all pixels in
Channel 1
>$`\overline{{C2}_{n}}`$ is the average intensity of all pixels in
Channel 2

### ROI Overlap Ratios

**R1_c1roiOverlapratio.csv**

The ROI Overlap Ratio R1 is the fraction of ROIs in channel 1 that have
a significant overlap with ROIs in channel 2, above a user-defined
Overlap Threshold. The Overlap Threshold is the minimum fraction of
pixel overlap that defines whether two ROIs are overlapping.

``` math
R1\  = \frac{\sum_{a}^{}{C1}_{a,coloc}}{N1}
```

Where:

> $`N1`$ is the number of ROIs detected in channel 2
>
> $`{C1}_{a,coloc} = 1`$ if ROI $`a`$ is considered to have significant
> overlap with ROIs in Channel 2 based on an Overlap Threshold of the
> percentage of its pixels thresholded as signal in Channel 2,
> $`{C1}_{a,coloc} = 0`$ otherwise

**R2_c2roiOverlapratio.csv**

The ROI Overlap Ratio R2 is the fraction of ROIs in channel 2 that have
a significant overlap with ROIs in channel 1, above a user-defined
Overlap Threshold. The Overlap Threshold is the minimum fraction of
pixel overlap that defines whether two ROIs are overlapping.

``` math
R2 = \frac{\sum_{b}^{}{C2}_{b,coloc}}{N2}
```

Where:

> $`N2`$ is the number of ROIs detected in channel 2
>
> $`{C2}_{b,coloc} = 1`$ if ROI $`b`$ is considered to have significant
> overlap with ROIs in Channel 1 based on an Overlap Threshold of the
> percentage of its pixels thresholded as signal in Channel 1,
> $`{C2}_{b,coloc} = 0`$ otherwise
