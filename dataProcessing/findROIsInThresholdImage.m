function rois = findROIsInProjectionImage(projectionImage, pixelSize, maxDiameterThreshold)
    % Apply thresholding
    binaryImage = thresholdImage(projectionImage);

    % Morphological operations
    binaryImage = performMorphology(binaryImage);

    % Label connected components
    labeledImage = bwlabel(binaryImage);

    % Initialize ROI data structure
    rois = initializeROIDataStructure();

    % Iterate over each labeled region
    for each labeled region in labeledImage
        % Calculate area and diameter
        area = calculateArea(region);
        diameter = 2 * sqrt(area / pi);

        % Convert diameter to micrometers
        diameterInMicrometers = diameter * pixelSize;

        % Filter based on diameter
        if diameterInMicrometers <= maxDiameterThreshold
            % Add ROI to data structure
            rois = addROI(rois, region, diameterInMicrometers);
        end
    end

    return rois;
end
