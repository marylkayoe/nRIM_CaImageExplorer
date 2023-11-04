function seconds = frames2sec(frames, framerate)
    %FRAMES2SEC Convert frame indices to time in seconds.
    validateattributes(frames, {'numeric'}, {'vector', 'nonnegative'}, mfilename, 'frames');
    validateattributes(framerate, {'numeric'}, {'scalar', 'positive'}, mfilename, 'framerate');
    seconds = frames / framerate;
end