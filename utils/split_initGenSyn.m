%% Input checking
if ~exist('flagRC','var')
    flagRC = false;
end
if ~exist('flag_design','var')
    flag_design = false;
end

%% Set parameters
ratioD    = 3;     % ratioD = maxD / minD
para.numT = 8;     % number of tasks
para.numV = 4;     % number of views
para.numK = 4;     % number of latent topics
para.numN = 200;   % number of samples
para.numD = 200;   % number of faetures
para.pctA = 0.7;   % percentage of zero elements in A
para.pctB = 0.5;   % percentage of non-important elements in B
para.pctH = 0.3;   % percentage of non-important elements in H

%% Calculate the minimium and maximum number of features
[para.minD,para.maxD,para.numD] = allocViews(para.numD,para.numV,ratioD);

%% Design the pattern for weight matrices
if flag_design
    numK = para.numK;
    numT = para.numT;
    numV = para.numV;
    numD = para.numD;

    if rem(numT,numK) ~= 0
        error('please set numT/numK equal to an integar in the designed mode.')
    end
    
    vecD = round(linspace(para.minD,para.maxD,numV));    
    vecD = [0, vecD];
    mask_A = zeros(numD,numK);
    for k = 1 : numK
        idx = sum(vecD(1:k))+1 : sum(vecD(1:k+1));
        mask_A(idx,k) = 1;
    end
    mask_A = mask_A + fliplr(mask_A);
    mask_A(mask_A>1) = 1;    
    for j = 1 : numD
        if rem(j,numT) >= round(numT/2) 
            mask_A(j,:) = 0;
        end
    end
    mask_B = eye(numK);
    mask_H = zeros(numK,numT);
    idx = 1:round(numT/numK);
    for k = 1 : numK
        mask_H(k,idx) = 1;
        idx = idx + 2;
    end
    
    %% Save results
    para.mask_A = mask_A;
    para.mask_B = mask_B;
    para.mask_H = mask_H;
end

