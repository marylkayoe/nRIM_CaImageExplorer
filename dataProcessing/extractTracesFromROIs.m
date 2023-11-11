function [calciumTraces filteredRoiList] = extractTracesFromROIs(downsampledStack, roiList)
% Extract calcium traces from ROIs in a downsampled image stack
%
% Parameters:
% downsampledStack - A 3D matrix of the downsampled TIFF stack
% roiList - A list of ROIs, each with properties such as bounding box

% Number of ROIs and frames
numROIs = length(roiList);
numFrames = size(downsampledStack, 3);

% Initialize the matrix to hold calcium traces
calciumTraces = zeros(numFrames, numROIs);

% Loop over each ROI to extract the trace
for i = 1:numROIs
    roi = roiList(i);
    for j = 1:numFrames
        frame = downsampledStack(:,:,j);
        % Convert XY coordinates to linear indices
        linearIndices = sub2ind(size(frame), roi.PixelList(:, 2), roi.PixelList(:, 1));
        % Extract the ROI area from the frame
        roiArea = frame(linearIndices);
        % Calculate the average intensity in the ROI for this frame
        calciumTraces(j, i) = mean(roiArea);
                % Calculate mean and SEM for the ROI
        traceMeans(i) = mean(calciumTraces(:, i));
        traceSEMs(i) = std(calciumTraces(:, i)) / sqrt(numFrames);
    end
end


% Gaussian smoothing of the traces
sigma = 1;  % Standard deviation for Gaussian smoothing
for i = 1:numROIs
    calciumTraces(:, i) = imgaussfilt(calciumTraces(:, i), sigma);
end

    % % Determine percentile thresholds
    % percentileThreshold = 10;  % For example, the 10th percentile
    % thresholdMean = prctile(traceMeans, percentileThreshold);
    % thresholdSEM = prctile(traceSEMs, percentileThreshold);
    % 
    % % Filter out ROIs below the percentile thresholds
    % validROIs = find(traceMeans > thresholdMean & traceSEMs > thresholdSEM);
    % 
    % % Filter the calcium traces and ROI list
    % calciumTraces = calciumTraces(:, validROIs);
    % filteredRoiList = roiList(validROIs);

end
