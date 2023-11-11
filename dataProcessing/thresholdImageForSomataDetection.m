function binaryImage = thresholdImageForSomataDetection(image, somaDiameterPixels)
    % thresholdImageForSomataDetection Applies adaptive thresholding to detect somata
    %
    % This function performs adaptive thresholding on an image to detect bright 
    % regions corresponding to somata in calcium imaging data. It first applies 
    % adaptive thresholding and then cleans the resulting binary image to select 
    % regions of appropriate size.
    %
    % Parameters:
    %   image: A 2D matrix representing the grayscale image (e.g., a standard 
    %          deviation projection of a calcium imaging stack).
    %   somaDiameterPixels: Estimated diameter of a soma in pixels. This is used 
    %                       to set the neighborhood size for adaptive thresholding 
    %                       and to filter out regions of inappropriate size.
    %
    % Returns:
    %   binaryImage: A binary image where bright regions likely to be somata 
    %                are marked.
% Calculate neighborhood size
neighborhoodSize = round(somaDiameterPixels * 1.5);

% Ensure neighborhood size is odd
if mod(neighborhoodSize, 2) == 0
    neighborhoodSize = neighborhoodSize + 1;
end

%first simple thresholding
thresholdValue = adaptthresh(image, 'ForegroundPolarity','bright', 'NeighborhoodSize', neighborhoodSize);

% Create a binary image by applying the threshold
globalThresholdedImage = imbinarize(image, thresholdValue);

% Additional processing selects regions of appropriate size
cleanedBinaryImage = cleanBinaryImageForCellDetection(globalThresholdedImage, somaDiameterPixels/2);

binaryImage = cleanedBinaryImage;
end
