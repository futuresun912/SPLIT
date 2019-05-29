function [value] = evalAUC(Yout,Yte)
% Multi-Task Area Under the Curve
% Yte:    each cell has a n*1 matrix of categories {0,1}
% Yout:   each cell has a n*1 matrix of posterior probabilities for class 1
% value:  Area under the curve

numT = size(Yte,1);
values = zeros(numT,1);
for t = 1:numT
    Yte{t}(Yte{t}<0) = 0;
    values(t) = scoreAUC(Yte{t}(:),Yout{t}(:));
end
value = mean(values);

end
