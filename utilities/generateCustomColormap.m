function cmap = generateCustomColormap(numROIs)
    % generateCustomColormap Create a custom colormap.
    %   cmap = generateCustomColormap(numROIs) creates a colormap array 
    %   with a customized range of colors based on the number of ROIs.

    % Start with a base colormap, e.g., parula, jet, etc.
    baseCmap = parula(256);

    % Customize the colormap as needed
    % For example, if you want to extract only the greens:
    greens = baseCmap(:, [1, 3, 2]); % Swap the green and blue channels
    greens = greens(41:200, :);      % Keep only the greenish colors

    % Scale the colormap to the number of ROIs
    cmap = interp1(linspace(0, 1, size(greens, 1)), greens, linspace(0, 1, numROIs));
end
