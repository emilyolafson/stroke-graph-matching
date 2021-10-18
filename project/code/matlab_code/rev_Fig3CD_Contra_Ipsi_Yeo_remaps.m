% Calculate remapping within Yeo networks, splitting remapping into whether
% it occurred in the same or opposite hemisphere as the lesion.
close all;
% right hemisphere lesions (for stroke subjects - 1 = right, 0 = left)
rightlesion = [1,1,0,0,1,0,1,1,1,1,0,0 0,1,1,0,0,1,1,1,1,0,1];

curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/';


%% Right hemisphere lesions - calculate remapping
subjects=[1:23];
rsub=subjects(logical(rightlesion));
size(rsub)
S1S2_npR=remapping_12(rsub,:);
S2S3_npR=remapping_23(rsub,:);
S3S4_npR=remapping_34(rsub,:);
S4S5_npR=remapping_45(rsub,:);

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

S1S2_npL=remapping_12(lsub,:);
S2S3_npL=remapping_23(lsub,:);
S3S4_npL=remapping_34(lsub,:);
S4S5_npL=remapping_45(lsub,:);
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

[all_sums_s1s2_left] =yeonetwork_remaps(norm_s2_s1_freq_left, curr_dir);
[all_sums_s2s3_left]=yeonetwork_remaps(norm_s3_s2_freq_left, curr_dir);
[all_sums_s3s4_left]=yeonetwork_remaps(norm_s4_s3_freq_left, curr_dir);
[all_sums_s4s5_left] =yeonetwork_remaps(norm_s5_s4_freq_left, curr_dir);

%% combine Left and Right into "Contralesional" versus "Ipsilesional"

% all_sums order - 16x16 grid, 8x8 for each section
%top left: RR
%bottom left: LR
%top right: RL
%bottom right: LL
sizenorm=(sizer+sizel)/2;

%S1S2
combined_ii=all_sums_s1s2_left(9:16,9:16)/9+all_sums_s1s2_right(1:8,1:8)/14;%first row: ipsi-ipsi
combined_cc=all_sums_s1s2_left(1:8,1:8)/9+all_sums_s1s2_right(9:16,9:16)/14;%second row: contra-contra
combined_ic=all_sums_s1s2_left(9:16,1:8)/9+all_sums_s1s2_right(1:8,9:16)/14;%third row: ipsi-contra
combined_ci=all_sums_s1s2_left(1:8,9:16)/9+all_sums_s1s2_right(9:16,1:8)/14;%fourth row: contra-ipsi

combined_ii=combined_ii./sizenorm'
combined_cc=combined_cc./sizenorm'
combined_ic=combined_ic./sizenorm'
combined_ci=combined_ci./sizenorm'

cereii(1)=combined_ii(4,4)
cerecc(1)=combined_cc(4,4)
cereci(1)=combined_ci(4,4)
cereic(1)=combined_ic(4,4)

motorii(1)=combined_ii(5,5)
motorcc(1)=combined_cc(5,5)
motorci(1)=combined_ci(5,5)
motoric(1)=combined_ic(5,5)

allii(1)=sum(sum(combined_ii))
allcc(1)=sum(sum(combined_cc))
allci(1)=sum(sum(combined_ci))
allic(1)=sum(sum(combined_ic))

combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls1s2=[combined1;combined2];


%S2S3
combined_ii=all_sums_s2s3_left(9:16,9:16)/9+all_sums_s2s3_right(1:8,1:8)/14;%first row: ipsi-ipsi
combined_cc=all_sums_s2s3_left(1:8,1:8)/9+all_sums_s2s3_right(9:16,9:16)/14;%second row: contra-contra
combined_ic=all_sums_s2s3_left(9:16,1:8)/9+all_sums_s2s3_right(1:8,9:16)/14;%third row: ipsi-contra
combined_ci=all_sums_s2s3_left(1:8,9:16)/9+all_sums_s2s3_right(9:16,1:8)/14;%fourth row: contra-ipsi

combined_ii=combined_ii./sizenorm'
combined_cc=combined_cc./sizenorm'
combined_ic=combined_ic./sizenorm'
combined_ci=combined_ci./sizenorm'


cereii(2)=combined_ii(4,4)
cerecc(2)=combined_cc(4,4)
cereci(2)=combined_ci(4,4)
cereic(2)=combined_ic(4,4)

motorii(2)=combined_ii(5,5)
motorcc(2)=combined_cc(5,5)
motorci(2)=combined_ci(5,5)
motoric(2)=combined_ic(5,5)

allii(2)=sum(sum(combined_ii))
allcc(2)=sum(sum(combined_cc))
allci(2)=sum(sum(combined_ci))
allic(2)=sum(sum(combined_ic))
combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls2s3=[combined1;combined2];

%S3S4
combined_ii=all_sums_s3s4_left(9:16,9:16)/9+all_sums_s3s4_right(1:8,1:8)/14;%first row: ipsi-ipsi
combined_cc=all_sums_s3s4_left(1:8,1:8)/9+all_sums_s3s4_right(9:16,9:16)/14;%second row: contra-contra
combined_ic=all_sums_s3s4_left(9:16,1:8)/9+all_sums_s3s4_right(1:8,9:16)/14;%third row: ipsi-contra
combined_ci=all_sums_s3s4_left(1:8,9:16)/9+all_sums_s3s4_right(9:16,1:8)/14;%fourth row: contra-ipsi


combined_ii=combined_ii./sizenorm'
combined_cc=combined_cc./sizenorm'
combined_ic=combined_ic./sizenorm'
combined_ci=combined_ci./sizenorm'


cereii(3)=combined_ii(4,4)
cerecc(3)=combined_cc(4,4)
cereci(3)=combined_ci(4,4)
cereic(3)=combined_ic(4,4)
motorii(3)=combined_ii(5,5)
motorcc(3)=combined_cc(5,5)
motorci(3)=combined_ci(5,5)
motoric(3)=combined_ic(5,5)

allii(3)=sum(sum(combined_ii))
allcc(3)=sum(sum(combined_cc))
allci(3)=sum(sum(combined_ci))
allic(3)=sum(sum(combined_ic))
combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls3s4=[combined1;combined2];

%S4S5
combined_ii=all_sums_s4s5_left(9:16,9:16)/9+all_sums_s4s5_right(1:8,1:8)/14;%first row: ipsi-ipsi
combined_cc=all_sums_s4s5_left(1:8,1:8)/9+all_sums_s4s5_right(9:16,9:16)/14;%second row: contra-contra
combined_ic=all_sums_s4s5_left(9:16,1:8)/9+all_sums_s4s5_right(1:8,9:16)/14;%third row: ipsi-contra
combined_ci=all_sums_s4s5_left(1:8,9:16)/9+all_sums_s4s5_right(9:16,1:8)/14;%fourth row: contra-ipsi

combined_ii=combined_ii./sizenorm'
combined_cc=combined_cc./sizenorm'
combined_ic=combined_ic./sizenorm'
combined_ci=combined_ci./sizenorm'

cereii(4)=combined_ii(4,4)
cerecc(4)=combined_cc(4,4)
cereci(4)=combined_ci(4,4)
cereic(4)=combined_ic(4,4)
motorii(4)=combined_ii(5,5)
motorcc(4)=combined_cc(5,5)
motorci(4)=combined_ci(5,5)
motoric(4)=combined_ic(5,5)

allii(4)=sum(sum(combined_ii))
allcc(4)=sum(sum(combined_cc))
allci(4)=sum(sum(combined_ci))
allic(4)=sum(sum(combined_ic))
combined1=[combined_ii,combined_ic];
combined2=[combined_ci, combined_cc];
combined_alls4s5=[combined1;combined2];

% possible remaps within a network
countr=sizer;
countl=sizel;


 
 
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
colorbar
%caxis([0 3])
 caxis([0 0.15])
saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/system_remaps_s1s2.png')

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
colorbar
%caxis([0 3])
 caxis([0 0.15])
saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/system_remaps_s2s3.png')

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
colorbar
%caxis([0 3])
 caxis([0 0.15])
saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/system_remaps_s3s4.png')


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
colorbar
 caxis([0 0.15])
saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/system_remaps_s4s5.png')

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
colorbar
 caxis([0 0.15])
saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/system_remaps_mean.png')


% hemispheric differences in remapping?

figure('Position', [0 0 1400 600])
%subcortical cerebellum
tiledlayout(1,3,'padding','none')
nexttile;
% all
plot([allii; allic; allcc; allci]','LineWidth',2)
legend({'ipsi-ipsi', 'ipsi-contra', 'contra-contra', 'contra-ipsi'})
xticks(1:4)
title('All networks')
set(gca,'FontSize', 12)

xticklabels({'1 week-2 weeks', '2 weeks-1 month', '1 month-3 months', '3 months-6 months'})

nexttile
plot([cereii; cereic; cerecc; cereci]','LineWidth',2)
legend({'ipsi-ipsi', 'ipsi-contra', 'contra-contra', 'contra-ipsi'})
xticks(1:4)
title('Subcortical/Cerebellum network')
set(gca,'FontSize', 12)

xticklabels({'1 week-2 weeks', '2 weeks-1 month', '1 month-3 months', '3 months-6 months'})
nexttile;
%motor
plot([motorii; motoric; motorcc; motorci]','LineWidth',2)
legend({'ipsi-ipsi', 'ipsi-contra', 'contra-contra', 'contra-ipsi'})
xticks(1:4)
xticklabels({'1 week-2 weeks', '2 weeks-1month', '1 month-3 months', '3 months-6 months'})
title('Motor network')
set(gca,'FontSize', 12)
saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/ipsi_contra_motor_cerebellum.png')



