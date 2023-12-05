function showCaRecordingsInFolder(dataFolder, framerate, varargin)
    % Show calcium recordings for each file in a data folder.
    %
    % Parameters:
    % dataFolder - Folder containing the files with trace data.
    % framerate - Acquisition framerate in Hz.
    %
    % Optional name-value pairs:
    % 'stimTimes' - Array of stimulation start times in seconds.
    % 'stimDuration' - Duration of each stimulation period in seconds.
    % 'preWin' - Pre-stimulation window duration in seconds.
    % 'postWin' - Post-stimulation window duration in seconds.

    % Set up the input parser for optional parameters
    p = inputParser;
    addParameter(p, 'stimTimes', []);
    addParameter(p, 'stimDuration', []);
    addParameter(p, 'preWin', 2);
    addParameter(p, 'postWin', 5);
    parse(p, varargin{:});

    % Extract parsed results
    stimTimes = p.Results.stimTimes;
    stimDuration = p.Results.stimDuration;
    preWin = p.Results.preWin;
    postWin = p.Results.postWin;

    % Find .mat and .csv files in the data folder
    matFiles = dir(fullfile(dataFolder, '*.mat'));
    csvFiles = dir(fullfile(dataFolder, '*.csv'));
    dataFiles = [matFiles; csvFiles]; % Combine the lists of files

    % Check if there are any files to process
    if isempty(dataFiles)
        error('No .mat or .csv files found in the specified data folder.');
    end

    % Process each file
    for i = 1:length(dataFiles)
        filePath = fullfile(dataFolder, dataFiles(i).name);
        try
            % Display the recording for the current file
            showTracesExtractedFromCaRecording(filePath, framerate, 'stimTimes', stimTimes, ...
                            'stimDuration', stimDuration, 'preWin', preWin, ...
                            'postWin', postWin);
        catch ME
            % Handle any errors during processing
            warning('An error occurred while processing %s: %s', filePath, ME.message);
        end
    end
end
