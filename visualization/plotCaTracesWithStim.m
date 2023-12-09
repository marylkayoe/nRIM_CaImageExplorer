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
    %  'axesHandle'  - Handle to the axes to plot in.
    % 'stimTimes2'   - Array of stimulation start times in seconds.
    %   'stimDuration2'- Duration of each stimulation period in seconds.
    %   'plotTitle'   - String for the plot's title.
    %
    %   Examples:
    %   plotCaTracesWithStim(traceData, 20);
    %   plotCaTracesWithStim(traceData, 20, 'stimTimes', [30, 60, 90], 'stimDuration', 5);
    %   plotCaTracesWithStim(traceData, 20, 'plotTitle', 'Calcium Traces with Stimulations');

    %% Validate inputs and set defaults if necessary
    % Validate inputs and set defaults
    p = inputParser;
    
    % Mandatory parameters
    addRequired(p, 'traceData', @(x) validateattributes(x, {'numeric'}, {'2d', 'nonempty'}));
    addRequired(p, 'framerate', @(x) validateattributes(x, {'numeric'}, {'positive', 'scalar'}));
    
    % Optional parameters with default values
    addParameter(p, 'stimTimes', [], @(x) validateattributes(x, {'numeric'}, {'vector', 'nonnegative'}));
    addParameter(p, 'stimDuration', [], @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'scalar'}));

 addParameter(p, 'stimTimes2', [], @(x) validateattributes(x, {'numeric'}, {'vector', 'nonnegative'}));
    addParameter(p, 'stimDuration2', [], @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'scalar'}));
   
addParameter(p, 'yAxisLabel', 'Fluorescence (a.u.)', @ischar);
    addParameter(p, 'axesHandle', gca, @(x) isempty(x) || isa(x, 'matlab.graphics.axis.Axes'));
    addParameter(p, 'plotTitle', 'Calcium Traces with Stimulation', @(x) validateattributes(x, {'char', 'string'}, {'scalartext'}));
    
    % Parse input arguments
    parse(p, traceData, framerate, varargin{:});
    
    % Extract variables from parsed input
    stimTimes = p.Results.stimTimes;
    stimDuration = p.Results.stimDuration;

    stimTimes2 = p.Results.stimTimes2;
    stimDuration2 = p.Results.stimDuration2;
yAxisLabel = p.Results.yAxisLabel;
    axesHandle = p.Results.axesHandle;
    plotTitle = p.Results.plotTitle;
    
    % Call the function to plot calcium traces in our figure
    plotCaTracesFromROIdata(traceData, framerate, 'axesHandle', axesHandle, 'yAxisLabel', yAxisLabel);



 % Overlay stimulation periods if provided
 if ~isempty(stimTimes) && ~isempty(stimDuration)
     stimWindowColor = [0.9 0.9 0.9];
     if stimDuration < 0.5
         stimWindowColor = [1 1 1];
         stimWindowOpacity = 1;
     else
stimWindowOpacity = 0.5;
     end
    hold(axesHandle, 'on');
    for i = 1:length(stimTimes)
        % The y coordinates are the limits of the y axis
        yLimits = ylim(axesHandle);

        % Define the rectangle's position and duration
        stimStart = stimTimes(i);

        % Draw the rectangle for each stimulation period
        drawStimulationRectangle(axesHandle, stimStart, stimDuration, yLimits, stimWindowColor, stimWindowOpacity); 
    end
    hold(axesHandle, 'off');
 end

  % Overlay stimulation periods if provided
 if ~isempty(stimTimes2) && ~isempty(stimDuration2)
     stimWindowColor = [1 0 0];
stimWindowOpacity = 0.9;
    hold(axesHandle, 'on');
    for i = 1:length(stimTimes)
        % The y coordinates are the limits of the y axis
        yLimits = ylim(axesHandle);

        % Define the rectangle's position and duration
        stimStart = stimTimes2(i);

        % Draw the rectangle for each stimulation period
        drawStimulationRectangle(axesHandle, stimStart, stimDuration2, yLimits, stimWindowColor, stimWindowOpacity); 
    end
    hold(axesHandle, 'off');
end


    % Set plot title
    title(axesHandle, plotTitle);
    % Additional customization
    % Set axes labels and customize the look of the plot
    xlabel(axesHandle, 'Time (s)');
    ylabel(axesHandle, yAxisLabel);
    set(axesHandle, 'Box', 'off', 'TickDir', 'out'); % Aesthetic preference for axes
end
