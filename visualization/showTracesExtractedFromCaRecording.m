function showTracesExtractedFromCaRecording(filename, framerate, varargin)
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
    %   'stimTimes2': Array of stimulation start times in seconds
    %   'stimDuration2': Duration of each stimulation in seconds
    %   'smoothTraces': whether we do simple denoise/detrend/normalize
    % example use: showTracesExtractedFromCaRecording('testData.mat', 20, 'smoothTraces', true, 'stimTimes', [10, 20, 30], 'stimDuration', 5, 'stimTimes2', [11, 21, 31], 'stimDuration2', 1, 'preWin', 2, 'postWin', 5);

    % input parsing; see https://www.mathworks.com/help/matlab/ref/inputparser.html
    p = inputParser;
    addRequired(p, 'filename', @ischar);
    addRequired(p, 'framerate', @isnumeric);
    addOptional(p, 'stimTimes', [], @isnumeric);
    addOptional(p, 'stimDuration', 0, @isnumeric);
    addOptional(p, 'preWin', 2, @isnumeric); % Default pre-window of 2 seconds
    addOptional(p, 'postWin', 5, @isnumeric); % Default post-window of 5 seconds
    addParameter(p, 'smoothTraces', true, @islogical);
    addParameter(p, 'stimTimes2', [], @isnumeric);
    addParameter(p, 'stimDuration2', 0, @isnumeric);

    parse(p, filename, framerate, varargin{:});

    smoothTraces = p.Results.smoothTraces;
    preWin = p.Results.preWin;
    postWin = p.Results.postWin;
    stimDuration = p.Results.stimDuration;
    stimTimes = p.Results.stimTimes;
    stimDuration2 = p.Results.stimDuration2;
    stimTimes2 = p.Results.stimTimes2;
    framerate = p.Results.framerate;

    % Load the data from the file using the custom read function
    [traceData, metadata] = readTraceData(filename);

    % Validate the loaded trace data
    [isValid, ~, ~] = validateTraceData(traceData);

    if ~isValid
        error('Trace data is invalid. Please check the data and try again.');
    end

    %smooth, normalize, detrend if requested
    if (smoothTraces)
        traceData = preprocessTraces(traceData, framerate, 'normalize', true, 'smooth', true, 'detrend', true);
        yAxisLabel = 'Fluorescence (Z-score)';
    else %always normalize to zscore
        traceData = normalize(traceData, 'zscore');
        yAxisLabel = 'Fluorescence (Z-score)';
    end

    if isempty(stimTimes)
        STIMULATION = false;
    else
        STIMULATION = true;
    end

    % Create a new figure
    figHandle = figure('Position', [100, 100, 1600, 400]); % Modify the size as needed

    % If there are stimulations in the data, create 4 subplots
    if STIMULATION
        NUMROWS = 2;
        NUMCOLS = 3;

        % if we have second stimulation,
        % calculate the delay used between plots
        if ~isempty(stimTimes2)
            SECONDSTIM = true;
            stimDelay = stimTimes2(1) - stimTimes(1);
        else
            SECONDSTIM = false;
            stimDelay = 0;
        end

        % Subplot for full traces with stimulations
        ax1 = subplot(NUMROWS, NUMCOLS, [1 2]);

        if (SECONDSTIM)
            plotCaTracesWithStim(traceData, framerate, 'stimTimes', p.Results.stimTimes, 'stimDuration', p.Results.stimDuration, 'stimTimes2', p.Results.stimTimes2, 'stimDuration2', p.Results.stimDuration2, 'plotTitle', 'Full trial traces', 'yAxisLabel', yAxisLabel, 'stim2Delay', stimDelay');
        else
            plotCaTracesWithStim(traceData, framerate, 'stimTimes', p.Results.stimTimes, 'stimDuration', p.Results.stimDuration, 'plotTitle', 'Full trial traces', 'yAxisLabel', yAxisLabel);
        end

        % Subplot for the triggered windows (per ROI)
        ax2 = subplot(NUMROWS, NUMCOLS, 3);
        triggeredWindows = extractTriggeredWindows(traceData, p.Results.stimTimes, p.Results.stimDuration, p.Results.preWin, p.Results.postWin, framerate);

        if (SECONDSTIM) % if there is another, delayed stimulus
            plotMeanTriggeredWindows(triggeredWindows, preWin, stimDuration, framerate, 'Stim-triggered means per ROI', 'axesHandle', gca, 'figHandle', figHandle, 'legendText', 'ROI', ...
                'stimDuration2', p.Results.stimDuration2, 'stim2Delay', stimDelay, 'yAxisLabel', yAxisLabel);
        else
            plotMeanTriggeredWindows(triggeredWindows, preWin, stimDuration, framerate, 'Stim-triggered means per ROI', 'axesHandle', gca, 'figHandle', figHandle, 'legendText', 'ROI', ...
                'yAxisLabel', yAxisLabel);
        end

        % Subplot for the triggered windows (per stim)
        ax3 = subplot(NUMROWS, NUMCOLS, 6);

        triggeredWindows = extractTriggeredWindows(traceData, p.Results.stimTimes, p.Results.stimDuration, p.Results.preWin, p.Results.postWin, framerate);
        triggeredPerStimWindows = permute(triggeredWindows, [1, 3, 2]);

        plotMeanTriggeredWindows(triggeredPerStimWindows, preWin, stimDuration, framerate, 'Mean Stim responses over all ROIs ', 'axesHandle', gca, 'figHandle', figHandle, 'legendText', 'STIM', ...
            'stimDuration2', p.Results.stimDuration2, 'stim2Delay', stimDelay, 'yAxisLabel', yAxisLabel);

        %subplot for wavelet spectrum
        ax4 = subplot(NUMROWS, NUMCOLS, [4 5]);
        plotWaveletSpectrum(traceData, framerate, 'axesHandle', ax4, 'stimTimes', stimTimes, 'stimDuration', stimDuration);

        % Apply custom figure style for all figures
        applyCustomFigureStyle(figHandle, [ax1, ax2, ax3, ax4]);
    else
        % Only 2 subplots for full traces without stimulations and the wavelet spectrum
        NUMROWS = 2;
        NUMCOLS = 1;
        ax1 = subplot(NUMROWS, NUMCOLS, 1);
        plotCaTracesFromROIdata(traceData, framerate, 'axesHandle', ax1, 'yAxisLabel', yAxisLabel, 'plotTitle', 'Full trial traces');
        ax2 = subplot(NUMROWS, NUMCOLS, 2);
        plotWaveletSpectrum(traceData, framerate, 'axesHandle', ax2);

        % Apply custom figure style
        applyCustomFigureStyle(figHandle, ax1);
        applyCustomFigureStyle(figHandle, ax2);
    end

    % Set the overall figure title or any additional properties
    sgtitle(figHandle, filename, 'Color', 'w'); % For MATLAB versions >= R2018b
end
