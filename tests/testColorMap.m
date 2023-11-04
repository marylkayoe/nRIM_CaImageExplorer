% Test script for generateCustomColormap utility

% Define a range of ROI counts to test
roiCounts = [5, 10, 20, 50, 100];

% Create a figure to plot the colormaps
figure;

% Test the colormap generation for each ROI count
for i = 1:length(roiCounts)
    numROIs = roiCounts(i);
    
    % Generate the colormap
    cmap = generateCustomColormap(numROIs);
    
    % Create a subplot to show the colormap
    subplot(1, length(roiCounts), i);
    imagesc(repmat((1:numROIs), 10, 1));
    colormap(cmap);
    axis off;  % Turn off axis for cleaner visualization
    title(sprintf('%d ROIs', numROIs));
end
