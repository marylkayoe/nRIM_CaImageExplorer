function plotPowerSpectrum(traceData, framerate)
    % Plot the power spectrum of calcium imaging data for each ROI separately
    %
    % Parameters:
    % traceData - Matrix of calcium imaging data (time x ROIs)
    % framerate - Sampling frequency in Hz

    numROIs = size(traceData, 2); % Number of ROIs
    L = size(traceData, 1); % Length of signal

    % Pre-allocate for speed
    P1_all = zeros(floor(L/2+1), numROIs); % Store power spectrum of each ROI
    f = framerate * (0:(L/2)) / L; % Frequency axis

    for i = 1:numROIs
        Y = fft(traceData(:, i));
        P2 = abs(Y/L);
        P1 = P2(1:floor(L/2+1));
        P1(2:end-1) = 2*P1(2:end-1);
        P1_all(:, i) = P1;
    end

    % Plot each ROI's power spectrum
    figure;
    hold on;
    for i = 1:numROIs
        plot(f, P1_all(:, i), 'Color',[0.7 0.7 0.7]);
    end
    plot(f, mean(P1_all, 2), 'LineWidth',2, 'Color', 'r');
    hold off;
    title('Power Spectrum of Calcium Imaging Data per ROI')
    xlabel('Frequency (Hz)')
    ylabel('Amplitude')
    legend(arrayfun(@(x) ['ROI ' num2str(x)], 1:numROIs, 'UniformOutput', false));
end
