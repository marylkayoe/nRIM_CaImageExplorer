function upscaleTraceFile(traceFileName, oldFrameRate, newFrameRate)

    % tracewFile: path to the trace file either csv or mat
    % oldFrameRate: frame rate of the trace file
    % newFrameRate: new frame rate to be used

    % load the trace file
    [traces, metadata] = readTraceData(traceFileName);
    [datafolder, name, ext] = fileparts(traceFileName);

    % upscale the traces
    upscaledTraces = upscaleTraceData(traces, oldFrameRate, newFrameRate);

    % generate new trace file name for upscaled
    upscaledTraceFileName = [datafolder, name, '_upscaled_', num2str(newFrameRate), 'fps', ext];

    % write the upscaled trace file
    save(upscaledTraceFileName, 'upscaledTraces');
    
    



