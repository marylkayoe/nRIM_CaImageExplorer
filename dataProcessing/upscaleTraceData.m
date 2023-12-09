function upscaledTraces = upsampleTraces(traces,oldFrameRate,newFrameRate)
    % traces = calcium traces, ROIs in columns, time in rows
[nFRAMES nROIS] = size(traces);
    % upsample traces
upscaledTraces = zeros(nFRAMES*newFrameRate/oldFrameRate,nROIS);
for iROI = 1:nROIS
    upscaledTraces(:,iROI) = interp(traces(:,iROI),newFrameRate/oldFrameRate);
end
end