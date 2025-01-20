function [tiffStack, metadata] = importCaImgStack(dataPath, fileName, varargin)
    % Import and Adjust Calcium Imaging TIFF Stack
    %
    % Includes optional spatial downsampling with Gaussian smoothing.
    %
    % Parameters:
    % dataPath         - Path to the folder containing the TIFF file (required)
    % fileName         - Name of the TIFF file (required)
    % frameRate        - Frame rate of the imaging (Hz)
    % downsampleFactor - Spatial downsampling factor (default: 1, no downsampling)
    %
    % Returns:
    % tiffStack - A 3D matrix containing the processed TIFF stack
    % metadata  - A struct with metadata about the stack

    % Input parsing
    p = inputParser;
    addRequired(p, 'dataPath', @(x) ischar(x) || isstring(x));
    addRequired(p, 'fileName', @(x) ischar(x) || isstring(x));
    addOptional(p, 'frameRate', [], @(x) isnumeric(x) && x > 0);
    addOptional(p, 'downsampleFactor', 1, @(x) isnumeric(x) && x > 0 && x <= 1);

    parse(p, dataPath, fileName, varargin{:});

    dataPath = p.Results.dataPath;
    fileName = p.Results.fileName;
    frameRate = p.Results.frameRate;
    downsampleFactor = p.Results.downsampleFactor;

    % Full path
    fullPath = fullfile(dataPath, fileName);

    % Validate file
    if ~exist(fullPath, 'file')
        error('File does not exist: %s', fullPath);
    end

    % Load TIFF stack
    tiffInfo = imfinfo(fullPath);
    numFrames = numel(tiffInfo);
    firstFrame = imread(fullPath, 1);
    [rows, cols] = size(firstFrame);

    % Determine the appropriate data type from the TIFF metadata
    switch tiffInfo(1).BitDepth
        case 8
            dataType = 'uint8';
        case 16
            dataType = 'uint16';
        case 32
            dataType = 'single'; % For floating-point data
        otherwise
            error('Unsupported bit depth: %d', tiffInfo(1).BitDepth);
    end

    % Initialize stack with appropriate data type
    tiffStack = zeros(rows, cols, numFrames, dataType);

    for i = 1:numFrames
        tiffStack(:, :, i) = imread(fullPath, i);
    end

    % Apply Gaussian blurring and downsampling
    if downsampleFactor < 1
        sigma = 1; % Standard deviation for Gaussian kernel
        kernelSize = ceil(6 * sigma); % Cover 3 std devs on each side
        gFilter = fspecial('gaussian', [kernelSize kernelSize], sigma);

        % Precompute new dimensions for consistent allocation
        newRows = floor(rows * downsampleFactor);
        newCols = floor(cols * downsampleFactor);
        downsampledStack = zeros(newRows, newCols, numFrames, dataType);

        % Apply Gaussian filtering and resizing
        for i = 1:numFrames
            blurredFrame = imfilter(tiffStack(:, :, i), gFilter, 'replicate');
            resizedFrame = imresize(blurredFrame, [newRows, newCols], 'bilinear');
            downsampledStack(:, :, i) = cast(resizedFrame, dataType);
        end

        tiffStack = downsampledStack; % Replace the original stack with the downsampled version
    end

    % Metadata
    metadata = struct();
    metadata.dataPath = dataPath;
    metadata.fileName = fileName;
    metadata.fullPath = fullPath;
    metadata.frameRate = frameRate;
    metadata.downsampleFactor = downsampleFactor;
    metadata.numFrames = numFrames;

    % Display memory usage
    memUsageBytes = whos('tiffStack').bytes;
    memUsageMB = memUsageBytes / (1024^2); % Convert to MB
    fprintf('Memory usage after processing: %.2f MB.\n', memUsageMB);

    fprintf('Imported and processed %d frames from %s.\n', numFrames, fullPath);
    fprintf('Downsample factor: %.2f, Frame rate: %.2f Hz.\n', downsampleFactor, frameRate);
end
