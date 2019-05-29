%% Number of repeated experiments
nFold  = 2;

%% Classification (true) or Regression (false)
if flagRC
    nMet = 5;
else
    nMet = 3;
end

%% For selected learner
opts.flagRC  = flagRC;   % classification (true) or regression (false)
opts.lambda1 = 10^0;     % regularization parameter for A
opts.lambda2 = 10^0;     % regularization parameter for B
opts.eta     = 10^0;     % regularization parameter for H
opts.numK    = 4;        % number of latent topics
opts.nIter   = 500;      % maximum number of main iterations
opts.absTol  = 10^-5;    % tolerance for teminating the iterative algorithm
opts.dbFlag  = false;    % show debug information (true) or not (false)
opts.flagRho = 'line';   % line search (true) or fixed (false)
opts.rho     = 10^-5;    % Learning rate for gradient descent

%% For data splition
para.trRt = 0.6;          % Ratio of training data
para.teRt = 0.2;          % Ratio of testing data
para.vaRt = 0.2;          % Ratio of validation data
para.pctL = 1.0;          % Ratio of labeled data in training set
