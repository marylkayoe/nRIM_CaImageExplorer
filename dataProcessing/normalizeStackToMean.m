function normalizedStack = normalizeStackToMean(stack)
    % Normalize the stack by subtracting the mean and scaling by the mean
    % Parameters:
    % stack - The input 3D matrix to be normalized
    % Returns:
    % normalizedStack - The normalized stack with values centered around 0

    % Compute the mean intensity across the entire stack
    meanValue = mean(stack(:));

    % Avoid division by zero
    if meanValue == 0
        error('Mean intensity is zero; normalization not possible.');
    end

    % Normalize to mean
    normalizedStack = (stack - meanValue) ./ meanValue;
end
