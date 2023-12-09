function upscaledTraces = upsampleTraceData(traces, oldFrameRate, newFrameRate)
    % upsamples traces from oldFrameRate to newFrameRate
    % using simple interpolation
    % traces = calcium traces, ROIs in columns, time in rows
    % usage: upscaledTraces = upsampleTraces(traces, oldFrameRate, newFrameRate)


    [nFRAMES, nROIS] = size(traces);
    % upsample traces
    upscaledTraces = zeros(nFRAMES * newFrameRate / oldFrameRate, nROIS);

    for iROI = 1:nROIS
        upscaledTraces(:, iROI) = interp(traces(:, iROI), newFrameRate / oldFrameRate);
    end

end
