function roiList = generateROIListFromBinaryImage(binaryImage)
    % Generate a list of ROIs from a binary image

    % Label connected components in the binary image
    [labeledImage, numROIs] = bwlabel(binaryImage);

    % Extract properties of labeled regions (ROIs)
    stats = regionprops(labeledImage, 'Centroid', 'BoundingBox', 'PixelList');

    if numROIs
    % Initialize an empty list to store ROI information
    roiList = struct('ID', [], 'Centroid', [], 'BoundingBox', []);

    % Loop through each ROI and store its properties
    for i = 1:numROIs
        roiList(i).ID = i;
        roiList(i).Centroid = stats(i).Centroid;
        roiList(i).BoundingBox = stats(i).BoundingBox;
        roiList(i).PixelList = stats(i).PixelList;
    end
    else
        warning(' no ROIS found with the parameters.');
        roiList = [];
    end
    
end
