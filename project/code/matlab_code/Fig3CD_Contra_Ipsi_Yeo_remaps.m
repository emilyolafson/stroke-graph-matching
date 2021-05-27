% Calculate remapping within Yeo networks, splitting remapping into whether
% it occurred in the same or opposite hemisphere as the lesion.
clear all;
close all;
% right hemisphere lesions (for stroke subjects - 1 = right, 0 = left)
rightlesion = [1,1,0,0,1,0,1,1,1,1,0,0 0,1,1,0,0,1,1,1,1,0,1];

threshold = 1;
beta = 1;
alpha = 0;  % old regularization; not used (use alpha = 0 for all results in paper)

curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/';

%% load cast data in order to find indices that remap
data_dir=strcat(curr_dir, 'data/cast_data/results/regularized/')
S1S2_np=[]
S1S2_np=load(strcat(data_dir, 'cols_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')) % no regularization.

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

remaps_cast=sum(remappings_12)

%% 28andme -  find indices that remap
data_dir=strcat(curr_dir, 'data/28andme/results/regularized/')

S1S2_np=[]
S1S2_np=load(strcat(data_dir, 'cols_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')) % no regularization.

order=0:267; 

remappings_12=[];

for j=1:6
    for i=1:268
        if (S1S2_np(j,i)==order(i))
            remappings_12(j,i)=0;
        else
            remappings_12(j,i)=1;
        end
    end
end
remaps28=sum(remappings_12);

%% combine all remaps from 28andme and cast dataset
remapsall=remaps28+remaps_cast
highremaps_ctl=remapsall>=threshold % cutoff for # of cast windows in which node is remapped

data_dir=strcat(curr_dir, 'project/results/precision/');

S1S2_np=load(strcat(data_dir, 'cols_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % 
S2S3_np=load(strcat(data_dir, 'cols_S2S3_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); %
S3S4_np=load(strcat(data_dir, 'cols_S3S4_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); %
S4S5_np=load(strcat(data_dir, 'cols_S4S5_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % 

% subjects with missing data
S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];

S1S2_np(:,highremaps_ctl)=NaN;
S2S3_np(:,highremaps_ctl)=NaN;
S3S4_np(:,highremaps_ctl)=NaN;
S4S5_np(:,highremaps_ctl)=NaN;

%% Right hemisphere lesions - calculate remapping
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
norm_s2_s1_freq_right=allswap_pairwise;

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
norm_s3_s2_freq_right=allswap_pairwise;
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
norm_s4_s3_freq_right=allswap_pairwise;

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
norm_s5_s4_freq_right=allswap_pairwise;



all_sums_s1s2_right=yeonetwork_remaps(norm_s2_s1_freq_right, curr_dir);
all_sums_s2s3_right=yeonetwork_remaps(norm_s3_s2_freq_right, curr_dir);
all_sums_s3s4_right=yeonetwork_remaps(norm_s4_s3_freq_right, curr_dir);
all_sums_s4s5_right=yeonetwork_remaps(norm_s5_s4_freq_right, curr_dir);

%% left lesions
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
norm_s2_s1_freq_left=allswap_pairwise;

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
norm_s3_s2_freq_left=allswap_pairwise;
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
norm_s4_s3_freq_left=allswap_pairwise;

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
norm_s5_s4_freq_left=allswap_pairwise;


all_sums_s1s2_left=yeonetwork_remaps(norm_s2_s1_freq_left, curr_dir);
all_sums_s2s3_left=yeonetwork_remaps(norm_s3_s2_freq_left, curr_dir);
all_sums_s3s4_left=yeonetwork_remaps(norm_s4_s3_freq_left, curr_dir);
all_sums_s4s5_left=yeonetwork_remaps(norm_s5_s4_freq_left, curr_dir);


%% combine Left and Right into "Contralesional" versus "Ipsilesional"

% all_sums order - 16x16 grid, 8x8 for each section
%top left: RR
%bottom left: LR
%top right: RL
%bottom right: LL

%S1S2
combined_ii=all_sums_s1s2_left(9:16,9:16)+all_sums_s1s2_right(1:8,1:8);%first row: ipsi-ipsi
combined_cc=all_sums_s1s2_left(1:8,1:8)+all_sums_s1s2_right(9:16,9:16);%second row: contra-contra
combined_ic=all_sums_s1s2_left(9:16,1:8)+all_sums_s1s2_right(1:8,9:16);%third row: ipsi-contra
combined_ci=all_sums_s1s2_left(1:8,9:16)+all_sums_s1s2_right(9:16,1:8);%fourth row: contra-ipsi

combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls1s2=[combined1;combined2];

%S2S3
combined_ii=all_sums_s2s3_left(9:16,9:16)+all_sums_s2s3_right(1:8,1:8);%first row: ipsi-ipsi
combined_cc=all_sums_s2s3_left(1:8,1:8)+all_sums_s2s3_right(9:16,9:16);%second row: contra-contra
combined_ic=all_sums_s2s3_left(9:16,1:8)+all_sums_s2s3_right(1:8,9:16);%third row: ipsi-contra
combined_ci=all_sums_s2s3_left(1:8,9:16)+all_sums_s2s3_right(9:16,1:8);%fourth row: contra-ipsi

combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls2s3=[combined1;combined2];

%S3S4
combined_ii=all_sums_s3s4_left(9:16,9:16)+all_sums_s3s4_right(1:8,1:8);%first row: ipsi-ipsi
combined_cc=all_sums_s3s4_left(1:8,1:8)+all_sums_s3s4_right(9:16,9:16);%second row: contra-contra
combined_ic=all_sums_s3s4_left(9:16,1:8)+all_sums_s3s4_right(1:8,9:16);%third row: ipsi-contra
combined_ci=all_sums_s3s4_left(1:8,9:16)+all_sums_s3s4_right(9:16,1:8);%fourth row: contra-ipsi

combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls3s4=[combined1;combined2];

%S4S5
combined_ii=all_sums_s4s5_left(9:16,9:16)+all_sums_s4s5_right(1:8,1:8);%first row: ipsi-ipsi
combined_cc=all_sums_s4s5_left(1:8,1:8)+all_sums_s4s5_right(9:16,9:16);%second row: contra-contra
combined_ic=all_sums_s4s5_left(9:16,1:8)+all_sums_s4s5_right(1:8,9:16);%third row: ipsi-contra
combined_ci=all_sums_s4s5_left(1:8,9:16)+all_sums_s4s5_right(9:16,1:8);%fourth row: contra-ipsi

combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls4s5=[combined1;combined2];


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
