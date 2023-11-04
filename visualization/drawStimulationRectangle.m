function drawStimulationRectangle(axesHandle, stimDuration, yLimits)
    % drawStimulationRectangle Draws a rectangle to indicate stimulation period.
    %   drawStimulationRectangle(axesHandle, stimDuration, yLimits)
    %   draws a transparent rectangle on the given axes to indicate the
    %   stimulation period, starting at zero.

    rectangle('Position', [0, yLimits(1), stimDuration, yLimits(2)-yLimits(1)], ...
              'FaceColor', [0.9 0.9 0.9 0.3], ... % Light grey with 30% opacity
              'EdgeColor', 'none', ...
              'Parent', axesHandle);
end
