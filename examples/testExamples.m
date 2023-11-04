% Script to test the nRIM_CaImageExplorer functions with example data
% Add the main code directory to the path if necessary
 %addpath('/Users/yoe/Documents/repos/nRIM_CaImageExplorer/examples');

% Clear workspace and figures
clear;
close all;

% Define the paths to the example files
csvFilePath = 'testCaTraces.csv';
matFilePath = 'testCaTraces.mat';
% Define the framerate (for this example, we'll assume it's 20 frames per second)
framerate = 20;

% Load the CSV data, skipping first column (FIJI adds a row index in it)
[tracesCsv, metadataCsv] = readTraceData(csvFilePath, 'startColIndex', 1);

% Load the MAT data
tracesMat = readTraceData(matFilePath);
[isValid, nROIs, nFrames] = validateTraceData(tracesMat);

% % Plot traces from the CSV file
% plotCaTracesFromROIdata(tracesCsv, framerate);

% Plot traces from the MAT file in a new figure
plotCaTracesFromROIdata(tracesMat, framerate, 'plotTitle', 'test data');
