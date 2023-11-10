function adjustedStack = adjustStackTo8b(tiffStack)
    % Adjust intensity and convert TIFF stack to 8-bit
    %
    % Parameters:
    % tiffStack - A 3D matrix containing the imported TIFF stack
    %
    % Returns:
    % adjustedStack - A 3D matrix containing the adjusted and converted TIFF stack

    numFrames = size(tiffStack, 3);
    adjustedStack = zeros(size(tiffStack), 'uint8');

    % Find global min and max for the whole stack
    globalMin = double(min(tiffStack(:)));
    globalMax = double(max(tiffStack(:)));

    for i = 1:numFrames
        frame = double(tiffStack(:,:,i));
        
        % Adjust intensity based on global min and max
        frame = (frame - globalMin) / (globalMax - globalMin);
        frame = uint8(255 * frame); % Convert to 8-bit
        adjustedStack(:,:,i) = frame;
    end
end