function [isValid, nROIs, nFrames] = validateTraceData(traces)
%VALIDATETRACEDATA Validates calcium trace data and extracts parameters.
%   [isValid, nROIs, nFrames] = VALIDATETRACEDATA(traces) checks if the
%   input matrix 'traces' meets the expected criteria for calcium imaging
%   trace data.
%
%   Returns:
%       isValid - a logical value indicating if the data is valid
%       nROIs - an integer representing the number of ROIs (cells)
%       nFrames - an integer representing the number of frames (time points)

% Initialize output
isValid = true;
nROIs = 0;
nFrames = 0;

% Perform checks
if isempty(traces)
    isValid = false;
    warning('The trace data is empty.');
    return;
end

[nFrames, nROIs] = size(traces);

if nROIs > nFrames
    isValid = false;
    warning('The data matrix should have more rows (time points) than columns (ROIs).');
    return;
end

% Check for negative values
negatives = traces < 0;
if any(negatives(:))
    isValid = false;
    negativeColumns = find(any(negatives, 1));
    warning('Negative values found in columns (ROIs): %s', mat2str(negativeColumns));
    return;
end

% NaN values are allowed, but you may want to notify the user
% Check for NaN values
nans = isnan(traces);
if any(nans(:))
    nanColumns = find(any(nans, 1));
    warning('NaN values found in columns (ROIs): %s', mat2str(nanColumns));
end

end
