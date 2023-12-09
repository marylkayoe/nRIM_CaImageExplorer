function upscaleTraceFile(traceFileName, oldFrameRate, newFrameRate)
    % upscaleTraceFile: upscale the trace file to a new frame rate
    % saves the upscaled trace file in the same folder as the original trace
    % file with the name appended with _upscaled_<newFrameRate>fps
    % input parameters:
    % traceFileName: path to the trace file either csv or mat
    % oldFrameRate: frame rate of the trace file
    % newFrameRate: new frame rate to be used

    % usage: upscaleTraceFile('trace.csv', 30, 60);

    % load the trace file
    [traces, metadata] = readTraceData(traceFileName);
    [datafolder, name, ext] = fileparts(traceFileName);

    % upscale the traces
    upscaledTraces = upscaleTraceData(traces, oldFrameRate, newFrameRate);

    % generate new trace file name for upscaled
    upscaledTraceFileName = [datafolder, name, '_upscaled_', num2str(newFrameRate), 'fps', ext];

    % write the upscaled trace file
    if (strcmp(ext, '.csv'))
        writematrix(upscaledTraces, upscaledTraceFileName);
      
    elseif (strcmp(ext, '.mat'))
        save(upscaledTraceFileName, 'upscaledTraces', 'metadata');
    end
  
end