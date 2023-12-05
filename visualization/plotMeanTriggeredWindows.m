function plotMeanTriggeredWindows(triggeredWindows, preWin, stimDuration, framerate, plotTitle, varargin)
% plotMeanTriggeredWindows Plots mean triggered windows for each ROI and the grand average.
%
% Parameters:
% triggeredWindows - 3D array of triggered windows (time x windows x ROIs)
% preWin - Pre-stimulation window duration in seconds; note it is assumed to match the preWin used to generate the triggered windows
% stimDuration - Duration of stimulation in seconds
% postWin - Post-stimulation window duration in seconds
% framerate - Sampling rate in Hz
% plotTitle - Title for the plot
% optional parameters:
% stim2Delay - delay of second stimulation in seconds with respect to first stimulation
% stimDuration2 - duration of second stimulation in seconds
% axesHandle - Handle to axes to plot on
% figHandle - Handle to figure to plot on
% legendText - Text to use for legend
% example use: plotMeanTriggeredWindows(triggeredWindows, preWin, stimDuration, framerate, 'Ca recording', 'stim2Delay', 10, 'stimDuration2', 5, 'legendText', 'ROI');



  % Validate input dimensions
    assert(ndims(triggeredWindows) == 3, 'triggeredWindows must be a 3D array (time x windows x ROIs).');

    % Set up input parser for optional parameters
    p = inputParser;
    addRequired(p, 'triggeredWindows', @(x) validateattributes(x, {'numeric'}, {'3d', 'nonempty'}));
    addRequired(p, 'preWin', @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'scalar'}));
    addRequired(p, 'stimDuration', @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'scalar'}));
    addRequired(p, 'framerate', @(x) validateattributes(x, {'numeric'}, {'positive', 'scalar'}));
    % 
    addOptional(p, 'plotTitle', 'Ca recording', @(x) validateattributes(x, {'char', 'string'}, {'scalartext'}));
    addOptional(p, 'axesHandle', gca, @(x) isempty(x) || isa(x, 'matlab.graphics.axis.Axes'));
    addOptional(p, 'legendText','ROI', @(x) validateattributes(x, {'char', 'string'}, {'scalartext'}));
   addParameter(p, 'figHandle', [], @(x) isempty(x) || isa(x, 'matlab.ui.Figure'));
   addParameter(p, 'stim2Delay', 0,  @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'scalar'}));
   addParameter(p, 'stimDuration2', 0,  @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'scalar'}));
    parse(p, triggeredWindows, preWin, stimDuration, framerate, plotTitle, varargin{:});

    % Extract the parameters after parsing
    triggeredWindows = p.Results.triggeredWindows;
    preWin = p.Results.preWin;
    stimDuration = p.Results.stimDuration;
    stim2Delay = p.Results.stim2Delay;
    stimDuration2 = p.Results.stimDuration2;
    framerate = p.Results.framerate;
    plotTitle = p.Results.plotTitle;
    axesHandle = p.Results.axesHandle;
    figHandle = p.Results.figHandle;
    legendText = p.Results.legendText;

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
drawStimulationRectangle(axesHandle, 0, stimDuration, ylim(axesHandle));

if (stimDuration2>0) % is larger than 0
    drawStimulationRectangle(axesHandle, stim2Delay, stimDuration2, ylim(axesHandle),[0.9, 0, 0], 0.6 );
end


% Apply the custom figure style
applyCustomFigureStyle(figHandle, axesHandle);

% Create legend
legendLabels = arrayfun(@(x) sprintf([legendText '%d'], x), 1:numROIs, 'UniformOutput', false);
legendLabels = legendLabels';
legendHandle = legend([plotHandles; grandMeanHandle], [legendLabels; {'Grand Average'}], 'TextColor', 'white', 'Location','eastoutside');
set(legendHandle, 'FontSize', 8); % Adjust the font size as needed
axis("tight");
% Set title with custom color
titleHandle = title(axesHandle, plotTitle);
set(titleHandle, 'Color', 'w'); % Set title color to white

% Hold off the plotting
hold(axesHandle, 'off');
end
