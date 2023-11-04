function [traces, metadata] = readTraceData(filename, varargin)
    %READTRACEDATA Reads trace data from a file.
    %   The function automatically determines the file type from the
    %   extension and calls the appropriate function to read the data.

        %   Parameters:
    %       'HasHeaders' - boolean indicating if the CSV file has headers (that will be skipped)
    %       'NumHeaderLines' - number of lines in the header (default is 1)
    %       'Delimiter' - the delimiter used in the file (default is ',')
    %       'SkipFirstColumn' - boolean indicating if the first column should be skipped (default is false)
    %
    
    % Determine the file extension
    [~, ~, ext] = fileparts(filename);
    
    % Call the appropriate function based on the file type
    switch lower(ext)
        case '.csv'
            [traces, metadata] = readCsvTraces(filename, varargin{:});
        case '.mat'
            [traces] = readMatTraces(filename, varargin{:});
            metadata = [];
        otherwise
            error('readTraceData:UnsupportedFileType', ...
                  'Unsupported file type: %s', ext);
    end
    end
    