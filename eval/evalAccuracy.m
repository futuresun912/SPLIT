function [value] = evalAccuracy(Ypre,Yte)
% Multi-Task Accuracy

numT = size(Yte,1);
values = zeros(numT,1);
for t = 1 : numT
    Yte{t}(Yte{t}>0) = 1;
    Yte{t}(Yte{t}<=0) = 0;
    Ypre{t}(Ypre{t}>0) = 1;
    Ypre{t}(Ypre{t}<=0) = 0;
    values(t) = sum(Yte{t}(:) == Ypre{t}(:))/length(Yte{t});
end
value = mean(values);

end
