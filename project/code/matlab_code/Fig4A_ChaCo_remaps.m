% Correlation between ChaCo scores and remap frequencies
close all;
clear all;
alpha=0
beta=1
threshold=1

curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/'

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

remaps_cast=sum(remappings_12);

%% 28andme
data_dir=strcat(curr_dir, 'data/28andme/results/regularized/')
a=readmatrix('/Users/emilyolafson/GIT/stroke-graph-matching/project/shen_268_parcellation_networklabels.csv')
c=a(:,2);
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
remaps28=sum(remappings_12)

%% combine all remaps from 28andme and cast dataset

remapsall=remaps28+remaps_cast;
highremaps_ctl=remapsall>=threshold % cutoff for # of cast windows in which node is remapped

%% load stroke data
data_dir=strcat(curr_dir, '/project/results/precision/');

% load remapping indices (row = subject, columns = original node, element
% in cells = which node the original node was mapped to. starts at 0
% because python indexing starts at 0.
S1S2_np=load(strcat(data_dir, 'roichanges_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S2S3_np=load(strcat(data_dir, 'roichanges_S2S3_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S3S4_np=load(strcat(data_dir, 'roichanges_S3S4_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S4S5_np=load(strcat(data_dir, 'roichanges_S4S5_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.

%% Correlate remap frequency with chaco scores.
%log(chaco) vs remapping 
close all;
clear chacovol

for i=1:23
    chacovol{i}=load(strcat(curr_dir, 'data/chaco/SUB', num2str(i), '_lesion_1mmMNI_shen268_mean_chacovol.csv'));
end

mean_chacovol=mean(cell2mat(chacovol'));

idx=isnan(S1S2_np);

[pval, corr_obs, crit_corr, est_alpha, seed_state] = mult_comp_perm_corr([S1S2_np(~idx), S2S3_np(~idx), S3S4_np(~idx), S4S5_np(~idx)],[mean_chacovol(~idx)', mean_chacovol(~idx)', mean_chacovol(~idx)', mean_chacovol(~idx)'], 1000)

rho1=corr_obs(1);
p(1)=pval(1);

rho2=corr_obs(2);
p(2)=pval(2);

rho3=corr_obs(3);
p(3)=pval(3);

rho4=corr_obs(4);
p(4)=pval(4); 

[issig, ~,~,p_adj]=fdr_bh(p,0.05);

results.corr_w_chaco.s1s2.p=p_adj(1)
results.corr_w_chaco.s1s2.rho=rho1
results.corr_w_chaco.s2s3.p=p_adj(2)
results.corr_w_chaco.s2s3.rho=rho2
results.corr_w_chaco.s3s4.p=p_adj(3)
results.corr_w_chaco.s3s4.rho=rho3
results.corr_w_chaco.s4s5.p=p_adj(4)
results.corr_w_chaco.s4s5.rho=rho4

% load shen 268 network annotation
a=readmatrix('/Users/emilyolafson/GIT/stroke-graph-matching/project/shen_268_parcellation_networklabels.csv')
c=a(:,2);
colrs=jet(8);
colrs=[colrs(5:8,:); colrs(1:4,:)]
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});

figure('Position', [0 0 500 500]) 
tiledlayout(2,2,'padding', 'none')
nexttile;

for i=1:8
    idx=c==i;
    scatter(S1S2_np(idx),log(mean_chacovol(idx)), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
    hold on;
end

xlabel('Remap frequency')
ylabel('log(mean ChaCo)')
title('S1-S2')
ylim([-14, 0])
yticks([-14  -10 -6 -2 ])
yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s1s2.rho, 3))],['p < 0.001']}, 'FontSize', 15)
idz=isnan(S1S2_np);
b=polyfit(S1S2_np(~idz), log(mean_chacovol(~idz)),1);
a=polyval(b,S1S2_np(~idz));
hold on;
plot(S1S2_np(~idz), a, '-r')
set(gca, 'FontSize', 15)

nexttile;
for i=1:8
    idx=c==i;
    scatter(S2S3_np(idx),log(mean_chacovol(idx)), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
    hold on;
end
xlabel('Remap frequency')
ylabel('log(mean ChaCo)')
title('S2-S3')
text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s2s3.rho, 3))],['p < 0.001']}, 'FontSize', 15)

yticks([-14  -10 -6 -2 ])
yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
ylim([-14, 0])

b=polyfit(S2S3_np(~idz), log(mean_chacovol(~idz)),1);
a=polyval(b,S2S3_np(~idz));
hold on;
plot(S2S3_np(~idz), a, '-r')
set(gca, 'FontSize', 15)

nexttile;
for i=1:8
    idx=c==i;
    scatter(S3S4_np(idx),log(mean_chacovol(idx)), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
    hold on;
end
xlabel('Remap frequency')
ylabel('log(mean ChaCo)')
title('S3-S4')
ylim([-14, 0])
%xlim([0 0.7])
yticks([-14  -10 -6 -2 ])
yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s3s4.rho, 3))],['p < 0.001']}, 'FontSize', 15)
b=polyfit(S3S4_np(~idz), log(mean_chacovol(~idz)),1);
a=polyval(b,S3S4_np(~idz));
hold on;
plot(S3S4_np(~idz), a, '-r')
set(gca, 'FontSize', 15)

nexttile;
for i=1:8
    idx=c==i;
    scatter(S4S5_np(idx),log(mean_chacovol(idx)), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
    hold on;
end
xlabel('Remap frequency')
ylabel('log(mean ChaCo)')
yticks([-14  -10 -6 -2 ])
yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
title('S4-S5')
ylim([-14, 0])
%xlim([0 0.7])
text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s4s5.rho, 3))],['p < 0.001']}, 'FontSize', 15)
b=polyfit(S4S5_np(~idz), log(mean_chacovol(~idz)),1);
a=polyval(b,S4S5_np(~idz));
hold on;
plot(S4S5_np(~idz), a, '-r')
set(gca, 'FontSize', 15)

%% legend

legend(yeolabels)
