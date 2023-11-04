function xAx = makeXAxisFromFrames(nSamples, framerate, timeUnit)
%MAKEXAXISFROMFRAMES Create an x-axis for plotting based on the number of samples and the framerate.
%   xAx = MAKEXAXISFROMFRAMES(nSamples, framerate) creates an x-axis array that can be used
%   for plotting time-series data. The x-axis reflects the time in seconds.
%
%   xAx = MAKEXAXISFROMFRAMES(nSamples, framerate, timeUnit) creates an x-axis array with
%   time in the units specified by timeUnit (e.g., 'seconds', 'milliseconds').

if nargin < 3
    timeUnit = 'seconds'; % Default time unit
end

validateattributes(nSamples, {'numeric'}, {'positive', 'integer'}, mfilename, 'nSamples');
validateattributes(framerate, {'numeric'}, {'positive', 'real'}, mfilename, 'framerate');

xAx = (0:nSamples-1) / framerate;

switch lower(timeUnit)
    case 'seconds'
        % Already in seconds, no conversion needed
    case 'milliseconds'
        xAx = xAx * 1000; % Convert seconds to milliseconds
    otherwise
        error('Unknown time unit: %s. Supported units are ''seconds'' and ''milliseconds''.', timeUnit);
end
xAx = xAx';

end
