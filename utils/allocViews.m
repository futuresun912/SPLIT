function [minD,maxD,numD] = allocViews(numD,numV,ratioD)
%% Calculate the minD by the formula S = (a_1+a_n)*n/2

minD = (2*numD) / ((1+ratioD)*numV);
minD = round(minD);
maxD = minD * ratioD;

vecD = round(linspace(minD,maxD,numV));
numD = sum(vecD);


end
