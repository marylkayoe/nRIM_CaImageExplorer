function showCaImageWithROIs(image, pixelSize, roiList)
     % showCaImageWithROIs Displays an image with overlaid ROI bounding boxes
    %
    % This function takes an image and a list of ROIs, then overlays the ROI 
    % bounding boxes on the image for visualization purposes. It is useful for 
    % verifying the accuracy of ROI detection in calcium imaging data.
    %
    % Parameters:
    %   image: A 2D matrix representing the image (e.g., a projection of a 
    %          calcium imaging stack).
    %   pixelSize: The size of a pixel in micrometers. Used for scaling the 
    %              image properly.
    %   roiList: A structure array containing the ROIs. Each element in the 
    %            array should have fields 'BoundingBox', 'Centroid', and 'ID', 
    %            which describe the properties of each ROI.
     plotCaImgProjection(image, pixelSize, 'title', 'Projection with ROIs');
    hold on;

    % Loop through each ROI and draw its bounding box
    for i = 1:length(roiList)
        rectangle('Position', roiList(i).BoundingBox, 'EdgeColor', 'r');
        text(roiList(i).Centroid(1), roiList(i).Centroid(2), num2str(roiList(i).ID), ...
             'Color', 'yellow', 'HorizontalAlignment', 'center');
    end


    hold off;
end
