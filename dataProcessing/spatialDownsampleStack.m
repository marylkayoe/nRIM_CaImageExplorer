function downsampledStack = spatialDownsampleStack(imageStack, downsampleRatio)
    % Spatially downsample an image stack
    %
    % Parameters:
    % imageStack - A 3D matrix representing the TIFF stack (height x width x frames)
    % downsampleRatio - The ratio by which to downsample the image (e.g., 2 for half-size)

    % Get the size of the original stack
    [rows, cols, numFrames] = size(imageStack);

    % Calculate the new size after downsampling
    newRows = round(rows / downsampleRatio);
    newCols = round(cols / downsampleRatio);

    % Initialize the downsampled stack
    downsampledStack = zeros(newRows, newCols, numFrames, 'like', imageStack);

    % Apply Gaussian blurring and downsampling to each frame
    for i = 1:numFrames
        % Gaussian blurring
        blurredFrame = imgaussfilt(imageStack(:,:,i), downsampleRatio);

        % Downsampling
        downsampledStack(:,:,i) = imresize(blurredFrame, [newRows, newCols]);
    end
end
