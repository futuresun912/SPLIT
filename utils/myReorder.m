function STATS = myReorder(STATS,para)

A = STATS.A;
B = STATS.B;
W = STATS.W;
H = STATS.H;
Bg = para.B;
numK = para.numK;
order = [];
for k = 1 : numK
    [~,j] = max(B' * Bg(:,k));
    order = cat(1,order,j);
end
    
STATS.A = A(:,order);
STATS.B = B(:,order);
STATS.W = W(:,order);
STATS.H = H(order,:);

end