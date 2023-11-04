function plotCaTracesWithStim(traceData, framerate, varargin)

    %PLOT_CATRACES_WITH_STIM Plot calcium traces with overlaid stimulation periods.
    %
    %   PLOT_CATRACES_WITH_STIM(traceData, framerate) plots the calcium imaging
    %   traces with time on the x-axis and fluorescence intensity on the y-axis.
    %
    %   PLOT_CATRACES_WITH_STIM(..., 'stimTimes', STIMTIMES, 'stimDuration', STIMDURATION)
    %   allows specifying stimulation times and durations to overlay on the plot.
    %
    %   PLOT_CATRACES_WITH_STIM(..., 'plotTitle', TITLE) allows setting a custom
    %   title for the plot.
    %
    %   Input parameters:
    %   traceData     - Matrix of calcium trace data where each column is a trace from a single ROI.
    %   framerate     - Acquisition framerate in Hz.
    %
    %   Optional name-value pairs:
    %   'stimTimes'   - Array of stimulation start times in seconds.
    %   'stimDuration'- Duration of each stimulation period in seconds.
    %   'plotTitle'   - String for the plot's title.
    %
    %   Examples:
    %   plotCaTracesWithStim(traceData, 20);
    %   plotCaTracesWithStim(traceData, 20, 'stimTimes', [30, 60, 90], 'stimDuration', 5);
    %   plotCaTracesWithStim(traceData, 20, 'plotTitle', 'Calcium Traces with Stimulations');

    %% Validate inputs and set defaults if necessary
    defaultStimTimes = [];
    defaultStimDuration = [];
    defaultAxesHandle = [];
    defaultPlotTitle = 'Calcium Traces with Stimulation';

    %% parsing inputs
    params = inputParser;

    % Mandatory parameters
    addRequired(params, 'traceData', @(x) validateattributes(x, {'numeric'}, {'2d', 'nonempty'}));
    addRequired(params, 'framerate', @(x) validateattributes(x, {'numeric'}, {'positive', 'scalar'}));

    % Optional parameters
    addOptional(params, 'stimTimes', defaultStimTimes, @(x) validateattributes(x, {'numeric'}, {'vector', 'nonnegative'}));
    addOptional(params, 'stimDuration', defaultStimDuration, @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'scalar'}));
    addOptional(params, 'axesHandle', defaultAxesHandle, @(x) isempty(x) || isa(x, 'matlab.graphics.axis.Axes'));
    addOptional(params, 'plotTitle', defaultPlotTitle, @(x) validateattributes(x, {'char', 'string'}, {'scalartext'}));

    % Parse the inputs
    parse(params, traceData, framerate, varargin{:});

    % Extract the parameters
    stimTimes = params.Results.stimTimes;
    stimDuration = params.Results.stimDuration;
    axesHandle = params.Results.axesHandle;
    plotTitle = params.Results.plotTitle;

    % Make new figure if axesHandle is empty
    if isempty(axesHandle)
        figure; 
        axesHandle = gca; 
    end

    % Call the function to plot calcium traces in our figure
    plotCaTracesFromROIdata(traceData, framerate, axesHandle);

    % Overlay stimulation periods if provided
    if ~isempty(stimTimes) && ~isempty(stimDuration)
        hold(axesHandle, 'on');

        for i = 1:length(stimTimes)
            % Calculate the x coordinates for the left and right edges of the rectangle
            xLeft = stimTimes(i);
            xRight = stimTimes(i) + stimDuration;

            % The y coordinates are the limits of the y axis
            yLimits = ylim(axesHandle);

            % Define the rectangle's position and size
            pos = [xLeft, yLimits(1), xRight - xLeft, yLimits(2) - yLimits(1)];

            % Draw the rectangle with some transparency
            rectangle('Position', pos, 'FaceColor', [0.9 0.9 0.9 0.5], 'EdgeColor', 'none', 'Parent', axesHandle);
        end

        hold(axesHandle, 'off');
    end

    % Set plot title
    title(axesHandle, plotTitle);
    % Additional customization
    % Set axes labels and customize the look of the plot
    xlabel(axesHandle, 'Time (s)');
    ylabel(axesHandle, 'Fluorescence Intensity (a.u.)');
    set(axesHandle, 'Box', 'off', 'TickDir', 'out'); % Aesthetic preference for axes
end
