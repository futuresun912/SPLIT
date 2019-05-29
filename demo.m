% This is a demo program for the following paper: 
% 
% Multiplicative Feature Decomposition for Multi-View Multi-Task Sparse Learning. 
% A submission to the 28th International Joint Conference on Artificial Intelligence. 
%
% The program demonstrates the multiplicative feature decomposition of SPLIT on the synthetic dataset.
%
% Please type 'help SPLIT_train' or 'help SPLIT_test' under MATLAB prompt for more information.

rng('default')
addpath('utils');

%% Set a designed or random pattern for the weight matrix
flag_design  = true;    % designed (true) or random (false)

%% Set parameters
opts.lambda1 = 10^1;    % regularizaiton paramter \lambda_1
opts.lambda2 = 10^3;    % regularizaiton paramter \lambda_2
opts.eta     = 10^4;    % regularizaiton paramter \eta 
opts.numK    = 4;       % number of latent topics
opts.flagA   = false;   % regularization style on A (true: l2-norm; false: l1-norm)
opts.flagB   = true;    % regularization style on B (true: l2-norm; false: l1-norm)
opts.nIter   = 500;     % number of iterations
opts.absTol  = 10^-5;   % termination condition
opts.dbFlag  = false;   % debug information (true: display; false: nothing)
opts.flagRho = 'line';  % line search (true) or fixed (false) for opts.rho
opts.rho     = 10^-5;   % value of fixed learning rate

%% Generate the synthetic data
split_initGenSyn;
[data,target,para] = split_genSyn(para,flagRC);
[data] = standardize(data);

%% Separate data into training, validation and testing sets
para.trRt = 1.0;        % Ratio of training set
para.teRt = 0.0;        % Ratio of testing set
para.vaRt = 0.0;        % Ratio of validation set
para.pctL = 1.0;        % Ratio of labeled data in the training set
[Dtr,~,~] = splitData(data,target,para);  

%% Traingthe weight matrix of SPLIT
[Ta,STATS] = SPLIT_train(Dtr.Xl,Dtr.Y,opts);

%% Illustrate results
split_showRes;
