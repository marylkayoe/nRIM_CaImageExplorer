function plotCaTracesFromROIdata(traceData, framerate, varargin)
% plotCaTracesFromROIdata Plots calcium traces for each region of interest (ROI) from given trace data.
%
% This function visualizes the calcium imaging traces for each ROI. It normalizes 
% and vertically offsets the traces for clear visualization. The traces are colored 
% uniquely for each ROI.
%
% Parameters:
%   traceData - A 2D matrix containing calcium traces. Rows represent time points, 
%               and columns represent different ROIs.
%   framerate - The sampling rate of the imaging in Hz.
%
% Optional Parameters:
%   axesHandle - The axes handle where the plot will be drawn. If not provided, 
%                a new figure and axes will be created.
%   plotTitle  - Title for the plot. Default is 'Calcium traces'.
%
% Example Usage:
%   plotCaTracesFromROIdata(traceData, framerate);
%   plotCaTracesFromROIdata(traceData, framerate, 'axesHandle', ax, 'plotTitle', 'My Calcium Traces');
%
% Notes:
%   - The function checks for the orientation of the traceData and transposes it if necessary.
%   - Each trace is normalized and offset for visual clarity.
%   - The function applies a custom figure style for consistency.
%
% See also: generateCustomColormap, makeXAxisFromFrames, applyCustomFigureStyle

% Validate mandatory inputs
validateattributes(traceData, {'numeric'}, {'2d', 'nonempty'}, mfilename, 'traceData');
validateattributes(framerate, {'numeric'}, {'positive', 'scalar', 'nonempty'}, mfilename, 'framerate');

% Create an inputParser instance
p = inputParser;

% Define default values for optional parameters
defaultAxesHandle = [];
defaultPlotTitle = 'Calcium traces';

% Add optional parameters to the input parser
addOptional(p, 'axesHandle', defaultAxesHandle, @(x) isempty(x) || isa(x, 'matlab.graphics.axis.Axes'));
addOptional(p, 'plotTitle', defaultPlotTitle, @ischar);

% Parse the input arguments
parse(p, varargin{:});

% Retrieve the parameters
axesHandle = p.Results.axesHandle;
plotTitle = p.Results.plotTitle;

% Create a new figure if no axes handle was provided
if isempty(axesHandle)
    figure;
    axesHandle = gca;
end
% Check if the data orientation is correct: time points should be in columns
if size(traceData, 1) < size(traceData, 2)
    % If there are more columns than rows, we may need to transpose the data
    warning('Transposing the ''traceData'' matrix to match expected orientation: time points in columns.');
    traceData = traceData';
end


% Determine the number of ROIs
numROIs = size(traceData, 2); % ROIS in columns
nFRAMES = size(traceData, 1);

% Generate the colormap using the utility function
cmap = generateCustomColormap(numROIs);

% Set up the figure and axes if not provided
if nargin < 3 || isempty(axesHandle)
    figure;
    axesHandle = gca;
else
    validateattributes(axesHandle, {'matlab.graphics.axis.Axes'}, {}, mfilename, 'axesHandle');
end


% Generate x-axis for the plot based on the number of frames and framerate
xAx = makeXAxisFromFrames(nFRAMES, framerate);  % Assuming the number of columns represents the number of frames

hold(axesHandle, 'on'); % Hold on to plot multiple traces

% Define the fixed shift amount between each trace
shiftAmount = 1;  % You may want to adjust this based on your data

for i = 1:numROIs
    % Normalize the trace to its range
    trace = traceData(:, i);
    trace = trace - min(trace);
    trace = trace / max(trace);

    % Offset the trace vertically to prevent overlap
    trace = trace + (i-1) * shiftAmount;

    % Plot the trace with the corresponding color and offset
    plot(axesHandle, xAx, trace, 'Color', cmap(i, :), 'LineWidth', 2);

    % Label the trace with the ROI number
    text(xAx(end)+10, trace(1), sprintf('%d', i), ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', ...
        'Color', cmap(i, :), 'FontSize', 12);
end

% After your plotting loop, add this code
maxTraceLabelY = max(get(gca, 'YLim'));  % Get the maximum y-axis limit
text('Units', 'normalized', 'Position', [0.95, 0.98], 'String', 'ROI', ...
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', ...
     'Color', 'w', 'FontSize', 12, 'Parent', axesHandle);  % Adjust color and font size as needed

% Set the background color to black

hold(axesHandle, 'off');
% Set axes labels and title...
xlabel(axesHandle, 'Time (s)', 'Color', 'w'); % Set X-axis label color to white
ylabel(axesHandle, 'Fluorescence (a.u.)', 'Color', 'w'); % Set Y-axis label color to white
title(axesHandle, plotTitle, 'Color', 'w'); % Set title text color to white
applyCustomFigureStyle(gcf, axesHandle);


end
