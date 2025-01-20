function [roiList, traceData, projectionImage] = extractCaTracesFromFile(filename, pixelSize, minSomaSize, framerate, sensitivity)
% Extract calcium traces from a TIFF file
%
% Parameters:
% filename - Path to the TIFF file
% pixelSize - Pixel size in micrometers
% minSomaSize - minimum soma size in micrometers

% Import the TIFF stack
tiffStack = importCaImgTiff(filename);

% Define the downsample ratio (you can adjust this as needed)
downsampleRatio = 1;
pixelSize = pixelSize *downsampleRatio;

minSomaSizePixels = minSomaSize / pixelSize;

% Spatially downsample the image stack
downsampledStack = spatialDownsampleStack(tiffStack, downsampleRatio);

% Generate the standard deviation projection
stdProjection = makeStdProjection(downsampledStack);

% Adjust brightness and convert to 8-bit
projectionImage = adjustStackTo8b(stdProjection);

binaryImage = thresholdImageForSomataDetection(projectionImage, minSomaSizePixels, sensitivity);
% Generate ROI list from binary image
roiList = generateROIListFromBinaryImage(binaryImage);
if isempty(roiList)
    traceData = [];
else
    [traceData] = extractTracesFromROIs(downsampledStack, roiList);
end
% plotCaTracesFromROIdata(traceData, framerate);
% figure;
%  showCaImageWithROIs(projectionImage,  pixelSize, roiList);


end
