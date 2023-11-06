function [traces, metadata] = readCsvTraces(filename, varargin)
    %READCSVTRACES Reads calcium trace data from a CSV file.
    %   [traces, metadata] = READCSVTRACES(filename) reads a CSV file containing
    %   imaging trace data and returns the data in a matrix format. Each
    %   column in the matrix corresponds to a single cell's trace. Optionally,
    %   the function can return metadata if present in the file.
    %
    %   ... = READCSVTRACES(filename, 'Param', value) allows additional
    %   parameter name/value pairs to handle different CSV formats and
    %   structures.
    %
    %   Parameters:
    %       'HasHeaders' - boolean indicating if the CSV file has headers (that will be skipped)
    %       'NumHeaderLines' - number of lines in the header (default is 1)
    %       'Delimiter' - the delimiter used in the file (default is ',')
    %       'startColIndex' - boolean indicating if the first column should be skipped (default is false)
    %
    %   Returns:
    %       traces - a numeric matrix containing the calcium trace data
    %       metadata - a structure containing metadata, if present

    %% Parse optional parameters
    params = inputParser;
    addParameter(params, 'HasHeaders', true, @islogical);
    addParameter(params, 'NumHeaderLines', 1, @isnumeric);
    addParameter(params, 'startColIndex', 1, @isnumeric); % Default to 0, which means the first column
    addParameter(params, 'Delimiter', ',', @ischar);
    parse(params, varargin{:});

    % Open the file
    fid = fopen(filename, 'rt');

    if fid == -1
        error('readCsvTraces:FileNotFound', 'Cannot open file: %s', filename);
    end

    %% Read the metadata if headers are present
    metadata = struct();

    if params.Results.HasHeaders

        for i = 1:params.Results.NumHeaderLines
            headerLine = fgetl(fid);
            % Parse headerLine to extract metadata, if needed
            % ...
        end

    end

    %% Read the trace data, starting from the specified column index
    try
        traces = csvread(filename, params.Results.NumHeaderLines, params.Results.startColIndex);
    catch err
        fclose(fid);
        rethrow(err);
    end

    % Close the file
    fclose(fid);
end
    