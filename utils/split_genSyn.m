function [data,target,para] = split_genSyn(para,flagRC) 

%% Initialization
numT = para.numT;
numV = para.numV;
numN = para.numN;
numD = para.numD;
minD = para.minD;
maxD = para.maxD;
numK = para.numK;

%% Initialization of statistics of synthetic data
muX  = 0;   sigmaX = 5;
muA  = 0;   sigmaA = 4;
muE  = 0;   sigmaE = 1;

%% Initialize the mask matrices for A, B and H
if isfield(para, 'mask_A')
    mask_A = para.mask_A;
else
    mask_A = rand(numD,numK);
    mask_A(mask_A<=para.pctA) = 0;
    mask_A(mask_A>0) = 1;
end
if isfield(para, 'mask_B')
    mask_B = para.mask_B;
    mask_B_tmp = fliplr(mask_B) * 0.3;
    mask_B = mask_B + mask_B_tmp;
else
    mask_B = rand(numV,numK);
    mask_B(mask_B<=para.pctB) = 0;
    mask_B(mask_B>0) = 1;
end
if isfield(para, 'mask_H')
    mask_H = para.mask_H;
else
    mask_H = rand(numK,numT);
    mask_H(mask_H<=para.pctH) = 0;
    mask_H(mask_H>0) = 1;
end

%% Get #features of every view
vecD = round(linspace(minD,maxD,numV));

%% Calculation of block diagonal matrix of all-ones
P = cell(numV,1);
for v = 1 : numV
    P{v} = ones(vecD(v),1);
end
P = sparse(blkdiag(P{:}));

%% Prevent any all-zero column in mask_W and mask_H
mask_W = mask_A .* (P*mask_B);
for k = 1 : numK
    if nnz(mask_W(:,k)) == 0
        i_rand = randperm(numV,1);
        numDv = vecD(i_rand);
        j_rand = randperm(numDv,max(3,round(numDv*(1-para.pctA))));
        j_rand = j_rand + sum(vecD(1:(i_rand-1)));
        mask_A(j_rand,k) = 1;
        mask_B(i_rand,k) = 1;
    end
end
for t = 1 : numT
    if nnz(mask_H(:,t)) == 0
        k_rand = randperm(numK,1);
        mask_H(k_rand,t) = 1; 
    end
end

%% Generation of A, B and H
A = mySample(numD,numK,muA,sigmaA) .* mask_A;
B_big = P * mask_B;
H = mySample(numK,numT,muA,sigmaA);
H = myRescale(H,-0.1,0.1);
H(logical(mask_H))= 1;

%% Generation of data
data = cell(numT,numV);
for t = 1 : numT
    for v = 1 : numV
        data{t,v} = mySample(numN,vecD(v),muX,sigmaX);
    end
end    

%% Generation of targets
W  = A .* B_big;
Ta = W * H;
target = cell(numT,1);
for t = 1 : numT
    target{t} = (cell2mat(data(t,:))*Ta(:,t))./numV + mySample(numN,1,muE,sigmaE);
    if flagRC
        target{t} = myBinary(target{t});
    end
end

%% Save some reaults
para.A = A;
para.B = mask_B;
para.W = W;
para.H = H;
para.numT = numT;
para.numV = numV;
para.numD = numD;
para.vecD = vecD;
para.flagRC = flagRC;

end