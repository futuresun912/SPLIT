% function [data,data_raw,para] = standardizeData(data,para)
% function [data,para] = standardize(data,para)
function [data] = standardize(data)
% Standardize the data and add bias dimensionality to each view

% data_raw = data;
[numT,numV] = size(data);
for t = 1 : numT
    numNt = size(data{t,1},1);
    for v = 1 : numV
        data{t,v} = zscore(data{t,v});
        data{t,v} = cat(2,data{t,v},ones(numNt,1));
    end
end

% %% Expand the ground truth W and H
% W = para.W;
% H = para.H;
% startID = 1;
% idxD = cell(numV,1);
% vecD = para.vecD;
% for v = 1 : numV
%     endID   = startID + vecD(v);
%     idxD{v} = startID : (endID-1);
%     startID = endID;
% end
% % Wtmp = [];
% % Htmp = [];
% % for v = 1 : numV
% %     Wv = cat(1,W(idxD{v},:),zeros(1,numT));
% %     Wtmp = cat(1,Wtmp,Wv);
% %     Hv = cat(1,H(idxD{v},:),zeros(1,numT));
% %     Htmp = cat(1,Htmp,Hv);    
% % end
% 
% % para.vecD_raw = para.vecD;
% para.vecD = vecD + 1;
% % para.W = Wtmp;
% % para.H = Htmp;

end