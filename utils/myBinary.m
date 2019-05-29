function Y = myBinary(X)
%% MYBINARY: the bianrization function for binary responses

Y = ones(size(X));
Y(X<0) = -1;
% Y = round(X);
% Y(Y>1) = 1;
% Y(Y<0) = 0;

end

