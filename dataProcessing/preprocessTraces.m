function cleanTraces = preprocessTraces(traces, frameRate, varargin)
% preprocessTraces: preprocess calcium traces
% example use: cleanTraces = preprocessTraces(traces, frameRate, 'normalize', true, 'smooth', true, 'detrend', true)
% parse inputs: normalize, smooth, and detrend
p = inputParser;
addRequired(p, 'traces', @isnumeric);
addRequired(p, 'frameRate', @isnumeric);
addParameter(p, 'normalize', true, @islogical);
addParameter(p, 'smooth', true, @islogical);
addParameter(p, 'detrend', true, @islogical);
parse(p, traces, frameRate, varargin{:});

% get parameters
normalizeSignal = p.Results.normalize;
makeSmooth = p.Results.smooth;
detrendSignal = p.Results.detrend;


    %% smooth data with gaussian kernel
    % default sigma is 1/3 of the frame rate
    sigma = frameRate/3;
    if makeSmooth
        traces = smoothdata(traces, 'gaussian', sigma);
    end

    %% detrend data
    % default is to use a 5th order polynomial
    if detrendSignal
        traces = detrend(traces, 5);
    end

    %% normalize data
    % default is to normalize from 0 to 1
    if normalizeSignal
        traces = normalize(traces, 'range');
    end

    %% return cleaned traces
    cleanTraces = traces;






