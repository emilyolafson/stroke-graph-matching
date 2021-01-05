% load remapping indices (row = subject, columns = original node, element
% in cells = which node the original node was mapped to. starts at 0
% because python indexing starts at 0.

curr_dir=pwd;

results_dir=strcat(curr_dir, '/results/jupyter/precision/stroke/');
info=dir(results_dir);

S1S2_np=load(strcat(results_dir, 'cols_S1S2.txt'));
S2S3_np=load(strcat(results_dir, 'cols_S2S3.txt'));
S3S4_np=load(strcat(results_dir, 'cols_S3S4.txt'));
S4S5_np=load(strcat(results_dir, 'cols_S4S5.txt'));

S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];


%% Get remapping matrices (1/0)
order=0:267;

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

% display remappings across time for all subjects
figure(2);
tiledlayout(1,4)
nexttile;
imagesc(remappings_12)
title('S1-S2')
ylabel('subject')
xlabel('Node')
set(gca, 'FontSize', 20)

nexttile;
remappings_23(20,:)=0.5;
imagesc(remappings_23)
title('S2-S3')
ylabel('subject')
xlabel('Node')
set(gca, 'FontSize', 20)

nexttile;
remappings_34(12,:)=0.5;
remappings_34(20,:)=0.5;
imagesc(remappings_34)
title('S3-S4')
ylabel('subject')
xlabel('Node')
set(gca, 'FontSize', 20)

nexttile;
remappings_45(6,:)=0.5;
remappings_45(12,:)=0.5;
remappings_45(20,:)=0.5;
imagesc(remappings_45)
title('S4-S5')
ylabel('subject')
xlabel('Node')
colorbar('Ticks', [0 0.5 1], 'TickLabels', {'Same node', 'No data', 'Different node'})
set(gcf,'Position',[0 0 2500 700])
set(gca, 'FontSize', 20)

saveas(gcf, strcat(results_dir, 'figures/remapping_raster_allsubjects_overtime.png'))


%% Correlate remap frequency with chaco scores.
%log(chaco) vs remapping - can you make the points three colors indicating cerebellum
% motor/premotor/somatosensory and other cortex?

S1S2_np=load(strcat(results_dir, 'roichanges_S1S2.txt'));
S2S3_np=load(strcat(results_dir, 'roichanges_S2S3.txt'));
S3S4_np=load(strcat(results_dir, 'roichanges_S3S4.txt'));
S4S5_np=load(strcat(results_dir, 'roichanges_S4S5.txt'));

clear chacovol

for i=1:23
    chacovol{i}=load(strcat(curr_dir,'/chaco/SUB', num2str(i), '_lesion_1mmMNI_shen268_mean_chacovol.csv'))
end

mean_chacovol=mean(cell2mat(chacovol'));

[rho,p]=corr(S1S2_np,mean_chacovol');
rho1=rho;
p1=p;
[rho,p]=corr(S2S3_np,mean_chacovol');
rho2=rho;
p2=p;
[rho,p]=corr(S3S4_np,mean_chacovol');
rho3=rho;
p3=p;
[rho,p]=corr(S4S5_np,mean_chacovol');
rho4=rho;
p4=p;

results.corr_w_chaco={{'s1-s2', 's2-s3', 's3-s4', 's4-s5'};[rho1,rho2,rho3,rho4];[p1,p2,p3,p4]};

figure('Position', [0 0 1000 500]) 

tiledlayout(1,4,'padding', 'none')
nexttile;
plot(S1S2_np,mean_chacovol, 'o')
xlabel('Remap frequency')
ylabel('Mean ChaCo')
title('S1-S2')
ylim([0 0.02])
b=polyfit(S1S2_np, mean_chacovol,1);
a=polyval(b,S1S2_np);
hold on;
plot(S1S2_np, a, '-b')
set(gca, 'FontSize', 13)

nexttile;
plot(S2S3_np,mean_chacovol, 'o')
xlabel('Remap frequency')
ylabel('Mean ChaCo')
title('S2-S3')
ylim([0 0.02])
b=polyfit(S2S3_np, mean_chacovol,1);
a=polyval(b,S2S3_np);
hold on;
plot(S2S3_np, a, '-b')
set(gca, 'FontSize', 13)

nexttile;
plot(S3S4_np,mean_chacovol, 'o')
xlabel('Remap frequency')
ylabel('Mean ChaCo')
title('S3-S4')
ylim([0 0.02])
b=polyfit(S3S4_np, mean_chacovol,1);
a=polyval(b,S3S4_np);
hold on;
plot(S3S4_np, a, '-b')
set(gca, 'FontSize', 13)

nexttile;
plot(S4S5_np,mean_chacovol, 'o')
xlabel('Remap frequency')
ylabel('Mean ChaCo score')
title('S4-S5')
ylim([0 0.02])
b=polyfit(S4S5_np, mean_chacovol,1);
a=polyval(b,S4S5_np);
hold on;
plot(S4S5_np, a, '-b')
set(gca, 'FontSize', 13)

saveas(gcf, strcat(results_dir, 'figures/corr_remapping_chaco.png'))


%%
% Mean ChaCo vs. mean remaps
figure('Position', [0 0 700 700])
all=S4S5_np+S3S4_np+S2S3_np+S1S2_np;
all_remaps=mean([remappings_12;remappings_23;remappings_34;remappings_45]);

[rho1,p1]=corr(all_remaps', mean_chacovol', 'Type', 'Spearman');
[rho2,p2]=corr(all_remaps', mean_chacovol', 'Type', 'Pearson');

results.corr_w_chaco_allsessions={{'spearman','pearson'};[rho1,rho2];[p1,p2]};

plot(all_remaps,mean_chacovol, 'ok')
b=polyfit(all_remaps, mean_chacovol,1);
a=polyval(b,all_remaps);
hold on;
title('Remap frequency, averaged over all sessions vs. mean log(chaco) across subjects')
xlabel('Average remap freq. across time points')
ylabel('Mean log(ChaCo) score across subjects')
set(gca, 'FontSize', 13)
saveas(gcf, strcat(results_dir, 'figures/corr_remapping_chaco_allsessions.png'))

figure('Position', [0 0 700 700])
plot(all_remaps, log(mean_chacovol),'ok');
xlabel('Average remap freq. across time points')
ylabel('Mean log(ChaCo) score across subjects')
set(gca,'FontSize', 13)
saveas(gcf, strcat(results_dir, 'figures/corr_remapping_chaco_allsessions_log.png'))


%% remapping vs motor recovery
data_dir=strcat(pwd, '/data/')
fuglmeyer=readtable(strcat(data_dir, 'fuglmeyer_allpts.csv'))
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

chacocol=cell2mat(chacovol');

sum12=sum(remappings_12,2);
sum23=sum(remappings_23,2);
sum34=sum(remappings_34,2);
sum45=sum(remappings_45,2);

sum23(20)=NaN;
sum34(12)=NaN;
sum34(20)=NaN;
sum45(20)=NaN;
sum45(12)=NaN;
sum45(6)=NaN;

sum_all_swaps=[sum12, sum23, sum34, sum45];
totalswap=sum(sum_all_swaps,2);

% baseline impairment vs. sum of swaps 1 to 2.
figure('Position', [0 0 700 700])
plot(sum12(1:21), fm_1(1:21), 'ko')
hold on;
b=polyfit(sum12(1:21), fm_1(1:21),1);
a=polyval(b,sum12(1:21));
plot(sum12(1:21), a, '-r')
[rho,p]=corr(sum12(1:21),fm_1(1:21), 'Type', 'Pearson')
title('Baseline Fugl-Meyer scores vs. Total n remaps S2-S1')
xlabel('Total # swaps')
ylabel('Baseline F-M score')
ylim([0 105])
set(gca, 'FontSize', 13)
results.baselineFM_remaps_s1s2={{'rho', 'p'};[rho,p]};
saveas(gcf, strcat(results_dir, 'figures/baselineFM_remaps_s1s2.png'))

% 6 month recovery recovery vs S1-S2 swaps.
figure('Position', [0 0 700 700])
plot(sum12, fm_5-fm_1,'ko')
[rho,p]=corr(sum12,fm_5-fm_1,'rows', 'complete')
hold on;
recovery=fm_5-fm_1;
idx = isnan(recovery);
b=polyfit(sum12(~idx), recovery(~idx),1);
a=polyval(b,sum12);
plot(sum12, a, '-r')
xlabel('Total # swaps S1-S2')
ylabel('Change in Fugl-Meyer (last baseline-followup)')
title('Baseline # swaps vs. 6 month difference in FM')
set(gca, 'FontSize', 13)
results.baselineswaps_6monthFM={{'rho', 'p'};[rho,p]};
saveas(gcf, strcat(results_dir, 'figures/baselineswaps_6monthFM.png'))

%%
% What we want to test is whether the number of swaps from Session k to Session k+1
% is correlated with the change in motor scores.
figure('Position', [0 0 700 700])
imagesc([fm_1,fm_2,fm_3,fm_4,fm_5])
yticks(1:23)
xticks([1 2 3 4 5])
set(gca,'FontSize', 13)
title('FM scores over time')
xlabel('Session')
saveas(gcf, strcat(results_dir, 'figures/FM_overtime.png'))

fm12=(fm_2-fm_1);
fm23=(fm_3-fm_2);
fm34=(fm_4-fm_3);
fm45=(fm_5-fm_4);

% all inter-scan changes in FM and # remaps
allrecover=[fm12;fm23;fm34;fm45];
allsum=[sum12;sum23;sum34;sum45];

sex=[0;1;1;1;1;0;1;1;1;1;1;0;1;1;0;0;1;1;0;0;1;1;0];
age=[54;57;59;48;63;34;60;61;56;68;62;74;55;54;73;62;60;56;64;55;42;40;56];
lesionvol=load(strcat(data_dir, 'allpts_lesionvol.txt'))
lesionvol=lesionvol(:,1);
lesion_all=[lesionvol;lesionvol;lesionvol;lesionvol];
sex_all=[sex;sex;sex;sex];
age_all=[age;age;age;age];

plot(allsum, allrecover,'*')
[rho,p]=corr(allsum, allrecover, 'rows', 'complete', 'Type', 'Spearman')
xlabel('Sum inter-scan remaps')
ylabel('Change FM')
[rho,p]=partialcorr([allsum,allrecover,sex_all,age_all], 'rows', 'complete', 'Type', 'Spearman')

tiledlayout(1,2,'padding', 'none')
nexttile;
imagesc(p)
caxis([0 0.1])
colormap('parula')
colorbar;

nexttile;
imagesc(rho)
colormap('jet')
caxis([-0.5 0.5])
colorbar;

[rho,p]=partialcorr([allsum,allrecover,sex_all,age_all,lesion_all], 'rows', 'complete', 'Type', 'Spearman')



tiledlayout(2,2,'padding', 'none')
nexttile;
plot(sum12, fm12,'*')
[rho,p]=corr(sum12,fm12, 'rows', 'complete', 'Type', 'Pearson')
hold on;
idx=isnan(fm12);
b=polyfit(sum12(~idx), fm12(~idx),1);
a=polyval(b,sum12);
plot(sum12, a, '-r')
title('S1-S2 recovery (FM2-FM1) vs. sum of remapps S1-S2')
xlabel('Sum of remaps')
ylabel('Change in FM score (followup - baseline')
text(60, -20, ['rho=', num2str(round(rho,3)), ', p=', num2str(round(p,3))], 'FontSize', 20)
ylim([-40 80])
xlim([0 150])
set(gca,'FontSize', 20)

nexttile;
plot(sum23, fm23,'*')
[rho,p]=corr(sum23,fm23, 'rows', 'complete', 'Type', 'Pearson')
hold on;
idx=isnan(fm23);
b=polyfit(sum23(~idx), fm23(~idx),1);
a=polyval(b,sum23);
plot(sum23, a, '-r')
title('S2-S3 recovery (FM3-FM2) vs. sum of remapps S2-S3')
xlabel('Sum of remaps')
ylabel('Change in FM score (followup - baseline')
text(70, 0, ['rho=', num2str(round(rho,3)), ', p=', num2str(round(p,3))], 'FontSize', 20)
ylim([-40 80])
xlim([0 150])
set(gca,'FontSize', 20)

nexttile;
plot(sum34, fm34,'*')
[rho,p]=corr(sum34,fm34, 'rows', 'complete', 'Type', 'Pearson')
hold on;
idx=isnan(fm34);
b=polyfit(sum34(~idx), fm34(~idx),1);
a=polyval(b,sum34);
plot(sum34, a, '-r')
title('S3-S4 recovery (FM4-FM3) vs. sum of remapps S3-S4')
xlabel('Sum of remaps')
ylabel('Change in FM score (followup - baseline')
text(90, 5, ['rho=', num2str(round(rho,3)), ', p=', num2str(round(p,3))], 'FontSize', 20)
ylim([-40 80])
xlim([0 150])
set(gca,'FontSize', 20)

nexttile
plot(sum45, fm45,'*')
[rho,p]=corr(sum45,fm45, 'rows', 'complete', 'Type', 'Pearson')
hold on;
idx=isnan(fm45);
b=polyfit(sum45(~idx), fm45(~idx),1);
a=polyval(b,sum45);
plot(sum45, a, '-r')
title('S4-S5 recovery (FM5-FM4) vs. sum of remapps S4-S5')
xlabel('Sum of remaps')
ylabel('Change in FM score (followup - baseline')
text(100, 2, ['rho=', num2str(round(rho,3)), ', p=', num2str(round(p,3))], 'FontSize', 20)
ylim([-40 80])
xlim([0 150])
set(gca,'FontSize', 20)

fm15=(fm_5-fm_1)./fm_potential_5
fm15(isinf(fm15))=0;

plot(fm15,totalswap, '*r')

plot(mean_34_remappings,mean(cell2mat(chacovol'),1), 'o')
[rho,p]=corr(mean_34_remappings',mean(cell2mat(chacovol'),1)', 'Type', 'Spearman')
[rho,p]=corr(mean_34_remappings',mean(cell2mat(chacovol'),1)', 'Type', 'Pearson')


raw_recovery=fm_5-fm_1
raw_recovery(6)=fm_4(6)-fm_1(1)
raw_recovery(12)=fm_4(6)-fm_1(1)





fm12(isnan(fm12))=0

plot(fm12)
hold on
plot(fm23)
hold on
plot(fm34)

bar(fm12)

plot(fm12(1:21), sum12_w(1:21),'*r') 
[rho,p]=corr(fm12(1:21), sum12_w(1:21), 'Type', 'Spearman')

plot(fm23(1:21), sum23(1:21),'*r') 
[rho,p]=corr(fm23(1:21), sum23(1:21))

plot([fm_1, fm_2, fm_3, fm_4]')


%% S1 vs controls
ctl=load('/Users/emilyolafson/Documents/Thesis/graph_matching/cols_nopenalty_S1_controls.txt')

for j=1:23
    for i=1:268
        if (ctl(j,i)==order(i))
            remappings(j,i)=0;
        else
            remappings(j,i)=1;
        end
    end
end

figure(1)
imagesc(remappings)
title('S1-control mean FC')
ylabel('subject')
xlabel('Node')

remap_sum_ctl=mean(remappings,1)

%% do nodes remap to less structurally disconnected lesions
%only use the nodes which are remapped in 0.3 of subjects?
clear all;
for i=1:23
    chacovol{i}=load(strcat('/Users/emilyolafson/Documents/Thesis/SUB1_23_data/NeMo_SUB1_23/july13_shen/SUB', num2str(i), '_lesion_1mmMNI_shen268_mean_chacovol.csv'))
end

chacovol=cell2mat(chacovol')

S1S2_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/roichanges_nopenalty_S1S2.txt')
S2S3_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/roichanges_nopenalty_S2S3.txt')
S3S4_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/roichanges_nopenalty_S3S4.txt')
S4S5_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/roichanges_nopenalty_S4S5.txt')

%[idx,d]=sort(S1S2_np)
%highremap12=d(end-134:end)
highremap12=find(S1S2_np>0.3);

%[idx,d]=sort(S2S3_np)
%highremap23=d(end-134:end)
highremap23=find(S2S3_np>0.3);

%[idx,d]=sort(S3S4_np)
%highremap34=d(end-134:end)
highremap34=find(S3S4_np>0.3);

%[idx,d]=sort(S4S5_np)
%highremap45=d(end-134:end)
highremap45=find(S4S5_np>0.3);

%reload 
S1S2_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/cols_nopenalty_S1S2.txt')
S2S3_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/cols_nopenalty_S2S3.txt')
S3S4_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/cols_nopenalty_S3S4.txt')
S4S5_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/cols_nopenalty_S4S5.txt')

S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];

clear source*
clear target*

S1S2_np=S1S2_np+1;
clear diffs1
for i=1:length(highremap12)
   chaco_source=[]
    %find subjects whose node i is remapped.
    c=find(S1S2_np(:,highremap12(i))~=highremap12(i));
    chaco_source=chacovol(c,highremap12(i))
    %find the nodes to which i is remapped in those subjects.
    node=S1S2_np(c,highremap12(i))
    chaco_target=[];
    for j=1:length(node)
        chaco_target=[chaco_target;chacovol(c(j),node(j))]
    end
    source1{i}=mean(chaco_source);
    chaco_source1{i}=chaco_source;
    target1{i}=mean(chaco_target);
    chaco_target1{i}=chaco_target;
    diffs1{i}=chaco_source-chaco_target
end
s1=cell2mat(chaco_source1')
t1=cell2mat(chaco_target1')


S2S3_np=S2S3_np+1;
clear diffs2
for i=1:length(highremap23)
   chaco_source=[]

    %find subjects whose node i is remapped.
    c=find(S2S3_np(:,highremap23(i))~=highremap23(i));
    if ismember(20,c)
        c=setdiff(c,20)
    end
    chaco_source=chacovol(c,highremap23(i))
    %find the nodes to which i is remapped in those subjects.
    node=S2S3_np(c,highremap23(i))
    chaco_target=[];
    for j=1:length(node)
        chaco_target=[chaco_target;chacovol(c(j),node(j))];
    end
    source2{i}=mean(chaco_source);
    chaco_source2{i}=chaco_source;
    target2{i}=mean(chaco_target);
    chaco_target2{i}=chaco_target;
    diffs2{i}=chaco_source-chaco_target

end
s2=cell2mat(chaco_source2')
t2=cell2mat(chaco_target2')
clear diffs3
S3S4_np=S3S4_np+1;
for i=1:length(highremap34)
     chaco_source=[]
    %find subjects whose node i is remapped.
    c=find(S3S4_np(:,highremap34(i))~=highremap34(i));
     if ismember(20,c)
        c=setdiff(c,20)
     end
     if ismember(12,c)
        c=setdiff(c,12)
    end
    chaco_source=chacovol(c,highremap34(i))
    %find the nodes to which i is remapped in those subjects.
    node=S3S4_np(c,highremap34(i))
    chaco_target=[];
    for j=1:length(node)
        chaco_target=[chaco_target;chacovol(c(j),node(j))]
    end
    source3{i}=mean(chaco_source);
    chaco_source3{i}=chaco_source;
    target3{i}=mean(chaco_target);
    chaco_target3{i}=chaco_target;
    diffs3{i}=chaco_source-chaco_target

end
s3=cell2mat(chaco_source3')
t3=cell2mat(chaco_target3')

S4S5_np=S4S5_np+1;
clear diffs4
for i=1:length(highremap45)
    chaco_source=[]
    %find subjects whose node i is remapped.
    c=find(S4S5_np(:,highremap45(i))~=highremap45(i));
     if ismember(20,c)
        c=setdiff(c,20)
     end
     if ismember(12,c)
        c=setdiff(c,12)
     end
     if ismember(6,c)
        c=setdiff(c,6)
     end
    chaco_source=chacovol(c,highremap45(i))
    %find the nodes to which i is remapped in those subjects.
    node=S4S5_np(c,highremap45(i))
    chaco_target=[];
    for j=1:length(node)
        chaco_target=[chaco_target;chacovol(c(j),node(j))];
    end
    source4{i}=mean(chaco_source);
    chaco_source4{i}=chaco_source;
    target4{i}=mean(chaco_target);
    chaco_target4{i}=chaco_target;
    diffs4{i}=chaco_source-chaco_target
end

s4=cell2mat(chaco_source4')
t4=cell2mat(chaco_target4')

s12=length(s1)
s_12=sum(s1>=t1)/s12

s23=length(s2)
s_23=sum(s2>=t2)/s23

s34=length(s3)
s_34=sum(s3>=t3)/s34

s45=length(s4)
s_45=sum(s4>=t4)/s45

source1=cell2mat(source1')
target1=cell2mat(target1')
source2=cell2mat(source2')
target2=cell2mat(target2')
source3=cell2mat(source3')
target3=cell2mat(target3')
source4=cell2mat(source4')
target4=cell2mat(target4')

diffs_1=cell2mat(diffs1');
diffs_2=cell2mat(diffs2');
diffs_3=cell2mat(diffs3');
diffs_4=cell2mat(diffs4');

sc=[source1;source2;source3;source4]
tg=[target1;target2;target3;target4]

violinplot([log(sc), log(tg)])
plot([log(sc), log(tg)]')
hLeg = legend('example')
set(hLeg,'visible','off')
[h,p,ci]=ttest(sc,tg)


[h,p,ci]=ttest(s1,t1)
[h,p,ci]=ttest(s2,t2)
[h,p,ci]=ttest(s3,t3)
[h,p,ci]=ttest(s4,t4)

figure(2)
tiledlayout(2,2,'padding', 'none')
nexttile;
violinplot([s1, t1])
plot([s1, t1]')
nexttile;
violinplot([s2, t2])
plot([s2, t2]')
nexttile;
violinplot([s3, t3])
plot([s3, t3]')
nexttile;
violinplot([s4, t4])
plot([s4, t4]')

plot([s4, t4]')

figure(3)
tiledlayout(2,2,'padding', 'none')
nexttile;
histogram(diffs_1, 10000)
xlim([-0.1 0.1])
nexttile;
histogram(diffs_2, 20000)
xlim([-0.1 0.1])
nexttile;
histogram(diffs_3, 30000)
xlim([-0.1 0.1])
nexttile;
histogram(diffs_4, 20000)
xlim([-0.1 0.1])

for j=1:23
    nremappings=sum(remappings_12(j,:))
    chaco=chacovol{j}
    c=find(remappings_12(j,:))
    source_nodes{j}=chaco(c)
    cc=chaco(c)
    d=S1S2_np(j,find(remappings_12(j,:)));
    target_nodes{j}=chaco(S1S2_np(j,find(remappings_12(j,:))))
    dc=chaco(d)
end


dc-cc

plot(cc,dc)
clear diff
for i=1:23
    diff{i}=source_nodes{i}-target_nodes{i}
end

mean(source_nodes{2})
mean(target_nodes{2})

tiledlayout(4,5,'padding', 'none')
for i=1:23
    nexttile;
    histogram(diff{i},length(diff{i}))
end


%% dice overlap between the vector of remaps for the same person between 4 pairs of time points.
% 2) the frequency of the pairwise remap matrix over the 4 pairs of time points
S1S2_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/cols_nopenalty_S1S2.txt')
S2S3_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/cols_nopenalty_S2S3.txt')
S3S4_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/cols_nopenalty_S3S4.txt')
S4S5_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/cols_nopenalty_S4S5.txt')

S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];



for i=1:23
    test=[S1S2_np(i,:)',S2S3_np(i,:)',S3S4_np(i,:)',S4S5_np(i,:)']
    test2=corr(S2S3_np(i,:)',S3S4_np(i,:)')
    test3=corr(S1S2_np(i,:)',S3S4_np(i,:)')
end

order=0:267;

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

s1s2=S1S2_np.*remappings_12;
s2s3=S2S3_np.*remappings_23;
s3s4=S3S4_np.*remappings_34;
s4s5=S4S5_np.*remappings_45;

tiledlayout(1,4,'padding','none')
for i=21:23
    nexttile;
    test=[s1s2(i,:)',s2s3(i,:)',s3s4(i,:)',s4s5(i,:)']
    imagesc(test')
    title(['SUB', num2str(i)])
    colormap(jet)
end
