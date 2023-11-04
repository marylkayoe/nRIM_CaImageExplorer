function plotTriggeredWindows(triggeredWindows, preWin, stimDuration, framerate, plotTitle)
    %plotTriggeredWindows Plots triggered windows and overlays the mean trace.
    %   plotTriggeredWindows(triggeredWindows, preWin, postWin, stimDuration, framerate, plotTitle)
    %   plots all the individual windows from 'triggeredWindows' and overlays
    %   a mean trace calculated from these windows.

    % Create the x-axis using the utility function
    xAx = makeXAxisFromFrames(size(triggeredWindows, 1), framerate);
    xAx = xAx - preWin; % Shift the x-axis to center at zero for the stimulus onset

    % Initialize the figure and axes
    fig = figure;
    axesHandle = axes('Parent', fig);
    hold(axesHandle, 'on');

    % Plot each triggered window
    for i = 1:size(triggeredWindows, 2)
        plot(axesHandle, xAx, triggeredWindows(:, i), 'Color', [0.8 0.8 0.8]); % Light grey for individual traces
    end

    % Calculate and plot the mean trace
    meanTrace = mean(triggeredWindows, 2, 'omitnan');
    plot(axesHandle, xAx, meanTrace, 'w', 'LineWidth', 2); % White and thicker for mean trace

    % Draw the stimulation rectangle
    yLimits = ylim(axesHandle); % Get the current y-axis limits
    drawStimulationRectangle(axesHandle, stimDuration, yLimits);

    % Customize the plot
    xlabel(axesHandle, 'Time (s)');
    ylabel(axesHandle, 'Fluorescence Intensity (a.u.)');
    title(axesHandle, plotTitle);

    % Apply the custom figure style
    applyCustomFigureStyle(fig, axesHandle);

    % Finalize the plot
    hold(axesHandle, 'off');
end
