function stdProjectionImg = makeStdProjection(tiffStack)
% makeStdProjection - make a standard deviation projection of a tiff stack

stdProjectionImg = std(double(tiffStack), 0, 3);
