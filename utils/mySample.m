%% Define the sampling function (X \sim N(mu,sigma^2))
function X = mySample(dim1,dim2,mu,sigma)
X = sigma*randn(dim1,dim2)+mu;  
end 
