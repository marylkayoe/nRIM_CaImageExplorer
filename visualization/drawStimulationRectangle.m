function drawStimulationRectangle(axesHandle, stimStart, stimDuration, yLimits, color, opacity)
    % drawStimulationRectangle Draws a rectangle to indicate a stimulation period.
    %   drawStimulationRectangle(axesHandle, stimStart, stimDuration, yLimits, color)
    %   draws a transparent rectangle on the given axes to indicate the
    %   stimulation period, starting at stimStart.
    %
    %   Parameters:
    %   - axesHandle: Handle to the axes where the rectangle should be drawn.
    %   - stimStart: X-coordinate for the start of the stimulation period.
    %   - stimDuration: Duration of the stimulation period.
    %   - yLimits: Y-axis limits for the rectangle.
    %   - color (optional): RGB color of the rectangle with transparency.

    % Set default color and opacity if not provided
    if nargin < 5
        color = [0.9 0.9 0.9];  % Light grey with 30% opacity
    end

    if nargin < 6
        opacity = 0.3;  % 30% opacity
    end

    rectangle('Position', [stimStart, yLimits(1), stimDuration, yLimits(2)-yLimits(1)], ...
              'FaceColor',  [color, opacity], ...
              'EdgeColor', 'none', ...
              'Parent', axesHandle);
end
