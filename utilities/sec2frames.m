

function frames = sec2frames(seconds, framerate)
    %SEC2FRAMES Convert time in seconds to frame indices.
    validateattributes(seconds, {'numeric'}, {'vector', 'nonnegative'}, mfilename, 'seconds');
    validateattributes(framerate, {'numeric'}, {'scalar', 'positive'}, mfilename, 'framerate');
    frames = round(seconds * framerate);
end
