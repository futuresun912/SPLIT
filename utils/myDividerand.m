function [ trID,vaID,teID ] = myDividerand( numN,trRt,vaRt,teRt )
%MYDIVIDERAND Summary of this function goes here
%   Detailed explanation goes here

totalRt = trRt + vaRt + teRt;
totalID = randperm(numN,round(totalRt*numN));
numTr = round(trRt*numN);
numVa = round(vaRt*numN);
trID = totalID(1:numTr);
vaID = totalID((numTr+1):(numTr+numVa));
teID = setdiff(totalID,[trID,vaID]);


end

