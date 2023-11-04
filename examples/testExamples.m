% Script to test the nRIM_CaImageExplorer functions with example data
% Add the main code directory to the path if necessary
 %addpath('/Users/yoe/Documents/repos/nRIM_CaImageExplorer/examples');

% Clear workspace and figures
clear;
close all;

% Define the paths to the example files
csvFilePath = 'testCaTraces.csv';
matFilePath = 'testCaTraces.mat';

% Load the CSV data, skipping first column (FIJI adds a row index in it)
[tracesCsv, metadataCsv] = readTraceData(csvFilePath, 'startColIndex', 1);

% Load the MAT data
tracesMat = readTraceData(matFilePath);

% Plot the CSV data
figure;
plot(tracesCsv);
title('Calcium Traces from CSV File');
xlabel('Time');
ylabel('Fluorescence Intensity');

% Plot the MAT data
figure;
plot(tracesMat);
title('Calcium Traces from MAT File');
xlabel('Time');
ylabel('Fluorescence Intensity');
