function applyCustomFigureStyle(figHandle, axesHandle)
    % applyCustomFigureStyle Applies a custom style to the figure and axes.
    %   applyCustomFigureStyle(figHandle, axesHandle) applies a set of style
    %   properties to the given figure and axes handles, such as background
    %   color, axis colors, and grid style.

    % Apply styles to the figure
    set(figHandle, 'Color', 'k');

    % Apply styles to the axes
    set(axesHandle, 'Color', 'k', ...
                    'XColor', 'w', ...
                    'YColor', 'w', ...
                    'GridColor', 'w', ...
                    'GridAlpha', 0.2, ...
                    'LineWidth', 1.5);
    
    % Set font properties
    set(axesHandle, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');
    
    % Remove tick labels if needed
    % set(axesHandle, 'YTickLabel', []);
    
    % Enable the grid
    grid(axesHandle, 'on');
    box(axesHandle, 'on');
end
