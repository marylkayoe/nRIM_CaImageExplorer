function showImagingDataWithTrace(tiffStack, frameRate)
    % Visualize Calcium Imaging Data with Intensity Plot and Brightness Adjustment
    %
    % Displays calcium imaging data along with a time-series intensity plot
    % showing the average intensity of the currently displayed frame or a selected
    % pixel. Allows brightness adjustment using imcontrast and provides play/pause functionality.
    %
    % Parameters:
    % tiffStack - A 3D matrix containing the calcium imaging stack
    % frameRate - Frame rate of the imaging in Hz

    % Initialize shared data
    numFrames = size(tiffStack, 3);
    time = (0:numFrames-1) / frameRate; % Time vector
    meanIntensity = mean(mean(tiffStack, 1), 2); % Precompute mean intensity
    meanIntensity = squeeze(meanIntensity);
    % Initialize shared variables for selected pixel coordinates
x = []; % Row index
y = []; % Column index


    % Create the GUI figure
    fig = figure('Name', 'Imaging Data with Intensity Plot', 'NumberTitle', 'off');
    mainAx = axes('Parent', fig, 'Position', [0.05 0.4 0.9 0.5]); % Main image display
    plotAx = axes('Parent', fig, 'Position', [0.05 0.1 0.9 0.2]); % Intensity plot

    % Display the initial frame
    frame = double(tiffStack(:, :, 1)); % Convert to double for display
    hImage = imshow(frame, [], 'Parent', mainAx);
    title(mainAx, sprintf('Frame 1/%d', numFrames));

    % Initialize intensity plot, dark green line
    lineColor = [0, 0.6, 0]; % Dark green   
    hPlot = plot(plotAx, time, meanIntensity, 'Color', lineColor); % Plot intensity time-series
    hold(plotAx, 'on');
    hLine = plot(plotAx, [time(1), time(1)], [min(meanIntensity), max(meanIntensity)], 'b'); % Vertical line for current frame
    xlabel(plotAx, 'Time (s)');
    ylabel(plotAx, 'a.u.');
    hold(plotAx, 'off');

    % Initialize global contrast limits
    contrastLimits = [min(frame(:)), max(frame(:))];
    selectedPixelTrace = meanIntensity; % Default trace (mean intensity of the frame)

    % Add slider
    sld = uicontrol('Style', 'slider', 'Parent', fig, 'Units', 'normalized', ...
        'Position', [0.05 0.35 0.9 0.05], 'Min', 1, 'Max', numFrames, ...
        'Value', 1, 'SliderStep', [1/(numFrames-1), 1/(numFrames-1)], ...
        'Callback', @updateDisplay);

    % Add play/pause button
    playBtn = uicontrol('Style', 'togglebutton', 'Parent', fig, 'Units', 'normalized', ...
        'Position', [0.8 0.6 0.15 0.05], 'String', 'Play', ...
        'Callback', @(src, ~) togglePlay(src));

    % Add brightness adjustment button
    uicontrol('Style', 'pushbutton', 'String', 'Adjust Brightness', 'Units', 'normalized', ...
        'Position', [0.8 0.5 0.15 0.05], 'Callback', @adjustBrightness);

    % Add save button to export the current trace
    uicontrol('Style', 'pushbutton', 'String', 'Save Trace', 'Units', 'normalized', ...
        'Position', [0.8 0.4 0.15 0.05], 'Callback', @saveTrace);

    % Add callback for clicking on the image
    set(hImage, 'ButtonDownFcn', @selectPixel);

    % Slider callback function
    function updateDisplay(src, ~)
        frameNum = round(get(src, 'Value'));
        frame = double(tiffStack(:, :, frameNum)); % Convert raw data to double
        set(hImage, 'CData', frame); % Update displayed frame
        caxis(mainAx, contrastLimits); % Apply contrast limits directly
        title(mainAx, sprintf('Frame %d/%d', frameNum, numFrames));

        % Update the vertical line in the intensity plot
        set(hLine, 'XData', [time(frameNum), time(frameNum)]);
        set(hLine, 'YData', [min(selectedPixelTrace), max(selectedPixelTrace)]); % Rescale YData

        % Update the intensity plot for the selected pixel
        set(hPlot, 'YData', selectedPixelTrace); % Update intensity trace
        ylim(plotAx, [min(selectedPixelTrace), max(selectedPixelTrace)]); % Rescale intensity plot
    end

    % Play/Pause toggle
    function togglePlay(src)
        if src.Value % Play
            while src.Value
                currentFrame = round(get(sld, 'Value'));
                if currentFrame < numFrames
                    set(sld, 'Value', currentFrame + 1); % Move slider to next frame
                    updateDisplay(sld); % Update display
                    pause(1 / frameRate); % Wait for the next frame
                else
                    src.Value = 0; % Stop playing at the last frame
                end
            end
        end
    end

    function adjustBrightness(~, ~)
        % Stop playback if active
        if playBtn.Value
            playBtn.Value = 0; % Stop playback
        end
    
        % Launch imcontrast
        imcontrast(hImage);
    
        % Add an "Apply" button for finalizing adjustments
        confirmBtn = uicontrol('Style', 'pushbutton', 'String', 'Apply Brightness', ...
            'Units', 'normalized', 'Position', [0.8 0.4 0.15 0.05], ...
            'Callback', @finalizeBrightness);
    
        % Callback for finalizing brightness adjustments
        function finalizeBrightness(~, ~)
            % Update the contrast limits after adjustment
            contrastLimits = get(mainAx, 'CLim');
            fprintf('Updated contrast limits: [%f, %f]\n', contrastLimits(1), contrastLimits(2));
    
            % Close the imcontrast window and remove the button
            delete(confirmBtn);
            close(findall(0, 'Type', 'Figure', 'Name', 'Adjust Contrast'));
        end
    end
    

% Select pixel callback
function selectPixel(~, event)
    % Stop playback if active
    if playBtn.Value
        playBtn.Value = 0; % Stop playback
    end

    % Get the clicked pixel coordinates
    coords = round(event.IntersectionPoint(1:2));
    x = coords(2); % Row index
    y = coords(1); % Column index

    % Display debugging information
    fprintf('Clicked coordinates in image space: (%.2f, %.2f)\n', event.IntersectionPoint(1), event.IntersectionPoint(2));
    fprintf('Selected pixel in matrix coordinates: (row: %d, col: %d)\n', x, y);

    % Validate pixel coordinates
    if x > 0 && x <= size(tiffStack, 1) && y > 0 && y <= size(tiffStack, 2)
        fprintf('Validated pixel: (%d, %d)\n', x, y);

        % Extract intensity trace for the selected pixel
        selectedPixelTrace = squeeze(tiffStack(x, y, :));

        % Update the intensity plot
        set(hPlot, 'YData', selectedPixelTrace); % Update intensity trace
        ylim(plotAx, [min(selectedPixelTrace), max(selectedPixelTrace)]); % Rescale intensity plot

        % Update the vertical line to match the current frame and new y-axis limits
        frameNum = round(get(sld, 'Value'));
        set(hLine, 'XData', [time(frameNum), time(frameNum)]);
    else
        fprintf('Clicked outside valid image bounds.\n');
    end
end

% Save trace callback
function saveTrace(~, ~)
    % Ensure a pixel has been selected
    if isempty(x) || isempty(y)
        fprintf('No pixel selected. Please select a pixel before saving.\n');
        return;
    end

    % Export the currently displayed trace to the workspace with pixel coordinates
    varName = sprintf('savedTrace_%d_%d', x, y); % Name includes coordinates
    assignin('base', varName, selectedPixelTrace);
    fprintf('Current trace saved to workspace as "%s"\n', varName);
end

end
