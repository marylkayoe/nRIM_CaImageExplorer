function cleanedBinaryImage = cleanBinaryImageForCellDetection(binaryImage, minSomaDiameterPixels)
    % cleanBinaryImageForCellDetection Cleans a binary image for cell detection
    %
    % This function performs a series of morphological operations to refine a 
    % binary image. It is specifically designed to improve the detection of 
    % cell-like structures (somata) by removing noise, filling gaps, and 
    % filtering based on size and shape. The function uses morphological 
    % opening and closing to clean the image, followed by size filtering and 
    % circularity analysis to isolate individual cell-like objects.
    %
    % Parameters:
    %   binaryImage: A binary image where cells are expected to be bright 
    %                (logical matrix).
    %   minSomaDiameterPixels: The minimum diameter of a cell in pixels. 
    %                          This value is used to define the size of the 
    %                          structural element for morphological operations 
    %                          and to set thresholds for size filtering.
    %
    % Returns:
    %   cleanedBinaryImage: A binary image where cell-like structures are 
    %                       isolated and refined (logical matrix).
% Define the structural element for morphological operations
se = strel('disk', round(minSomaDiameterPixels/2));  % Adjust the size as needed

% Noise removal (morphological opening)
openedImage = imopen(binaryImage, se);

% Filling gaps (morphological closing)
closedImage = imclose(openedImage, se);

    % Dilation to slightly expand the ROIs
   % dilatedImage = imdilate(closedImage, strel('disk', 1));  % Adjust the dilation size as needed


% Size filtering
minCellArea = pi * (minSomaDiameterPixels/2)^2;  % Minimum area based on expected cell radius
maxCellArea = 16 * minCellArea;  % Allow some variation in size
sizeFilteredImage = bwareafilt(closedImage, [minCellArea, maxCellArea]);

% Label connected components
[labeledImage, numObjects] = bwlabel(sizeFilteredImage);
stats = regionprops(labeledImage, 'Area','Circularity');

% Initialize an empty image to store refined ROIs
refinedBinaryImage = false(size(binaryImage));

for k = 1:numObjects
    % Extract individual object
    singleObject = (labeledImage == k);

    % Calculate circularity
    area = stats(k).Area;
    circularity = stats(k).Circularity;
    % Check if the object is likely to be a single cell
    if circularity > 0.4 && area > minCellArea
        % Add to the refined binary image
        refinedBinaryImage = refinedBinaryImage | singleObject;
    end
end


% Return the cleaned binary image
cleanedBinaryImage = refinedBinaryImage;
end
