function tiffStack = importCaImgTiff(filename)
    % Import and Adjust TIFF Stack OLD VERSION
    %
    % Parameters:
    % filename - Path to the TIFF file
    %
    % Returns:
    % tiffStack - A 3D matrix containing the adjusted TIFF stack

    % Check if the file exists
    if ~exist(filename, 'file')
        error('File does not exist: %s', filename);
    end

    % Validate that the file is a TIFF
    [~, ~, ext] = fileparts(filename);
    if ~strcmpi(ext, '.tif') && ~strcmpi(ext, '.tiff')
        error('The file is not a TIFF image.');
    end

    % Read the TIFF file
    tiffInfo = imfinfo(filename); % Get information about the TIFF file
    numFrames = numel(tiffInfo);  % Number of frames in the stack
    firstFrame = imread(filename, 1); % Read the first frame to get dimensions
    [rows, cols] = size(firstFrame);

    % Initialize the stack
    tiffStack = zeros(rows, cols, numFrames, 'double');

    % Import each frame
    for i = 1:numFrames
         tiffStack(:,:,i) = imread(filename, i); % Read each frame
    end

end
