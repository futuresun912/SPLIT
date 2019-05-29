function [X,statD] = split_preproc(X_raw)
% Pre-processing for SPLIT

[numT,numV] = size(X_raw);
vecD = zeros(numV,1);
idxD = cell(numV,1);
startID = 1;
for v = 1:numV
    numDv = size(X_raw{1,v},2);
    endID   = startID + numDv;
    idxD{v} = startID : (endID-1);
    startID = endID;
    vecD(v) = numDv;
end
numD = idxD{end}(end);  
X = cell(numT,1);
for t = 1 : numT
    X{t} = cell2mat(X_raw(t,:)) / numV;  % Absorb (1/V) into X for convenience
end

statD.numT = numT;
statD.numV = numV;
statD.numD = numD;
statD.vecD = vecD;
statD.idxD = idxD;

end