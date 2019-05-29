function [Ta,STATS] = SPLIT_train(X,Y,opts)
%SPLITTRAIN Training program for SPLIT
%
%       Input:
%           X       T x V labeled data cell, each entry denotes a labeled data matrix of a specific task-view
%           Y       T x 1 target cell, each entry is a target vector of a specific task-view
%           opts    hyper-parameters of SPLIT
%
%       Output
%           Ta      d x T weight matrix, each column is a weight vector for a specific task
%           STATS   a structure containing the learned models and information

%% Set a timer
Tstart = cputime;

%% Get hyperparameters
lambda1 = opts.lambda1;
lambda2 = opts.lambda2;
eta     = opts.eta;
numK    = opts.numK;
flagA   = opts.flagA;
flagB   = opts.flagB;
flagRho = opts.flagRho;
nIter   = opts.nIter;
absTol  = opts.absTol;
dbFlag  = opts.dbFlag;

%% Data statistics
[X,statD] = split_preproc(X);
numT = statD.numT;
numV = statD.numV;
numD = statD.numD;
idxD = statD.idxD;
vecD = statD.vecD;

%% Define the loss function
f = @(Ta) calLoss(X,Y,Ta);

%% Initialization
Fval = [];
A = rand(numD,numK);
B = ones(numV,numK);
Bc = ones(numD,numK);
H = rand(numK,numT);
P = cell(numV,1);
for v = 1 : numV
    P{v} = ones(vecD(v),1);
end
P = sparse(blkdiag(P{:}));

%% Iterative algorithm
switch flagRho
    case 'fix'
        rho = opts.rho_A;
    case 'line'
        rho = 1;
end
c_new = 1;
A_hat = A;
for iter = 1 : nIter
    if dbFlag
        tic;
    end
    
    % Update the coefficients
    A_old = A;
    c_old = c_new;
    
    % Step 1: Update A
    Ta_hat = (A_hat.*Bc)*H;
    if flagA    % l2 on A ---> accelerated gradient method
        grad_A = calGradA(X,Y,Ta_hat,Bc,H) + lambda1.*A_hat;
        switch flagRho
            case 'line'
                while 1
                    A = A_hat - rho*grad_A;
                    if f((A.*Bc)*H) + (lambda1/2)*sum(A(:).^2) <= f(Ta_hat) + (lambda1/2)*sum(A_hat(:).^2) ...
                            + sum(dot(grad_A,A-A_hat,1)) + sum(sum((A-A_hat).^2))/(2*rho)
                        break;
                    else
                        rho = rho / 2;
                    end
                end
            case 'fix'
                A = A_hat - rho*grad_A;
        end
    else        % l1 on A ---> accelerated proximal method
        grad_A = calGradA(X,Y,Ta_hat,Bc,H);
        switch flagRho
            case 'line'
                while 1
                    A = prox_l1(A_hat-rho*grad_A,rho*lambda1);
                    if f((A.*Bc)*H) <= f(Ta_hat) + sum(dot(grad_A,A-A_hat,1)) + ...
                            sum(sum((A-A_hat).^2))/(2*rho)
                        break;
                    else
                        rho = rho / 2;
                    end
                end
            case 'fix'
                A = prox_l1(A_hat-rho*grad_A,rho*lambda1);
        end
    end
    
    % Step 2: Update B
    for v = 1 : numV
        for k = 1 : numK
            if flagA
                if flagB
                    B(v,k) = sqrt((lambda1/lambda2)*sum(A(idxD{v},k).^2));
                else
                    B(v,k) = (lambda1/lambda2)*sum(A(idxD{v},k).^2);
                end
            else
                if flagB
                    B(v,k) = sqrt((lambda1/lambda2)*sum(abs(A(idxD{v},k))));
                else
                    B(v,k) = (lambda1/lambda2)*sum(abs(A(idxD{v},k)));
                end
            end
        end
    end
    Bc = P * B;
    
    % Step 3: Update H
    W = A .* Bc;
    for t = 1 : numT
        tXt = X{t} * W;
        H(:,t) = (tXt'*tXt+eta*eye(numK)) \ (tXt'*Y{t});
    end
    
    % Check the convergence condition
    Fval = cat(1,Fval,calFval(X,Y,A,B,W,H,opts));
    if iter>1 && abs(Fval(iter)-Fval(iter-1))/Fval(iter-1)<absTol
        break;
    end
    
    % Output debug information if necessary
    if dbFlag
        disp([num2str(iter),'th iter, obj: ',num2str(Fval(iter)),'; time: ',num2str(toc)]);
    end
    
    % Update the coefficients
    c_new = (1+sqrt(1+4*c_old^2))/2;
    A_hat = A + (c_old-1)/c_new*(A-A_old);
    
end
if dbFlag
    disp(['SPLIT converged at the ',num2str(iter),'-th iteration with value: ',num2str(Fval(iter))]);
end

%% Save results
Ta = W * H;
STATS.A    = A;
STATS.B    = B;
STATS.W    = W;
STATS.H    = H;
STATS.Fval = Fval;
STATS.time = cputime - Tstart;

end

%% Calculate the gradient w.r.t. A
function grad_A = calGradA(X,Y,Ta,Bc,H)
numT = size(Y,1);
[numD,numK] = size(Bc);
grad_A = zeros(numD,numK);
Ch = zeros(numD,numT);  % cached results repeatedly used
for t = 1 : numT
    Ch(:,t) = X{t}' * (X{t}*Ta(:,t)-Y{t});
end
for k = 1 : numK
    Ch_k = bsxfun(@times,Ch,H(k,:));
    grad_A(:,k) = Bc(:,k).*sum(Ch_k,2); 
end
end

%% Calculate the objective value
function fval = calFval(X,Y,A,B,W,H,opts)
Loss = calLoss(X,Y,W*H);
R1 = calRegul(opts.lambda1,A,opts.flagA);
R2 = calRegul(opts.lambda2,B,opts.flagB);
R3 = calRegul(opts.eta,H,true);
fval = Loss + R1 + R2 + R3;
end

%% Calculate the regularization term
function regul = calRegul(beta,Z,flagZ)
if flagZ   % squared l2-regularization
    regul = 0.5 * beta * sum(Z(:).^2);    
else       % l1-regularization
    regul = beta * sum(abs(Z(:)));
end
end

%% Calculate the loss function
function loss = calLoss(X,Y,Ta)
numT = size(Y,1);
loss = 0;
for t = 1 : numT
    loss = loss + sum((Y{t}-X{t}*Ta(:,t)).^2);    
end
loss = 0.5 * loss;
end
