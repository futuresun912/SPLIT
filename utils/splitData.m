function [ trSet,vaSet,teSet] = splitData( data,target,para)
%SPLITDATA Split a dataset into the training, validation and testing set
%   Detailed explanation goes here

%% Define split type
if size(data,1) == 1
    flagType = true;
elseif size(data,1) == size(target,1)
    flagType = false;
else
    error('The format of the input data is illegal.')
end

%% Obtain split percentage
trRt = para.trRt;
vaRt = para.vaRt;
teRt = para.teRt;
pctL = para.pctL;   

%% Initialization
numV = size(data,2);
numT = size(target,1);
Xltr = cell(numT,numV);  % labeled data
Xutr = cell(numT,numV);  % unlabeled data
Xva = cell(numT,numV);
Xte = cell(numT,numV);
Ytr = cell(numT,1);
Yva = cell(numT,1);
Yte = cell(numT,1);

%% Split it into training data, validation data and testing data
for t = 1 : numT
    % Split data into X and U
    if flagType
        num_samples = size(data{1,1},1);
    else
        num_samples = size(data{t,1},1);
    end
    
    % Split data into trainingn, validation and testing sets
    [trID,vaID,teID] = myDividerand(num_samples,trRt,vaRt,teRt);    

    % Split the training set into labeled and unlabeled data
    num_tr = length(trID);
    idx_xl = randperm(num_tr,round(pctL*num_tr));
    idx_xu = setdiff(1:num_tr,idx_xl);

    % Data splition
    Yt = target{t};
    Ytmp = Yt(trID);
    Ytr{t} = Ytmp(idx_xl);
    Yva{t} = Yt(vaID);
    Yte{t} = Yt(teID);
    for v = 1 : numV
        if flagType
            Xtv = data{1,v};
        else
            Xtv = data{t,v};
        end
        Xtmp = Xtv(trID,:);
        Xva{t,v} = Xtv(vaID,:);
        Xte{t,v} = Xtv(teID,:);
        Xltr{t,v} = Xtmp(idx_xl,:);
        Xutr{t,v} = Xtmp(idx_xu,:);
    end
end

%% Save results
trSet.Xl = Xltr;
trSet.Xu = Xutr;
trSet.Y  = Ytr;
vaSet.X  = Xva;
vaSet.Y  = Yva;
teSet.X  = Xte;
teSet.Y  = Yte;

end

