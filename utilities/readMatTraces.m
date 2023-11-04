function traces = readMatTraces(filename)
    %READMATTRACES Reads calcium trace data from a MAT file.
    %   traces = READMATTRACES(filename) reads a MAT file containing
    %   calcium imaging trace data and returns the data in a matrix format.
    %
    %   Arguments:
    %       filename - a string specifying the MAT file to read from
    %
    %   Returns:
    %       traces - a numeric matrix containing the calcium trace data

    % Check if the file exists
    if ~isfile(filename)
        error('readMatTraces:FileNotFound', 'Cannot find file: %s', filename);
    end

    % Load the MAT file
    fileData = load(filename);

    % Assume the MAT file contains a single variable with our data
    % Extract the variable using dynamic field names
    varNames = fieldnames(fileData);

    if numel(varNames) ~= 1
        error('readMatTraces:UnexpectedNumberOfVariables', ...
            'The MAT file contains %d variables, but exactly 1 variable containing the trace data is expected.', ...
            numel(varNames));
    end

    % Retrieve the trace data
    traces = fileData.(varNames{1});

    % Check if traces is a numeric matrix
    if ~ismatrix(traces) || ~isnumeric(traces)
        error('readMatTraces:InvalidDataType', ...
        'The data in the MAT file is not a numeric matrix.');
    end

end
