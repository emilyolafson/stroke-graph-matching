% Plot relationships between  
clear all;
close all;

alpha=0
beta=1
threshold=1

curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/'

%load cast data in order to find indices that remap
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
remapsall=remaps28+remaps_cast
highremaps_ctl=remapsall>=threshold % cutoff for # of windows in which node is remapped in controls

%% load stroke data
data_dir=strcat(curr_dir, '/project/results/precision/');

% load remapping indices (row = subject, columns = original node, element
% in cells = which node the original node was mapped to. starts at 0
% because python indexing starts at 0.
S1S2_np=load(strcat(data_dir, 'cols_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S2S3_np=load(strcat(data_dir, 'cols_S2S3_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S3S4_np=load(strcat(data_dir, 'cols_S3S4_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S4S5_np=load(strcat(data_dir, 'cols_S4S5_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];

S1S2_np(highremaps_ctl)=NaN
S2S3_np(highremaps_ctl)=NaN
S3S4_np(highremaps_ctl)=NaN
S4S5_np(highremaps_ctl)=NaN

%% Get remapping matrices (1/0)
order=0:267; 
remappings_12=[]
remappings_23=[]
remappings_34=[];
remappings_45=[];
for j=1:23
    for i=1:268
        if (S1S2_np(j,i)==order(i))
            remappings_12(j,i)=0;
        else
            remappings_12(j,i)=1;
        end
         if (S2S3_np(j,i)==order(i))
            remappings_23(j,i)=0;
        else
            remappings_23(j,i)=1;
         end
         if (S3S4_np(j,i)==order(i))
            remappings_34(j,i)=0;
         else
            remappings_34(j,i)=1;
         end
         if (S4S5_np(j,i)==order(i))
            remappings_45(j,i)=0;
        else
            remappings_45(j,i)=1;
        end
    end
end

remappings_12(:,highremaps_ctl)=NaN
remappings_23(:,highremaps_ctl)=NaN
remappings_34(:,highremaps_ctl)=NaN
remappings_45(:,highremaps_ctl)=NaN

%% Load Fugl-Meyer scores
fm_dir=strcat(curr_dir, 'data/');
fuglmeyer=readtable(strcat(fm_dir, 'fuglmeyer_allpts.csv'));
fm_1=fuglmeyer.Var2;
fm_2=fuglmeyer.Var3;
fm_3=fuglmeyer.Var4;
fm_4=fuglmeyer.Var5;
fm_5=fuglmeyer.Var6;

fm_1(23)=NaN;
fm_1(22)=NaN;
fm_3(20)=NaN;
fm_4(12)=NaN;
fm_4(20)=NaN;
fm_5(20)=NaN;
fm_5(6)=NaN;

%% Calculate remap frequencies
sum12=sum(remappings_12,2, 'omitnan');
sum23=sum(remappings_23,2, 'omitnan');
sum34=sum(remappings_34,2, 'omitnan');
sum45=sum(remappings_45,2, 'omitnan');

sum23(20)=NaN;
sum34(12)=NaN;
sum34(20)=NaN;
sum45(20)=NaN;
sum45(12)=NaN;
sum45(6)=NaN;

%% Scan length
length=load(strcat(curr_dir, 'data/lengthts.mat'))
length=length.length_ts;

length(6, 5) =NaN
length(12,4)=NaN
length(12,5)=NaN
length(20,4)=NaN
length(20,3)=NaN
length(20,5)=NaN

length12=mean([length(:,1),length(:,2)],2);
length23=mean([length(:,2),length(:,3)],2);
length34=mean([length(:,3),length(:,4)],2);
length45=mean([length(:,4),length(:,5)],2);


%% Correlation between baseline impairment vs. sum of remaps 1-2 weeks post-stroke.
figure('Position', [0 0 500 500])
scatter(sum12(1:21), fm_1(1:21), 'ko', 'filled')
hold on;
b=polyfit(sum12(1:21), fm_1(1:21),1);
a=polyval(b,sum12(1:21));
plot(sum12(1:21), a, '-r')
[rho,p]=partialcorr(sum12(1:21),fm_1(1:21),length12(1:21), 'Type', 'Pearson', 'rows', 'complete')

title({'Baseline Fugl-Meyer scores vs.' ,'sum of remaps S2-S1'})
xlabel('Total # remaps')
ylabel('Baseline F-M score')

text(5, 90, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
text(5, 84, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
set(gca, 'FontSize', 20)
results.baselineFM_remaps_s1s2.p=p;
results.baselineFM_remaps_s1s2.rho=rho;

%% 6 month recovery recovery vs remaps 1-2 weeks post-stroke.
figure('Position', [0 0 500 500])
scatter(sum12, fm_5-fm_1,'ko', 'filled')
[rho,p]=partialcorr(sum12(1:21),fm_5(1:21)-fm_1(1:21),length12(1:21),'Type', 'Spearman','rows', 'complete')
hold on;
recovery=fm_5-fm_1;
idx = isnan(recovery);
b=polyfit(sum12(~idx), recovery(~idx),1);
a=polyval(b,sum12);

plot(sum12, a, '-r')
xlabel('Total # remaps S1-S2')
ylabel('Change in Fugl-Meyer (last baseline-followup)')
title({'Baseline # swaps vs', ' 6 month improvement motor scores'})
set(gca, 'FontSize', 20)
text(2, 90, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
text(2, 84, {['p: ', num2str(round(p, 3))]}, 'FontSize', 20)
results.baselineswaps_6monthFM.p=p;
results.baselineswaps_6monthFM.rho=rho;

%% Calculate change in Fugl-Meyer scores between sessions.
fm12=(fm_2-fm_1);
fm23=(fm_3-fm_2);
fm34=(fm_4-fm_3);
fm45=(fm_5-fm_4);

%% Plot the partial correlation between number of remaps & change in Fugl-Meyer scores
figure('Position', [0 0 800 700])
tiledlayout(2,2, 'padding', 'none')
nexttile;
scatter(sum12, fm12,'ko', 'filled')
[rho(1),p(1)]=partialcorr(sum12,fm12,length12, 'rows', 'complete', 'Type', 'Pearson')
results.corr_recovery_remap_sessionspecific.s1s2.p=p;
results.corr_recovery_remap_sessionspecific.s1s2.rho=rho;
hold on;
idx=isnan(fm12);
b=polyfit(sum12(~idx), fm12(~idx),1);
a=polyval(b,sum12);
plot(sum12, a, '-r')
title({'Change in Fugl-Meyer scores vs sum of remaps',' 1 week - 2 weeks post-stroke'})
xlabel('Sum of remaps')
ylabel('\Delta FM score')
%text(2, -20, {['p. rho: ', num2str(round(rho,3))], ['p: ', num2str(round(p,3))]}, 'FontSize', 15)
ylim([-40 80])
%xlim([0 150])
set(gca,'FontSize', 13)

nexttile;
scatter(sum23, fm23,'ko', 'filled')
[rho(2),p(2)]=partialcorr(sum23,fm23,length23, 'rows', 'complete', 'Type', 'Pearson')
results.corr_recovery_remap_sessionspecific.s2s3.p=p;
results.corr_recovery_remap_sessionspecific.s2s3.rho=rho;
hold on;
idx=isnan(fm23);
b=polyfit(sum23(~idx), fm23(~idx),1);
a=polyval(b,sum23);
plot(sum23, a, '-r')
title({'Change in Fugl-Meyer scores vs sum of remaps','2 weeks - 1 month post-stroke'})
xlabel('Sum of remaps')
ylabel('\Delta FM score')
%text(2, -20, {['p. rho: ', num2str(round(rho,3))], ['p: ', num2str(round(p,3))]}, 'FontSize', 15)
ylim([-40 80])
%xlim([0 150])
set(gca,'FontSize', 13)

nexttile;
scatter(sum34, fm34,'ko', 'filled')
[rho(3),p(3)]=partialcorr(sum34,fm34,length34, 'rows', 'complete', 'Type', 'Pearson')
results.corr_recovery_remap_sessionspecific.s3s4.p=p;
results.corr_recovery_remap_sessionspecific.s3s4.rho=rho;
hold on;
idx=isnan(fm34);
b=polyfit(sum34(~idx), fm34(~idx),1);
a=polyval(b,sum34);
plot(sum34, a, '-r')
title({'Change in Fugl-Meyer scores vs sum of remaps ','1 month - 3 months post-stroke'})
xlabel('Sum of remaps')
ylabel('\Delta FM score')
%text(2, -20, {['p. rho: ', num2str(round(rho,3))], ['p: ', num2str(round(p,3))]}, 'FontSize', 15)
ylim([-40 80])
%xlim([0 150])
set(gca,'FontSize', 13)

nexttile
scatter(sum45, fm45,'ko', 'filled')
[rho(4),p(4)]=partialcorr(sum45,fm45, length45,'rows', 'complete', 'Type', 'Pearson')
results.corr_recovery_remap_sessionspecific.s4s5.p=p;
results.corr_recovery_remap_sessionspecific.s4s5.rho=rho;
hold on;
idx=isnan(fm45);
b=polyfit(sum45(~idx), fm45(~idx),1);
a=polyval(b,sum45);
plot(sum45, a, '-r')
title({'Change in Fugl-Meyer scores vs sum of remaps',' 3 months - 6 months post-stroke'})
xlabel('Sum of remaps')
ylabel('\Delta FM score')
%text(2, -20, {['p. rho: ', num2str(round(rho,3))], ['p: ', num2str(round(p,3))]}, 'FontSize', 15)
ylim([-40 80])
%xlim([0 150])
set(gca,'FontSize', 13)

[pvals,c,d,adj_p]=fdr_bh(p, 0.05,'pdep')

%% linear mixed effects model.
figure('Position', [0 0 1000 700])

tbl=readtable(strcat(curr_dir, 'data/LME_datatable.csv'))

lme = fitlme(tbl,'changeFM ~ remapping  + sex + age + scanlength + (1|subject)')

randomColors = rand(3,23)';
scatter(sum12, fm12, 70,randomColors,'filled')
hold on;
scatter(sum23, fm23, 70,randomColors, 'filled')
hold on;
scatter(sum34, fm34, 70,randomColors, 'filled')
hold on;
scatter(sum45, fm45, 70,randomColors, 'filled')

xlabel('Remaps between sessions')
ylabel('Change in Fugl-Meyer score')
set(gca, 'FontSize', 20)
hold on;
h.Color='r'
