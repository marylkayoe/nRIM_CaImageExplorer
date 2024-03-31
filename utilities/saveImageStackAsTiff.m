function R = saveImageStackAsTiff( stack, savepath, filename, varargin )
%SAVEIMAGESTACKASTIFF Save a 3D image stack as a tiff file  
%   R = saveImageStackAsTiff( stack, savepath, filename ) saves a 3D matrix 
%   stack as a tiff file with the name filename in the directory savepath.
%   The function returns 1 if the file was saved successfully and 0 if not.

p = inputParser;
addRequired(p, 'stack', @isnumeric);
addRequired(p, 'savepath', @ischar);
addRequired(p, 'filename', @ischar);
addParameter(p, 'overwrite', false, @islogical) ;
parse(p, stack, savepath, filename, varargin{:});


% Check if the file already exists
if exist(fullfile(savepath, filename), 'file') == 2 && ~p.Results.overwrite
    R = 0;
    disp('File already exists; use option overwrite = true to overwrite the file');
    return;
end

% Save the stack as a tiff file
% display a dot for every 100 frames saved
imwrite(stack(:,:,1), fullfile(savepath, filename), 'tiff', 'WriteMode', 'overwrite');
for i = 2:size(stack,3)
    imwrite(stack(:,:,i), fullfile(savepath, filename), 'tiff', 'WriteMode', 'append');
    if mod(i,100) == 0
        fprintf('.');
    end
end
disp(['Saved stack as ' fullfile(savepath, filename)]);
R = 1;



