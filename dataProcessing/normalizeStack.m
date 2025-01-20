function normalizedStack = normalizeStack(stack, lowPercentile, highPercentile)
    % Normalize the stack using percentile-based intensity clipping
    % Parameters:
    % stack          - The input 3D matrix to be normalized
    % lowPercentile  - Lower percentile for clipping (e.g., 1)
    % highPercentile - Upper percentile for clipping (e.g., 99)
    % Returns:
    % normalizedStack - The normalized stack with values scaled between 0 and 1


    if ~exist('lowPercentile', 'var')
        lowPercentile = 1;
    end

    if ~exist('highPercentile', 'var')
        highPercentile = 99;
    end
    

    % Compute intensity percentiles vectorized over all frames
    sortedValues = sort(stack(:));
    totalPixels = numel(sortedValues);
    lowValue = sortedValues(max(1, round(totalPixels * (lowPercentile / 100))));
    highValue = sortedValues(min(totalPixels, round(totalPixels * (highPercentile / 100))));

    % Clip intensities to the specified range
    clippedStack = max(min(stack, highValue), lowValue);

    % Normalize to [0, 1]
    normalizedStack = (clippedStack - lowValue) / (highValue - lowValue);
end
