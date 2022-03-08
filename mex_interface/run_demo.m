% clear;clc;
% clear;clc;clf;tic;
% addpath(genpath('./functs/'))

%cd D:\matlab.tools\db.toolbox\mex_interface
% Compile the demo as a mex file
% mex armaMex_demo.cpp -lblas_win64_MT.lib -llapack_win64_MT.lib

% Generate two random matrices
X = rand(4,5);
Y = rand(4,5);

% Run the demo using X and Y
% Z = armaMex_demo(X,Y)

mex armaxerrors.c