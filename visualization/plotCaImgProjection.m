function plotCaImgProjection(projectionImg, pixelSize, varargin)
    % Plot STD Projection Figure
    %
    % Parameters:
    % projectionImg - A 2D matrix containing projection image
    % pixelSize - Size of a pixel in micrometers
    % varargin - Variable input arguments (including axesHandle, title)

    % Create an inputParser instance
    p = inputParser;

    % Define default values for optional parameters
    defaultAxesHandle = gca;
    defaultTitle = ''; % Default is an empty title

    % Add optional parameters to the input parser
    addParameter(p, 'axesHandle', defaultAxesHandle, @(x) isa(x, 'matlab.graphics.axis.Axes'));
    addParameter(p, 'title', defaultTitle, @ischar); % Add the title parameter

    % Parse the input arguments
    parse(p, varargin{:});

    % Retrieve the parameters
    axesHandle = p.Results.axesHandle;
    plotTitle = p.Results.title;

    [ySize xSize] = size(projectionImg);

    % Plot STD projection
    imshow(projectionImg, [], 'Parent', axesHandle);
    colormap(axesHandle, 'gray');
    axis(axesHandle, 'on');

    % Add scale bar
    scaleBarLengthMicrometers = round(0.1 * size(projectionImg, 2) * pixelSize); % 10% of image width
    scaleBarLengthPixels = round(scaleBarLengthMicrometers / pixelSize);
    %hold(axesHandle, 'on');
    maxDimension = max(size(projectionImg));
    barPosition = [xSize - scaleBarLengthPixels - 10, ySize - 10, scaleBarLengthPixels, 5];
    rectangle('Position', barPosition, 'EdgeColor', 'white', 'FaceColor', 'white', 'Parent', axesHandle);

    % Add label to scale bar
    text(barPosition(1) + barPosition(3)/2, barPosition(2) - 10, sprintf('%d \x3BCm', scaleBarLengthMicrometers), ...
         'Color', 'white', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Parent', axesHandle);

    title (plotTitle);
    set(axesHandle, 'XTick', [], 'YTick', []);

end
