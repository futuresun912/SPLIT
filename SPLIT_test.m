function [Ypre,Yout] = SPLIT_test(X,Ta,opts)
%SPLITTEST Testing program for SPLIT
%
%       Input:
%           Xte     T x V data cell, each entry denotes a testing data matrix of a specific task-view
%           Ta      d x T weight matrix, each column is a weight vector for a specific task
%           opts    parameters of AGILE
%
%       Output
%           Yout    T x 1 output cell of prediction scores
%           Ypre    T x 1 prediction cell

flagRC = opts.flagRC;
[numT,numV] = size(X);
Ypre = cell(numT,1);
Yout = cell(numT,1);
for t = 1 : numT
    Yout{t} = (cell2mat(X(t,:))*Ta(:,t)) / numV;    
    if flagRC
        Ypre{t} = myBinary(Yout{t});
    else
        Ypre{t} = Yout{t};
    end
end

end