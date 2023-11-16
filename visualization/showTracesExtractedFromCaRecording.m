function showCaRecording(filename, framerate, varargin)
    % showCaRecording: Generates a figure with subplots showing a calcium recording and, optionally, stimulus-triggered windows.
    % the stim-triggered windows are shown as both averages of each ROI and 
    %
    % Parameters:
    % filename - Name of the file containing calcium trace data
    % framerate - Sampling rate in Hz
    % varargin - Optional parameters including:
    %   'stimTimes': Array of stimulation start times in seconds
    %   'stimDuration': Duration of each stimulation in seconds
    %   'preWin': Pre-stimulation window duration in seconds
    %   'postWin': Post-stimulation window duration in seconds
    
    % Parse optional parameters
    p = inputParser;
    addRequired(p, 'filename', @ischar);
    addRequired(p, 'framerate', @isnumeric);
    addOptional(p, 'stimTimes', [], @isnumeric);
    addOptional(p, 'stimDuration', 0, @isnumeric);
    addOptional(p, 'preWin', 5, @isnumeric); % Default pre-window of 2 seconds
    addOptional(p, 'postWin', 5, @isnumeric); % Default post-window of 5 seconds
    
    parse(p, filename, framerate, varargin{:});
    
    % Load the data from the file using the custom read function
    [traceData, metadata] = readTraceData(filename);

    preWin = p.Results.preWin;
    postWin = p.Results.postWin;
    stimDuration = p.Results.stimDuration;
    stimTimes = p.Results.stimTimes;
    framerate = p.Results.framerate;
    NUMROWS = 1;
    NUMCOLS = 3;

    % Validate the loaded trace data
    [isValid, nROIs, nFrames] = validateTraceData(traceData);
    if ~isValid
        error('Trace data is invalid. Please check the data and try again.');
    end
    
    % Create a new figure
   % figHandle = figure;
    figHandle = figure('Position', [100, 100, 1600, 400]); % Modify the size as needed

    % If stimTimes is not empty, create two subplots
    if ~isempty(p.Results.stimTimes)
        % Subplot for full traces with stimulations
        ax1 = subplot(NUMROWS, NUMCOLS, 1); 
          plotCaTracesWithStim(traceData, framerate, 'stimTimes', p.Results.stimTimes, 'stimDuration', p.Results.stimDuration, 'plotTitle', 'Full trial traces');
        
        % Subplot for the triggered windows
        ax2 = subplot(NUMROWS, NUMCOLS, 2);
        triggeredWindows = extractTriggeredWindows(traceData, p.Results.stimTimes,  p.Results.stimDuration, p.Results.preWin, p.Results.postWin, framerate);
        plotMeanTriggeredWindows(triggeredWindows, preWin, stimDuration, framerate, 'Stim-triggered means per ROI', 'axesHandle', gca, 'figHandle', figHandle, 'legendText', 'ROI');
        
        % Subplot for the triggered windows
        ax3 = subplot(NUMROWS,NUMCOLS, 3);
       
        triggeredWindows = extractTriggeredWindows(traceData, p.Results.stimTimes,  p.Results.stimDuration, p.Results.preWin, p.Results.postWin, framerate);
        triggeredPerStimWindows = permute(triggeredWindows, [1, 3, 2]);

        plotMeanTriggeredWindows(triggeredPerStimWindows, preWin, stimDuration, framerate, 'Mean Stim responses over all ROIs ', 'axesHandle', gca, 'figHandle', figHandle, 'legendText', 'STIM');
        


        % Apply custom figure style
        applyCustomFigureStyle(figHandle, [ax1, ax2, ax3]);
    else
        % Only one subplot for full traces without stimulations
        ax1 = subplot(1, 2, 1);
        plotCaTraces(ax1, traceData, framerate);
        
        % Apply custom figure style
        applyCustomFigureStyle(figHandle, ax1);
    end
    
    % Set the overall figure title or any additional properties
    sgtitle(figHandle, filename, 'Color', 'w'); % For MATLAB versions >= R2018b
end