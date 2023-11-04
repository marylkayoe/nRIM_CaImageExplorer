function triggeredWindows = extractTriggeredWindows(traceData, stimTimes, stimDuration, preWin, postWin, framerate)
    % Extract windows of trace data around stimulation times.
    % 
    % Parameters:
    % traceData - 2D array of trace data (time x ROIs)
    % stimTimes - Array of stimulation start times in seconds
    % preWin - Pre-stimulation window duration in seconds
    % postWin - Post-stimulation window duration in seconds
    % stimDuration - Duration of stimulation in seconds
    % framerate - Sampling rate in Hz
    %
    % Returns:
    % triggeredWindows - 3D array of triggered windows (time x windows x ROIs)

    % [Validation code here...]

    % Convert times from seconds to frames using utility functions
    preWinFrames = sec2frames(preWin, framerate);
    postWinFrames = sec2frames(postWin + stimDuration, framerate); % Include the duration in post-window
    stimTimesFrames = sec2frames(stimTimes, framerate);

    % Calculate the total window length
    windowLength = preWinFrames + postWinFrames + 1;

    % Initialize the output array
    numROIs = size(traceData, 2);
    triggeredWindows = nan(windowLength, length(stimTimes), numROIs);

    % Extract the windows
    for i = 1:length(stimTimesFrames)
        % Calculate the start and end frame indices for the window
        startFrame = stimTimesFrames(i) - preWinFrames;
        endFrame = stimTimesFrames(i) + postWinFrames;

        % Check if the window exceeds the trace data boundaries
        if startFrame < 1 || endFrame > size(traceData, 1)
            continue; % Skip this window as it exceeds the trace data boundaries
        end

        % Extract the window and place it in the output array
        triggeredWindows(:, i, :) = traceData(startFrame:endFrame, :);
    end
end
