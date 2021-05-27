% new figures  - instead of L/R split, contra/ipsilesional spltit
% heat map differences for regularization parameters
%Plot the heatmap of the remapping across each time point according to the
%Yeo networks.

% right lesions
rightlesion = [1,1,0,0,1,0,1,1,1,1,0,0 0,1,1,0,0,1,1,1,1,0,1];

d=1;
q=1;
threshold =1;
beta = 1;
alpha = 0;

curr_dir=pwd;
%cast data
data_dir=strcat(curr_dir, '/cast_data/results/regularized/')
a=readmatrix('/Users/emilyolafson/GIT/stroke-graph-matching/project/shen_268_parcellation_networklabels.csv')
c=a(:,2);

S1S2_np=[]
S1S2_np=load(strcat(data_dir, 'cols_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
order=0:267; 
remappings_12=[];
for j=1:13
    for i=1:268
        if (S1S2_np(j,i)==order(i))
            remappings_12(j,i)=0;
        else
            remappings_12(j,i)=1;
        end
    end
end

remaps=sum(remappings_12);
highremaps_ctl=remaps>=threshold; % cutoff for # of cast windows in which node is remapped

% load stroke data
data_dir=strcat(curr_dir, '/project/results/precision/');
S1S2_np=load(strcat(data_dir, 'cols_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S2S3_np=load(strcat(data_dir, 'cols_S2S3_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S3S4_np=load(strcat(data_dir, 'cols_S3S4_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S4S5_np=load(strcat(data_dir, 'cols_S4S5_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.

S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];

S1S2_np(:,highremaps_ctl)=NaN;
S2S3_np(:,highremaps_ctl)=NaN;
S3S4_np(:,highremaps_ctl)=NaN;
S4S5_np(:,highremaps_ctl)=NaN;

subjects=[1:23];
rsub=subjects(logical(rightlesion));

S1S2_npR=S1S2_np(rsub,:)+1;
S2S3_npR=S2S3_np(rsub,:)+1;
S3S4_npR=S3S4_np(rsub,:)+1;
S4S5_npR=S4S5_np(rsub,:)+1;

% Get remapping matrices (1/0)
order=1:268;
allswap_pairwise=zeros(268,268);
sub_indices=S1S2_npR
for i=1:14
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s2_s1_freq_right{d,q}=allswap_pairwise;

allswap_pairwise=zeros(268,268);

clear sub_indices;
sub_indices=S2S3_npR;
for i=1:14
    if i==12
        continue;
    end
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s3_s2_freq_right{d,q}=allswap_pairwise;
allswap_pairwise=zeros(268,268);

clear sub_indices;
sub_indices=S3S4_npR;
for i=1:14
    if i==12
        continue;
    end
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s4_s3_freq_right{d,q}=allswap_pairwise;

allswap_pairwise=zeros(268,268);
clear sub_indices;
sub_indices=S4S5_npR;
for i=1:14
     if i==12
        continue;
    end
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s5_s4_freq_right{d,q}=allswap_pairwise;

% right lesions

all_sums_s1s2_right{d,q}=yeonetwork_remaps(norm_s2_s1_freq_right{d,q});
all_sums_s2s3_right{d,q}=yeonetwork_remaps(norm_s3_s2_freq_right{d,q});
all_sums_s3s4_right{d,q}=yeonetwork_remaps(norm_s4_s3_freq_right{d,q});
all_sums_s4s5_right{d,q}=yeonetwork_remaps(norm_s5_s4_freq_right{d,q});

    
data_dir=strcat(curr_dir, '/project/results/precision/');
S1S2_np=load(strcat(data_dir, 'cols_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S2S3_np=load(strcat(data_dir, 'cols_S2S3_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S3S4_np=load(strcat(data_dir, 'cols_S3S4_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S4S5_np=load(strcat(data_dir, 'cols_S4S5_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.

S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];

S1S2_np(:,highremaps_ctl)=NaN;
S2S3_np(:,highremaps_ctl)=NaN;
S3S4_np(:,highremaps_ctl)=NaN;
S4S5_np(:,highremaps_ctl)=NaN;

subjects=[1:23];
lsub=subjects(~logical(rightlesion));

S1S2_npL=S1S2_np(lsub,:)+1;
S2S3_npL=S2S3_np(lsub,:)+1;
S3S4_npL=S3S4_np(lsub,:)+1;
S4S5_npL=S4S5_np(lsub,:)+1;
% Get remapping matrices (1/0)
order=1:268;

allswap_pairwise=zeros(268,268);
sub_indices=S1S2_npL;
for i=1:9
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s2_s1_freq_left{d,q}=allswap_pairwise;

allswap_pairwise=zeros(268,268);

clear sub_indices;
sub_indices=S2S3_npL;
for i=1:9
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s3_s2_freq_left{d,q}=allswap_pairwise;
allswap_pairwise=zeros(268,268);

clear sub_indices;
sub_indices=S3S4_npL;
for i=1:9
    if i==5
        continue
    end
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s4_s3_freq_left{d,q}=allswap_pairwise;

allswap_pairwise=zeros(268,268);
clear sub_indices;
sub_indices=S4S5_npL;
for i=1:9
    if i==5
        continue
    end
    if i==3
        continue
    end
    for j=1:268
        for k=1:1:268
            if sub_indices(i,j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s5_s4_freq_left{d,q}=allswap_pairwise;


all_sums_s1s2_left{d,q}=yeonetwork_remaps(norm_s2_s1_freq_left{d,q});
all_sums_s2s3_left{d,q}=yeonetwork_remaps(norm_s3_s2_freq_left{d,q});
all_sums_s3s4_left{d,q}=yeonetwork_remaps(norm_s4_s3_freq_left{d,q});
all_sums_s4s5_left{d,q}=yeonetwork_remaps(norm_s5_s4_freq_left{d,q});


%%combine Left and Right into "Contralesional" versus "Ipsilesional"

% all_sums order - 16x16 grid, 8x8 for each section
%S1-S2
%top left: RR
%bottom left: LR
%top right: RL
%bottom right: LL

%S1S2
combined_ii=all_sums_s1s2_left{d,q}(9:16,9:16)+all_sums_s1s2_right{d,q}(1:8,1:8);%first row: ipsi-ipsi
combined_cc=all_sums_s1s2_left{d,q}(1:8,1:8)+all_sums_s1s2_right{d,q}(9:16,9:16);%second row: contra-contra
combined_ic=all_sums_s1s2_left{d,q}(9:16,1:8)+all_sums_s1s2_right{d,q}(1:8,9:16);%third row: ipsi-contra
combined_ci=all_sums_s1s2_left{d,q}(1:8,9:16)+all_sums_s1s2_right{d,q}(9:16,1:8);%fourth row: contra-ipsi

s1s2ii=sum(sum(combined_ii))
s1s2cc=sum(sum(combined_cc))

combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls1s2=[combined1;combined2];

%S2S3
combined_ii=all_sums_s2s3_left{d,q}(9:16,9:16)+all_sums_s2s3_right{d,q}(1:8,1:8);%first row: ipsi-ipsi
combined_cc=all_sums_s2s3_left{d,q}(1:8,1:8)+all_sums_s2s3_right{d,q}(9:16,9:16);%second row: contra-contra
combined_ic=all_sums_s2s3_left{d,q}(9:16,1:8)+all_sums_s2s3_right{d,q}(1:8,9:16);%third row: ipsi-contra
combined_ci=all_sums_s2s3_left{d,q}(1:8,9:16)+all_sums_s2s3_right{d,q}(9:16,1:8);%fourth row: contra-ipsi
s2s3ii=sum(sum(combined_ii))
s2s3cc=sum(sum(combined_cc))

combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls2s3=[combined1;combined2];

%S3S4
combined_ii=all_sums_s3s4_left{d,q}(9:16,9:16)+all_sums_s3s4_right{d,q}(1:8,1:8);%first row: ipsi-ipsi
combined_cc=all_sums_s3s4_left{d,q}(1:8,1:8)+all_sums_s3s4_right{d,q}(9:16,9:16);%second row: contra-contra
combined_ic=all_sums_s3s4_left{d,q}(9:16,1:8)+all_sums_s3s4_right{d,q}(1:8,9:16);%third row: ipsi-contra
combined_ci=all_sums_s3s4_left{d,q}(1:8,9:16)+all_sums_s3s4_right{d,q}(9:16,1:8);%fourth row: contra-ipsi
s3s4ii=sum(sum(combined_ii))
s3s4cc=sum(sum(combined_cc))

combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls3s4=[combined1;combined2];

%S4S5
combined_ii=all_sums_s4s5_left{d,q}(9:16,9:16)+all_sums_s4s5_right{d,q}(1:8,1:8);%first row: ipsi-ipsi
combined_cc=all_sums_s4s5_left{d,q}(1:8,1:8)+all_sums_s4s5_right{d,q}(9:16,9:16);%second row: contra-contra
combined_ic=all_sums_s4s5_left{d,q}(9:16,1:8)+all_sums_s4s5_right{d,q}(1:8,9:16);%third row: ipsi-contra
combined_ci=all_sums_s4s5_left{d,q}(1:8,9:16)+all_sums_s4s5_right{d,q}(9:16,1:8);%fourth row: contra-ipsi
s4s5ii=sum(sum(combined_ii))
s4s5cc=sum(sum(combined_cc))

combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls4s5=[combined1;combined2];

plot([s1s2ii,s2s3ii,s3s4ii,s4s5ii])
hold on;
plot([s1s2cc,s2s3cc,s3s4cc,s4s5cc])

close all;

figure(1)
figure('Position', [0 0 550 500])
imagesc(combined_alls1s2)
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association','Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});
yticks(1:16)
yticklabels(yeolabels)
xticks(1:16)
xticklabels(yeolabels)
xtickangle(45)
set(gca,'FontSize', 13)
colormap 'hot'
%caxis([0 3])


figure(2)
figure('Position', [0 0 550 500])
imagesc(combined_alls2s3)
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association','Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});
yticks(1:16)
yticklabels(yeolabels)
xticks(1:16)
xticklabels(yeolabels)
xtickangle(45)
set(gca,'FontSize', 13)
colormap 'hot'
%caxis([0 3])

figure(3)
figure('Position', [0 0 550 500])
imagesc(combined_alls3s4)
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association','Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});
yticks(1:16)
yticklabels(yeolabels)
xticks(1:16)
xticklabels(yeolabels)
xtickangle(45)
set(gca,'FontSize', 13)
colormap 'hot'
%caxis([0 3])

figure(4)
figure('Position', [0 0 550 500])
imagesc(combined_alls4s5)
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association','Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});
yticks(1:16)
yticklabels(yeolabels)
xticks(1:16)
xticklabels(yeolabels)
xtickangle(45)
set(gca,'FontSize', 13)
colormap 'hot'
%caxis([0 3])


mat=cat(3, combined_alls1s2, combined_alls2s3, combined_alls3s4, combined_alls4s5);
mean_all=mean(mat,3)
figure(6)
figure('Position', [0 0 550 500])
imagesc(mean_all)
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association','Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});
yticks(1:16)
yticklabels(yeolabels)
xticks(1:16)
xticklabels(yeolabels)
xtickangle(45)
set(gca,'FontSize', 13)
colormap 'hot'
%caxis([0 3])

%% GLM



%% differences in remap patterns across alphas (rows, :)
% want to capture remap sums across 8*4 networks and with each alpha.
% just go one at a time.
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});

figure('Position', [0 0 1000 1000])

tiledlayout(4,4, 'padding', 'none')

% alpha = 0, beta = 0 
nexttile;
sums=combined{1, 2}(1,
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s1s2{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s1s2{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s1s2{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s1s2{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s1s2{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s1s2{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s1s2{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s1s2{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s1s2{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s1s2{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s1s2{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s1s2{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s1s2{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s1s2{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s1s2{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

sgtitle('S1-S2 off-diagonal swaps')

saveas(gcf, strcat(data_dir, 'all_alpha_beta_yeonetwork_sumswaps-S1S2_contraipsi.png'))

%% S2-S3
figure('Position', [0 0 1000 1000])

tiledlayout(4,4, 'padding', 'none')

% alpha = 0, beta = 0 
nexttile;
sums=all_sums_s2s3{1, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s2s3{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s2s3{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s2s3{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s2s3{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s2s3{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s2s3{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s2s3{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s2s3{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s2s3{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s2s3{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s2s3{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s2s3{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s2s3{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s2s3{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s2s3{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

sgtitle('S2-S3 off-diagonal swaps')
saveas(gcf, strcat(data_dir, 'all_alpha_beta_yeonetwork_sumswaps-S2S3_contraipsi.png'))


%% S3S4
figure('Position', [0 0 1000 1000])

tiledlayout(4,4, 'padding', 'none')

% alpha = 0, beta = 0 
nexttile;
sums=all_sums_s3s4{1, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s3s4{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s3s4{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s3s4{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s3s4{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s3s4{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s3s4{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s3s4{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s3s4{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s3s4{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s3s4{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s3s4{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s3s4{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s3s4{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s3s4{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s3s4{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

sgtitle('S3-S4 off-diagonal swaps')

saveas(gcf, strcat(data_dir, 'all_alpha_beta_yeonetwork_sumswaps-S3S4_contraipsi.png'))

%% S4-S5
figure('Position', [0 0 1000 1000])
tiledlayout(4,4, 'padding', 'none')

% alpha = 0, beta = 0 
nexttile;
sums=all_sums_s4s5{1, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s4s5{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s4s5{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s4s5{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s4s5{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s4s5{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s4s5{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s4s5{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s4s5{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s4s5{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s4s5{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s4s5{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s4s5{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s4s5{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s4s5{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s4s5{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'}) 

sgtitle('S4-S5 off-diagonal swaps')
saveas(gcf, strcat(data_dir, 'all_alpha_beta_yeonetwork_sumswaps-S4S5_contraipsi.png'))
