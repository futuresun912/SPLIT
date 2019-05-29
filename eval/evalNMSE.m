function [ value ] = evalNMSE( Ypre,Yte )
%EVALNMSE Summary of this function goes here
%   Detailed explanation goes here

numT = size(Yte,1);
values = zeros(numT,1);

for t = 1:numT
    numN = length(Yte{t});
    value_1 = sum(power(Ypre{t}(:)-Yte{t}(:),2)) / numN;
    value_2 = sum(Ypre{t}(:)) / numN;
    value_3 = sum(Yte{t}(:)) / numN;
    values(t) = value_1 / abs(value_2*value_3);
end
value = mean(values);

end

