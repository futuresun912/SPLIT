function [ value ] = evalMAE( Ypre,Yte )
%EVALMAE Summary of this function goes here
%   Detailed explanation goes here

numT = size(Yte,1);
values = zeros(numT,1);
for t = 1 : numT
    values(t) = sum(abs(Ypre{t}(:)-Yte{t}(:))) / length(Yte{t});
end
value = mean(values);

end

