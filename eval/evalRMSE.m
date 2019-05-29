function [ value ] = evalRMSE( Ypre,Yte )
%EVALRMSE Summary of this function goes here
%   Detailed explanation goes here

numT = size(Yte,1);
values = zeros(numT,1);
for t = 1 : numT
    values(t) = sqrt(sum(power(Ypre{t}(:)-Yte{t}(:),2)) / length(Yte{t}));
end
value = mean(values);

end

