function [value] = evalMicroF1(Ypre,Yte)
% Multi-Task Micro-F1 score

numT = size(Yte,1);
Precisions = zeros(numT,1);
Recalls = zeros(numT,1);
for t = 1 : numT
    Yte{t}(Yte{t}>0) = 1;
    Yte{t}(Yte{t}<=0) = 0;
    Ypre{t}(Ypre{t}>0) = 1;
    Ypre{t}(Ypre{t}<=0) = 0;
    XandY = Yte{t}(:)&Ypre{t}(:);
    Precisions(t)=(sum(XandY(:))+1)/(sum(Ypre{t}(:))+1);
    Recalls(t)=(sum(XandY(:))+1)/(sum(Yte{t}(:))+1);
end
Precision = mean(Precisions);
Recall = mean(Recalls);
value = 2*Precision*Recall/(Precision+Recall);

end

