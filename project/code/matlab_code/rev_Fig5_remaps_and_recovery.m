
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
length1=length(:,1);
length2=length(:,2);
length3=length(:,3);
length4=length(:,4);
length5=length(:,5);


%% lesion volume
lesionvol=load('allpts_lesionvol.txt')
les_vol=lesionvol(:,2);

%% Correlation between baseline impairment vs. sum of remaps 1-2 weeks post-stroke.
figure('Position', [0 0 500 500])
scatter(sum12(1:21), fm_1(1:21), 'ko', 'filled')
hold on;
b=polyfit(sum12(1:21), fm_1(1:21),1);
a=polyval(b,sum12(1:21));
plot(sum12(1:21), a, '-r')
[rho,p]=partialcorr(sum12(1:21),fm_1(1:21),[length1(1:21), length2(1:21)],'Type', 'Pearson', 'rows', 'complete')

title({'Baseline Fugl-Meyer scores vs.' ,'sum of remaps S2-S1'})
xlabel('Total # remaps')
ylabel('Baseline F-M score')

text(5, 90, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
text(5, 84, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
set(gca, 'FontSize', 20)
results.baselineFM_remaps_s1s2.p=p;
results.baselineFM_remaps_s1s2.rho=rho;
saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/rev_Fig5_BaselineFM_remaps.png')

%% 6 month recovery recovery vs remaps 1-2 weeks post-stroke.
figure('Position', [0 0 500 500])
scatter(sum12, fm_5-fm_1,'ko', 'filled')
[rho,p]=partialcorr(sum12(1:21),fm_5(1:21)-fm_1(1:21),[length1(1:21), length5(1:21)],'Type', 'Pearson','rows', 'complete')
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
saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/rev_Fig5_6month_recovery_remaps.png')

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
[rho(1),p(1)]=partialcorr(sum12,fm12,[length1, length2], 'rows', 'complete', 'Type', 'Pearson')
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
text(10, 60, {['Corr:', num2str(round(rho(1),3))], ['p: ', num2str(round(p(1),3))]}, 'FontSize', 15)
ylim([-40 80])
%xlim([0 150])
set(gca,'FontSize', 13)

nexttile;
scatter(sum23, fm23,'ko', 'filled')
[rho(2),p(2)]=partialcorr(sum23,fm23, [length2, length3], 'rows', 'complete', 'Type', 'Pearson')
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
text(10, 60, {['Corr: ', num2str(round(rho(2),3))], ['p: ', num2str(round(p(2),3))]}, 'FontSize', 15)
ylim([-40 80])
%xlim([0 150])
set(gca,'FontSize', 13)

nexttile;
scatter(sum34, fm34,'ko', 'filled')
[rho(3),p(3)]=partialcorr(sum34,fm34,[length3, length4, lesionvol], 'rows', 'complete', 'Type', 'Pearson')
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
text(10, 60, {['Corr: ', num2str(round(rho(3),3))], ['p: ', num2str(round(p(3),3))]}, 'FontSize', 15)
ylim([-40 80])
%xlim([0 150])
set(gca,'FontSize', 13)

nexttile
scatter(sum45, fm45,'ko', 'filled')
[rho(4),p(4)]=partialcorr(sum45,fm45, [length4, length5, lesionvol],'rows', 'complete', 'Type', 'Pearson')
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
text(10, 60, {['Corr: ', num2str(round(rho(4),3))], ['p: ', num2str(round(p(4),3))]}, 'FontSize', 15)
ylim([-40 80])
%xlim([0 150])
set(gca,'FontSize', 13)

[pvals,c,d,adj_p]=fdr_bh(p, 0.05,'pdep')
saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/rev_Fig5_between_scan.png')


%% linear mixed effects model.

tbl=readtable(strcat(curr_dir, '/data/graphmatching_LME_aug23_sl.csv'))

lme = fitlme(tbl,'changeFM ~ remapping  + sex + age +  SL1+ SL2 + lesionvolume + (1|subject)')

figure('Position', [0 0 1400 700])

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

saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/rev_Fig5_LME.png')

