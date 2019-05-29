function [value] = evalMacroF1(Ypre,Yte)
% Multi-Task Macro-F1 score

numT = size(Yte,1);
values = zeros(numT,1);
for t = 1 : numT
    Yte{t}(Yte{t}>0) = 1;
    Yte{t}(Yte{t}<=0) = 0;
    Ypre{t}(Ypre{t}>0) = 1;
    Ypre{t}(Ypre{t}<=0) = 0;
    XandY = Yte{t}(:)&Ypre{t}(:);
    Precision=(sum(XandY(:))+1)/(sum(Ypre{t}(:))+1);
    Recall=(sum(XandY(:))+1)/(sum(Yte{t}(:))+1);
    values(t) = 2*Precision*Recall/(Precision+Recall);
end
value = mean(values);

end

