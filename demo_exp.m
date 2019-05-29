% This is a demo program for the following paper: 
% 
% Multiplicative Feature Decomposition for Multi-View Multi-Task Sparse Learning. 
% A submission to the 28th International Joint Conference on Artificial Intelligence. 
%
% The program demonstrates how SPLIT works on a multi-view multi-task dataset.
%
% Please type 'help SPLIT_train' or 'help SPLIT_test' under MATLAB prompt for more information.

rng('default')
addpath('utils','eval');

%% Set global parameter
flagRC  = true;         % classification (true) or regression (false): data generation

%% Generate the synthetic data
flag_design = true;
split_initGenSyn;
[data,target,para] = split_genSyn(para,flagRC);
data = standardize(data);

%% Set hyper-parameters for the learner and experiment
split_initPara;

%% Experiments with random data partition
all_res = zeros(nMet,nFold);
for fold_id = 1 : nFold
    [Dtr,~,Dte] = splitData(data,target,para);
    [Ta,STATS]  = SPLIT_train(Dtr.Xl,Dtr.Y,opts);
    [Ypre,Yout] = SPLIT_test(Dte.X,Ta,opts);
    [all_res(:,fold_id),met_set] = evaluation(Ypre,Yout,Dte.Y,STATS.time,flagRC);
end
mean_res = squeeze(mean(all_res,2));
std_res  = squeeze(std(all_res,0,2) / sqrt(nFold));

%% Illustration of results
printmat([mean_res,std_res],'synData_SPLIT',met_set,'Mean Std.');
