function denoisedStack = denoiseCaImgStack(tiffStack, method, varargin)
    % Denoise Calcium Imaging Stack
    %
    % Parameters:
    % tiffStack - A 3D matrix containing the calcium imaging stack
    % method    - Denoising method to apply ('gaussian', 'median', 'nlmeans', 'wavelet', 'bilateral', 'tv')
    % varargin  - Additional parameters for specific methods
    %
    % Returns:
    % denoisedStack - The denoised stack
    %
    % Instructions for choosing parameters:
    % - 'gaussian': Choose sigma (standard deviation). Larger values result in stronger smoothing.
    %               Example: denoiseCaImgStack(stack, 'gaussian', 2)
    % - 'median': Choose window size (scalar or [rows, cols, frames]). Larger values smooth over more pixels.
    %             Example: denoiseCaImgStack(stack, 'median', 5)
    % - 'nlmeans': Choose degree of smoothing (0.1–1.0 typical). Higher values remove more noise but may blur details.
    %              Example: denoiseCaImgStack(stack, 'nlmeans', 0.5)
    % - 'wavelet': Choose wavelet level. Higher levels remove more noise but may lose finer details.
    %              Example: denoiseCaImgStack(stack, 'wavelet', 2)
    % - 'bilateral': Choose degree of smoothing and spatial sigma. Good for edge preservation.
    %                Example: denoiseCaImgStack(stack, 'bilateral', 0.5, 2)
    % - 'tv': Choose regularization. Smaller values preserve more detail but may leave noise.
    %          Example: denoiseCaImgStack(stack, 'tv', 0.01)

    switch lower(method)
        case 'gaussian'
            % Gaussian filtering
            sigma = 1; % Default sigma
            if ~isempty(varargin)
                sigma = varargin{1};
            end
            kernelSize = ceil(6 * sigma); % Dynamically calculate kernel size based on sigma
            gFilter = fspecial('gaussian', [kernelSize, kernelSize], sigma);

            denoisedStack = imfilter(tiffStack, gFilter, 'replicate');

        case 'median'
            % Median filtering
            defaultWindowSize = [3, 3, 1]; % Default window size for spatial filtering
            if ~isempty(varargin)
                windowSize = varargin{1};
                if numel(windowSize) == 1
                    % If a single value is given, apply it to spatial dimensions only
                    windowSize = [windowSize, windowSize, 1];
                elseif numel(windowSize) ~= 3
                    error('Window size for median filtering must be a scalar or a 3-element vector.');
                end
            else
                windowSize = defaultWindowSize;
            end
            denoisedStack = medfilt3(tiffStack, windowSize);

        case 'nlmeans'
            % Non-local means filtering
            degreeOfSmoothing = 0.5; % Default smoothing
            if ~isempty(varargin)
                degreeOfSmoothing = varargin{1};
            end
            denoisedStack = zeros(size(tiffStack), 'like', tiffStack);
            for i = 1:size(tiffStack, 3)
                denoisedStack(:, :, i) = imnlmfilt(tiffStack(:, :, i), 'DegreeOfSmoothing', degreeOfSmoothing);
            end

        case 'wavelet'
            % Wavelet denoising
            waveletLevel = 2; % Default wavelet level
            if ~isempty(varargin)
                waveletLevel = varargin{1};
            end
            denoisedStack = zeros(size(tiffStack), 'like', tiffStack);
            for i = 1:size(tiffStack, 3)
                denoisedStack(:, :, i) = wdenoise(single(tiffStack(:, :, i)), waveletLevel);
            end

        case 'bilateral'
            % Bilateral filtering
            degreeOfSmoothing = 0.5; % Default smoothing
            spatialSigma = 2; % Default spatial sigma
            if ~isempty(varargin)
                degreeOfSmoothing = varargin{1};
                if length(varargin) > 1
                    spatialSigma = varargin{2};
                end
            end
            denoisedStack = zeros(size(tiffStack), 'like', tiffStack);
            for i = 1:size(tiffStack, 3)
                denoisedStack(:, :, i) = imbilatfilt(tiffStack(:, :, i), degreeOfSmoothing, spatialSigma);
            end

        case 'tv'
            % Total variation denoising
            regularization = 0.01; % Default regularization parameter
            if ~isempty(varargin)
                regularization = varargin{1};
            end
            denoisedStack = zeros(size(tiffStack), 'like', tiffStack);
            for i = 1:size(tiffStack, 3)
                denoisedStack(:, :, i) = imtvd(single(tiffStack(:, :, i)), 'Regularization', regularization);
            end

        otherwise
            error('Unsupported denoising method: %s', method);
    end
end
