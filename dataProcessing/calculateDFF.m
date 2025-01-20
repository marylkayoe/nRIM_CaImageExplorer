function deltaFoverF = calculateDeltaFoverFRunning(stack, windowSize, spatialSigma)
        % Calculate Delta F/F with spatial smoothing
        %
        % Parameters:
        % stack        - A 3D matrix containing the imaging stack (H x W x T)
        % windowSize   - Number of frames in the running baseline window
        % spatialSigma - Standard deviation of the Gaussian filter for smoothing
        %
        % Returns:
        % deltaFoverF - The stack normalized as Delta F/F
    
        % Apply spatial smoothing
        kernelSize = ceil(6 * spatialSigma); % Cover 3 std devs
        gFilter = fspecial('gaussian', [kernelSize kernelSize], spatialSigma);
        smoothedStack = imfilter(stack, gFilter, 'replicate');
    
        % Compute the baseline using a running average
        kernel = ones(1, 1, windowSize) / windowSize; % Temporal smoothing kernel
        baseline = convn(single(smoothedStack), kernel, 'same');
    
        % Avoid division by zero
        baseline(baseline == 0) = eps;
    
        % Compute Delta F/F
        deltaFoverF = (single(smoothedStack) - baseline) ./ baseline;
    end
    