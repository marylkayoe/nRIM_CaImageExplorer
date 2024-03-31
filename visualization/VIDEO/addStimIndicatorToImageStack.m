function newStack = addStimIndicatorToImageStack(imageStack, varargin)
    % Adds a stimulus indicator to an image stack
    % useful when you want to add a symbol to your image stack to indicate
    % when a stimulus was presented (e.g. when making a video of the recording)
    % if two stimuli are to be indicated, the function will add two separate symbols based on
    % the frames indicated in
    % Inputs
    % imageStack: a 3D matrix of images (required)
    % varargin: a list of arguments
    %   'stimTimes' (required): a matrix of frame indices when the stimulus is to be indicated; if it's a cell array, each element contains frames
    % related to a different stimulus
    %
    %  'stimSymbol' (optional): string (or array of strings) describing the symbol to be used to indicate the stimulus
    % can be either 'circle' or 'square'. Default is 'circle'
    % 'symbolColor' (optional): string (or array of strings) with desired color (red, blue, green, white). Default is 'red'
    % 'location' (optional): string (or array of strings) with desired location of the symbol (topLeft, topRight, bottomLeft, bottomRight). Default is 'topLeft'
    % 'symbolSize' (optional): scalar (or array of scalars) with desired size of the symbol (percent of image height). Default is 10.
    %
    % Outputs
    % newStack: a 3D matrix of images with the stimulus indicator added

    % parse inputs
    p = inputParser;
    p.addRequired('imageStack', @isnumeric);
    % stimTimes is either an array or cell array of numeric arrays
    p.addRequired('stimTimes', @(x) isnumeric(x) || iscell(x));
    p.addParameter('stimSymbol', 'circle', @ischar);
    p.addParameter('symbolColor', 'white', @ischar); % not used, only white is implemented
    p.addParameter('location', 'topLeft', @ischar); % not used yet
    p.addParameter('symbolSize', 10, @isnumeric); % in percent of image height
    p.parse(imageStack, varargin{:});

    newStack = p.Results.imageStack;

    % check if stimTimes is a 2D matrix and get the number of stimuli
    if size(p.Results.stimTimes, 2) > 1
        nStim = size(p.Results.stimTimes, 2);
    else
        nStim = 1;
    end

    % get the number of frames in the image stack
    nFrames = size(p.Results.imageStack, 3);

    % get the size of the image stack
    [height, width, ~] = size(p.Results.imageStack);

    % for one stimulus
    % calculate the center position of the symbol so that it will be at symbolSize % of the image height
    % from the top and left edge of the image
    % (adding functionality of different locations of the symbol is possible but not implemented yet)
    symbolX = round (width * symbolSize / 100);
    symbolY = round (height * symbolSize / 100);

    % set the color
    switch symbolColor
        case 'red'
            color = [255, 0, 0];
        case 'blue'
            color = [0, 0, 255];
        case 'green'
            color = [0, 255, 0];
        case 'white'
            color = [255, 255, 255];
        otherwise
            color = [255, 0, 0];
    end

    % get the maximum pixel value in the image stack (across all frames)
    maxPixelValue = max(newStack(:));

    % calculate the circle pixels
    switch stimSymbol
        case 'circle'
            % create a circle
            [x, y] = meshgrid(1:width, 1:height);
            % circle around the symbolX and symbolX coordinates
            symbolShape = sqrt((x - symbolX) .^ 2 + (y - symbolY) .^ 2) <= symbolSize;
        case 'square'
            % create a square
            symbolShape = zeros(height, width);
            symbolShape(centerY - symbolY:symbolY + radius, symbolX - radius:symbolX + radius) = 1;
    end

    % loop through the frames indicated in stimTimes

    for frame = stimTimes
        frameImage = newStack(:, :, frame);
        % add the symbol to the image
        frameImage(symbolShape) = maxPixelValue;
        % copy the frame back to the image stack
        % note this is inefficient but makes it easier to read than doing it
        % in a single line such as
        % newStack(:, :, frame)(symbolShape) = maxPixelValue;
        newStack(:, :, frame) = frameImage;
    end

end
