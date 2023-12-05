function showCaTracesFromRecording(filename, pixelSize, minSomaSize, framerate, varargin)
    % showCaTracesFromRecording Visualizes calcium traces from a TIFF file
    %
    % This function processes a calcium imaging TIFF file to extract and
    % visualize calcium traces. It can optionally handle stimulation times
    % for more detailed analysis.
    %
    % Parameters:
    %   filename: Path to the TIFF file
    %   pixelSize: Pixel size in micrometers
    %   minSomaSize: Minimum size of somata in micrometers
    %   frameRate: Imaging frame rate
    %   varargin: Additional optional parameters including stimTimes and stimDuration

    % Create an inputParser instance for optional parameters
    p = inputParser;
    addParameter(p, 'sensitivity', 0.05, @(x) isnumeric(x) && x >= 0 && x <= 1);
    addParameter(p, 'stimTimes', [], @isnumeric);
    addParameter(p, 'stimDuration', 0, @isnumeric);
    addParameter(p, 'preWin', 2, @isnumeric);
    addParameter(p, 'postWin', 5, @isnumeric);

    addParameter(p, 'stimTimes2', [], @isnumeric);
    addParameter(p, 'stimDuration2', 0, @isnumeric);

    parse(p, varargin{:});
    stimTimes = p.Results.stimTimes;
    stimDuration = p.Results.stimDuration;
    stimTimes2 = p.Results.stimTimes2;
    stimDuration2 = p.Results.stimDuration2;
    preWin = p.Results.preWin;
    postWin = p.Results.postWin;
    sensitivity = p.Results.sensitivity;

    % Extract calcium traces from the file
    [roiList, traceData, projectionImg] = extractCaTracesFromFile(filename, pixelSize, minSomaSize, framerate, sensitivity);

    if isempty(roiList)
        warning('check your parameters');
    else
        % Plotting routines
        NUMCOLS = 2;

        if isempty(stimTimes)
            NUMROWS = 1;
        else
            NUMROWS = 2;
        end

        figHandle = figure('Position', [100, 100, 1200, 800]); % Modify the size as needed

        % Plot standard projection with ROIs
        ax1 = subplot(NUMROWS, NUMCOLS, 1);
        showCaImageWithROIs(projectionImg, pixelSize, roiList);

        % Additional plotting if stimulation times are provided
        if ~isempty(stimTimes)

            if ~isempty(stimTimes2)
                stimDelay = stimTimes2(1) - stimTimes(1);
            else
                stimDelay = 0;
            end

            ax2 = subplot(NUMROWS, NUMCOLS, 2);
            plotCaTracesWithStim(traceData, framerate, 'stimTimes', p.Results.stimTimes, 'stimDuration', p.Results.stimDuration, 'plotTitle', 'Full trial traces', 'stimTimes2', p.Results.stimTimes2, 'stimDuration2', p.Results.stimDuration2);

            % Subplot for the triggered windows
            ax3 = subplot(NUMROWS, NUMCOLS, 3);
            triggeredWindows = extractTriggeredWindows(traceData, p.Results.stimTimes, p.Results.stimDuration, p.Results.preWin, p.Results.postWin, framerate);
            plotMeanTriggeredWindows(triggeredWindows, preWin, stimDuration, framerate, 'Stim-triggered means per ROI', 'axesHandle', gca, 'figHandle', figHandle, 'legendText', 'ROI', 'stim2Delay', stimDelay', 'stimDuration2', stimDuration2);

            % Subplot for the triggered windows
            ax4 = subplot(NUMROWS, NUMCOLS, 4);

            triggeredPerStimWindows = permute(triggeredWindows, [1, 3, 2]);
            plotMeanTriggeredWindows(triggeredPerStimWindows, preWin, stimDuration, framerate, 'Stim-triggered means per stim', 'axesHandle', gca, 'figHandle', figHandle, 'legendText', 'ROI' , 'stim2Delay', stimDelay', 'stimDuration2', stimDuration2);

            applyCustomFigureStyle(figHandle, [ax1, ax2, ax3, ax4]);
        else

            ax2 = subplot(NUMROWS, NUMCOLS, 2);
            plotCaTracesFromROIdata(traceData, framerate, 'axesHandle', ax2);
            applyCustomFigureStyle(figHandle, [ax1, ax2]);
        end

        % Set the overall figure title or any additional properties
        sgtitle(figHandle, filename, 'Color', 'w'); % For MATLAB versions >= R2018b
    end

end
