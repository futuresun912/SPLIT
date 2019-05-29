close all

%% Save figures or not
flag_save = false;

%% Reorder the topic in W, A and B according to para
if opts.numK == para.numK
    STATS_tmp = myReorder(STATS,para);
else 
    STATS_tmp = STATS;
end

%% Get resutls
Wg = para.W;
Ag = para.A;
Bg = para.B;
Hg = para.H;
A  = STATS_tmp.A;
B  = STATS_tmp.B;
H  = STATS_tmp.H;
W  = STATS_tmp.W;

%% Calculate the learned weight matrix
numV = para.numV;
vecD = para.vecD;
P = cell(numV,1);
for v = 1 : numV
    P{v} = ones(vecD(v),1);
end
P = sparse(blkdiag(P{:}));
B_big  = P * B;
Bg_big = P * Bg;

%% Remove the bias dimensionalities from W and A
vecD = para.vecD + 1;
id_start = 0;
idx_remove = [];
for v = 1 : numV
    id_tmp = id_start + vecD(v);
    idx_remove = cat(1,idx_remove,id_tmp);
    id_start = id_tmp;
end
W(idx_remove,:) = [];
A(idx_remove,:) = [];

%% For visuallization
max_val1 = 255;
max_val2 = 63;
Tg = Wg * Hg;
T  = W * H;
W_img = myRescale(abs(W),0,max_val1);
A_img = myRescale(abs(A),0,max_val1);
B_img = myRescale(abs(B_big),0,max_val2);
H_img = myRescale(abs(H),0,max_val1);
T_img = myRescale(abs(T),0,max_val1);
Wg_img = myRescale(abs(Wg),0,max_val1);
Ag_img = myRescale(abs(Ag),0,max_val1);
Bg_img = myRescale(abs(Bg_big),0,max_val2);
Hg_img = myRescale(abs(Hg),0,max_val1);
Tg_img = myRescale(abs(Tg),0,max_val1);

%% Set the label size in figures
label_size = 20;
tick_size  = 10;

%% Designed patterns of weight matrices 
fig1 = figure;
subplot(5,1,1)
image(Ag_img')
a = get(gca,'xticklabel');
set(gca,'xticklabel',a,'fontsize',tick_size);
ylabel('$\mathbf{A}^{\ast\top}$','interpreter','latex','fontsize',label_size);
subplot(5,1,2)
image(Bg_img')
a = get(gca,'xticklabel');
set(gca,'xticklabel',a,'fontsize',tick_size);
ylabel('$\mathbf{B}^{\ast\top}$','interpreter','latex','fontsize',label_size);
subplot(5,1,3)
image(Wg_img');
a = get(gca,'xticklabel');
set(gca,'xticklabel',a,'fontsize',tick_size);
ylabel('$\mathbf{W}^{\ast\top}$','interpreter','latex','fontsize',label_size);
subplot(5,1,4)
image(Hg_img)
a = get(gca,'xticklabel');
set(gca,'xticklabel',a,'fontsize',tick_size);
ylabel('$\mathbf{H}^{\ast}$','interpreter','latex','fontsize',label_size);
subplot(5,1,5)
image(Tg_img')
a = get(gca,'xticklabel');
set(gca,'xticklabel',a,'fontsize',tick_size);
ylabel('$\Theta^{\ast\top}$','interpreter','latex','fontsize',label_size);
suptitle('Designed weight matrices');

%% Designed patterns of weight matrices 
fig2 = figure;
subplot(5,1,1)
image(A_img')
a = get(gca,'xticklabel');
set(gca,'xticklabel',a,'fontsize',tick_size);
ylabel('$\mathbf{A}^{\top}$','interpreter','latex','fontsize',label_size);
subplot(5,1,2)
image(B_img')
a = get(gca,'xticklabel');
set(gca,'xticklabel',a,'fontsize',tick_size);
ylabel('$\mathbf{B}^{\top}$','interpreter','latex','fontsize',label_size);
subplot(5,1,3)
image(W_img');
a = get(gca,'xticklabel');
set(gca,'xticklabel',a,'fontsize',tick_size);
ylabel('$\mathbf{W}^{\top}$','interpreter','latex','fontsize',label_size);
subplot(5,1,4)
image(H_img)
a = get(gca,'xticklabel');
set(gca,'xticklabel',a,'fontsize',tick_size);
ylabel('$\mathbf{H}$','interpreter','latex','fontsize',label_size);
subplot(5,1,5)
image(T_img')
a = get(gca,'xticklabel');
set(gca,'xticklabel',a,'fontsize',tick_size);
ylabel('$\Theta^{\top}$','interpreter','latex','fontsize',label_size);
suptitle('Learned weight matrices');

%% Save the figures 
if flag_save
    saveas(fig1,'plus_demo_designed','png');
    saveas(fig2,'plus_demo_learned','png');    
end

