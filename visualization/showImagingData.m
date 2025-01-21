function showImagingData(tiffStack, frameRate)
    % Visualize Calcium Imaging Data (or other imaging)
    %
    % Displays a static STD projection of the stack and provides a dynamic
    % visualization tool with a slider, play/pause button, and interactive
    % contrast adjustment.
    %
    % Parameters:
    % tiffStack - A 3D matrix containing the calcium imaging stack
    % frameRate - Frame rate of the imaging in Hz

    % Downsample the stack for memory-efficient STD projection
    downsampleFactor = 0.25; % Adjust as needed for balance between resolution and memory usage
    downsampledStack = imresize3(tiffStack, downsampleFactor, 'nearest');

    % Convert downsampled stack to single precision for STD calculation
    singleStack = single(downsampledStack);

    % Calculate and display the STD projection
    figure('Name', 'STD Projection', 'NumberTitle', 'off');
    stdProj = std(singleStack, 0, 3, 'omitnan'); % Use single precision to reduce memory
    imagesc(stdProj);
    axis image; colormap gray; colorbar;
    title('STD Projection of Imaging Stack');

    % Create the dynamic visualization
    numFrames = size(tiffStack, 3);
    fig = figure('Name', 'Dynamic Viewer', 'NumberTitle', 'off');
    ax = axes('Parent', fig, 'Position', [0.05 0.2 0.9 0.7]);

    % Initial frame
    frame = double(tiffStack(:, :, 1)); % Convert to double for compatibility
    hImage = imshow(frame, [], 'Parent', ax); % Display with default scaling
    title(ax, sprintf('Frame 1/%d', numFrames));

    % Initialize global contrast limits
    contrastLimits = [min(frame(:)), max(frame(:))];

    % Add interactive contrast adjustment
    uicontrol('Style', 'pushbutton', 'String', 'Adjust Contrast', 'Units', 'normalized', ...
        'Position', [0.7 0.2 0.2 0.05], 'Callback', @adjustContrast);

    % Slider
    sld = uicontrol('Style', 'slider', 'Parent', fig, 'Units', 'normalized', ...
        'Position', [0.05 0.1 0.6 0.05], 'Min', 1, 'Max', numFrames, ...
        'Value', 1, 'SliderStep', [1/(numFrames-1) 1/(numFrames-1)], ...
        'Callback', @sliderCallback);

    % Play/Pause Button
    playBtn = uicontrol('Style', 'togglebutton', 'Parent', fig, 'Units', 'normalized', ...
        'Position', [0.7 0.1 0.2 0.05], 'String', 'Play', ...
        'Callback', @(src, ~) togglePlay(src, sld));

    % Frame number text
    frameNumText = uicontrol('Style', 'text', 'Parent', fig, 'Units', 'normalized', ...
        'Position', [0.05 0.9 0.3 0.05], ...
        'String', 'Frame: 1');

    % Slider callback
    function sliderCallback(src, ~)
        frameNum = round(src.Value);
        frameNumText.String = sprintf('Frame: %d', frameNum);
        frame = double(tiffStack(:, :, frameNum)); % Convert to double for compatibility
        set(hImage, 'CData', frame); % Update the displayed frame
        caxis(ax, contrastLimits); % Apply the global contrast limits
        title(ax, sprintf('Frame %d/%d', frameNum, numFrames));
    end

    % Play/Pause toggle
    function togglePlay(src, slider)
        while src.Value
            currentFrame = round(slider.Value);
            slider.Value = min(currentFrame + 1, numFrames);
            sliderCallback(slider);
            pause(1 / frameRate);
            if slider.Value == numFrames
                src.Value = 0;
            end
        end
    end

    % Contrast adjustment callback
    function adjustContrast(~, ~)
        % Stop playback if active
        if playBtn.Value
            playBtn.Value = 0; % Stop playback
        end

        % Launch imcontrast
        imcontrast(hImage);

        % Launch a timer to monitor contrast changes
        contrastTimer = timer('ExecutionMode', 'fixedRate', ...
                              'Period', 0.5, ...
                              'TimerFcn', @updateContrastLimits, ...
                              'StopFcn', @(~, ~) delete(timerfind), ...
                              'Name', 'ContrastMonitor');
        start(contrastTimer);
    end

    % Update contrast limits from caxis
    function updateContrastLimits(~, ~)
        newLimits = caxis(ax);
        if ~isequal(contrastLimits, newLimits)
            contrastLimits = newLimits;
       %     fprintf('Updated contrast limits: [%f, %f]\n', contrastLimits(1), contrastLimits(2));
        end
    end
end
