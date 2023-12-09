function plotWaveletSpectrum(traceData, framerate, varargin)
    % Plot wavelet power spectrum for a given ROI trace
    % If there are more than one ROI, we make average of that.
    % Parameters:
    % traceData - array of calcium trace data for a single ROI
    % framerate - Sampling rate in Hz
    % Optional parameters:
    % axesHandle - handle to axes to plot in
    % stimTimes - array of stimulation times in seconds
    % stimDuration - duration of stimulation in seconds


    % Parse optional arguments
    p = inputParser;
    addParameter(p, 'axesHandle', gca, @ishandle);
    addParameter(p, 'stimTimes', [], @isnumeric);
    addParameter(p, 'stimDuration', 0, @isnumeric);
    parse(p, varargin{:});

    ax1 = p.Results.axesHandle;
    stimTimes = p.Results.stimTimes;
    stimDuration = p.Results.stimDuration;

    % Normalize trace data 
    traceData = normalize(traceData, 'zscore');

    % If there are more than one ROI, we make average of that.
    [nFRAMES nROIS] = size(traceData);
    if (nROIS > 1)
        traceData = mean(traceData, 2);
    end

    % Perform wavelet transform

    [wt, f] = cwt(traceData, framerate, 'VoicesPerOctave', 12, 'TimeBandwidth', 10);
    % cwt(traceData, seconds/framerate,  'TimeBandwidth', 60, 'VoicesPerOctave', 12, 'Parent', ax1);
    % Calculate time vector for plotting
    t = (0:length(traceData) - 1) / framerate;

    surface(ax1, t, f, abs(wt));
    axis tight;
    shading flat;
    xlabel("Time (s)")
    ylabel("Frequency (Hz)")
    set(gca, "yscale", "log")

    % Plot wavelet power spectrum
    % surface(ax1, t, f, abs(wt).^2);

    if ~isempty(stimTimes)
        hold(gca, 'on');

        for i = 1:length(stimTimes)
            drawStimulationRectangle(ax1, stimTimes(i), stimDuration, [1 12], [1 1 1], 0.3);
        end

    end

    axis tight;
    shading interp;
    view(0, 90);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    ylim([0.1 12]);
    title('Wavelet Power Spectrum');
    %clim([0 0.2]);
    % colorbar;
    set(gca, 'Layer', 'top');
end
