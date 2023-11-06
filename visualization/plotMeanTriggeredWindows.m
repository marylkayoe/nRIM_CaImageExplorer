function plotMeanTriggeredWindows(triggeredWindows, preWin, stimDuration, framerate, plotTitle, varargin)
% plotMeanTriggeredWindows Plots mean triggered windows for each ROI and the grand average.
%
% Parameters:
% triggeredWindows - 3D array of triggered windows (time x windows x ROIs)
% preWin - Pre-stimulation window duration in seconds
% stimDuration - Duration of stimulation in seconds
% postWin - Post-stimulation window duration in seconds
% framerate - Sampling rate in Hz
% plotTitle - Title for the plot

  % Validate input dimensions
    assert(ndims(triggeredWindows) == 3, 'triggeredWindows must be a 3D array (time x windows x ROIs).');

    % Set up input parser for optional parameters
    p = inputParser;
    addRequired(p, 'triggeredWindows', @(x) validateattributes(x, {'numeric'}, {'3d', 'nonempty'}));
    addRequired(p, 'preWin', @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'scalar'}));
    addRequired(p, 'stimDuration', @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'scalar'}));
    addRequired(p, 'framerate', @(x) validateattributes(x, {'numeric'}, {'positive', 'scalar'}));
    addOptional(p, 'plotTitle', 'Ca recording', @(x) validateattributes(x, {'char', 'string'}, {'scalartext'}));
    addOptional(p, 'axesHandle', gca, @(x) isempty(x) || isa(x, 'matlab.graphics.axis.Axes'));
   addParameter(p, 'figHandle', [], @(x) isempty(x) || isa(x, 'matlab.ui.Figure'));
    parse(p, triggeredWindows, preWin, stimDuration, framerate, plotTitle, varargin{:});

    % Extract the parameters after parsing
    triggeredWindows = p.Results.triggeredWindows;
    preWin = p.Results.preWin;
    stimDuration = p.Results.stimDuration;
    framerate = p.Results.framerate;
    plotTitle = p.Results.plotTitle;
    axesHandle = p.Results.axesHandle;
    figHandle = p.Results.figHandle;

    if isempty(axesHandle) || ~isvalid(axesHandle)
     %   figHandle = figure;
        axesHandle = axes(figHandle);
    end
% Set the x-axis using the utility function
xAxis = makeXAxisFromFrames(size(triggeredWindows, 1), framerate, 'seconds') - preWin;


meanTraces = squeeze(mean(triggeredWindows, 2, 'omitnan'));
%each trace shifted to be aligned in y
alignedMeanTraces = bsxfun(@minus, meanTraces, meanTraces(sec2frames(preWin, framerate), :));


% Calculate grand average across all ROIs
grandMeanTrace = mean(alignedMeanTraces, 2, 'omitnan');

% Hold on to plot multiple traces
hold(axesHandle, 'on');

% Generate a colormap for the traces
numROIs = size(triggeredWindows, 3);
cmap = generateCustomColormap(numROIs);

% Plot each mean trace for ROIs
for i = 1:numROIs
    plotHandles(i) = plot(xAxis, alignedMeanTraces(:, i), 'Color', cmap(i, :), 'LineWidth', 1.5);
end
plotHandles = plotHandles';
% Plot the grand mean trace
grandMeanHandle =  plot(xAxis, grandMeanTrace, 'w-', 'LineWidth', 2.5); % white and thicker line

% Customize the plot
xlabel(axesHandle, 'Time (s)');
ylabel(axesHandle, 'Mean Fluorescence (a.u.)');
title(axesHandle, plotTitle);

% Draw stimulation rectangle
drawStimulationRectangle(axesHandle, stimDuration, ylim(axesHandle));

% Apply the custom figure style
applyCustomFigureStyle(figHandle, axesHandle);

% Create legend
legendLabels = arrayfun(@(x) sprintf('ROI %d', x), 1:numROIs, 'UniformOutput', false);
legendLabels = legendLabels';
legend([plotHandles; grandMeanHandle], [legendLabels; {'Grand Average'}], 'TextColor', 'white', 'Location','eastoutside');


% Set title with custom color
titleHandle = title(axesHandle, plotTitle);
set(titleHandle, 'Color', 'w'); % Set title color to white

% Hold off the plotting
hold(axesHandle, 'off');
end
