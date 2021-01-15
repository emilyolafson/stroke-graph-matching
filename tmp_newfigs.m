% new figs:
% - single sub remapping correlation with chaco scores
clear all;

curr_dir=pwd;


for i=1:23
    chacovol{i}=load(strcat(curr_dir,'/chaco/SUB', num2str(i), '_lesion_1mmMNI_shen268_mean_chacovol.csv'));
end

mean_chacovol=mean(cell2mat(chacovol'));


data_dir=strcat(curr_dir, '/results/jupyter/precision/stroke/');
alphas = [0, 0.0025, 0.0075, 0.0125];
suffixes = {'alpha0', 'alpha1', 'alpha2', 'alpha3'};

results_dir=strcat(curr_dir, '/results/jupyter/precision/stroke/', suffix, '/');
suffixes_2 = {'beta0', 'beta1', 'beta2', 'beta3'};
suffix = strcat(char(suffixes(d)),'_',char(suffixes_2(q)));

S1S2_np=load(strcat(data_dir, 'cols_S1S2_', suffix, '.txt'));
S2S3_np=load(strcat(data_dir, 'cols_S2S3_', suffix, '.txt'));
S3S4_np=load(strcat(data_dir, 'cols_S3S4_', suffix, '.txt'));
S4S5_np=load(strcat(data_dir, 'cols_S4S5_', suffix, '.txt'));

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
    
%% Get ChaCo score of nodes that remap versus nodes that don't remap for each subject separately

for i=1:23 % across subjects
    subchaco=chacovol{i};
    remaps=remappings_12(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end

clear remap

tiledlayout(5, 5, 'padding', 'none')

for i=1:23
    for k=1:268
        if remappings_12(i,k)==1
            remap{k}='remap';
        else
            remap{k}='no remap';
        end
    end
    nexttile;
    remap=cellstr(remap');
    chaco=chacovol{i}';
    violinplot(chaco, remap)
    ylabel('ChaCo')
    
    [h(i), p(i), ci, stat]=ttest2(chaco_remap{i}, chaco_noremap{i});
    if p(i)< 0.05
        title(['p = ', num2str(p(i)), ', stat = ', num2str(stat.tstat)])
    end
    tstat_12(i)=stat.tstat;

end
saveas(gcf, strcat(results_dir, 'figures/S1S2_sub_specific_remaps_vs_chaco.png'))


for i=1:23 % across subjects
    subchaco=chacovol{i};
    remaps=remappings_23(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end
tiledlayout(5, 5, 'padding', 'none')
for i=1:23
    for k=1:268
        if remappings_23(i,k)==1
            remap{k}='remap';
        else
            remap{k}='no remap';
        end
    end
    if i == 20
        plot(0)
        nexttile;
        continue;
    end
    nexttile;
    remap=cellstr(remap');
    chaco=chacovol{i}';
    violinplot(chaco, remap)
    ylabel('ChaCo')
    
    [h(i), p(i), ~, stat]=ttest2(chaco_remap{i}, chaco_noremap{i});
    if p(i)< 0.05
        title(['p = ', num2str(p(i)), ', stat = ', num2str(stat.tstat)])
    end
    tstat_23(i)=stat.tstat;

end
saveas(gcf, strcat(results_dir, 'figures/S2S3_sub_specific_remaps_vs_chaco.png'))

for i=1:23 % across subjects
    subchaco=chacovol{i};
    remaps=remappings_34(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end
tiledlayout(5, 5, 'padding', 'none')
for i=1:23
    for k=1:268
        if remappings_34(i,k)==1
            remap{k}='remap';
        else
            remap{k}='no remap';
        end
    end
    if i == 20
        plot(0)
        nexttile;
        continue;
    end
    if i == 12
        plot(0)
        nexttile;
        continue;
    end
    nexttile;
    remap=cellstr(remap');
    chaco=chacovol{i}';
    violinplot(chaco, remap)
    ylabel('ChaCo')
    
    [h(i), p(i), ~, stat]=ttest2(chaco_remap{i}, chaco_noremap{i});
    if p(i)< 0.05
        title(['p = ', num2str(p(i)), ', stat = ', num2str(stat.tstat)])
    end
    tstat_34(i)=stat.tstat;

end
saveas(gcf, strcat(results_dir, 'figures/S3S4_sub_specific_remaps_vs_chaco.png'))


for i=1:23 % across subjects
    subchaco=chacovol{i};
    remaps=remappings_45(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end

tiledlayout(5, 5, 'padding', 'none')
for i=1:23
    for k=1:268
        if remappings_45(i,k)==1
            remap{k}='remap';
        else
            remap{k}='no remap';
        end
    end
    if i == 20
        plot(0)
        nexttile;
        continue;
    end
    if i == 12
        plot(0)
        nexttile;
        continue;
    end
    if i == 6
        plot(0)
        nexttile;
        continue;
    end
    nexttile;
    remap=cellstr(remap');
    chaco=chacovol{i}';
    violinplot(chaco, remap)
    ylabel('ChaCo')
    
    [h(i), p(i), ~, stat]=ttest2(chaco_remap{i}, chaco_noremap{i});
    if p(i)< 0.05
        title(['p = ', num2str(p(i)), ', stat = ', num2str(stat.tstat)])
    end
    tstat_45(i)=stat.tstat;
end
saveas(gcf, strcat(results_dir, 'figures/S4S5_sub_specific_remaps_vs_chaco.png'))
close all;
histogram([tstat_45, tstat_34, tstat_23, tstat_12],30)
title('t-statistic distribution - no log-transform')
xlabel('t-statistic (chaco remap - chaco noremap)')
ylabel('Count')
saveas(gcf, strcat(results_dir, 'figures/allsessions_sub_specific_remaps_vs_chaco_tstats.png'))



%% log chaco comparison.

for i=1:23 % across subjects
    subchaco=chacovol{i};
    remaps=remappings_12(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end

clear remap

tiledlayout(5, 5, 'padding', 'none')

for i=1:23
    for k=1:268
        if remappings_12(i,k)==1
            remap{k}='remap';
        else
            remap{k}='no remap';
        end
    end
    nexttile;
    remap=cellstr(remap');
    chaco=chacovol{i}';
    violinplot(log(chaco), remap)
    ylabel('log(ChaCo)')
    
    [h(i), p(i), ~, stat]=ttest2(log(chaco_remap{i}), log(chaco_noremap{i}));
    if p(i)< 0.05
        title(['p = ', num2str(p(i))])
    end
    tstat_12(i)=stat.tstat;

end
saveas(gcf, strcat(results_dir, 'figures/S1S2_sub_specific_remaps_vs_chaco-log.png'))


for i=1:23 % across subjects
    subchaco=chacovol{i};
    remaps=remappings_23(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end
tiledlayout(5, 5, 'padding', 'none')
for i=1:23
    for k=1:268
        if remappings_23(i,k)==1
            remap{k}='remap';
        else
            remap{k}='no remap';
        end
    end
    if i == 20
        plot(0)
        nexttile;
        continue;
    end
    nexttile;
    remap=cellstr(remap');
    chaco=chacovol{i}';
    violinplot(log(chaco), remap)
    ylabel('log(ChaCo)')
    
    [h(i), p(i), ~, stat]=ttest2(log(chaco_remap{i}), log(chaco_noremap{i}));
    if p(i)< 0.05
        title(['p = ', num2str(p(i))])
    end
    tstat_23(i)=stat.tstat;
end
saveas(gcf, strcat(results_dir, 'figures/S2S3_sub_specific_remaps_vs_chaco-log.png'))

for i=1:23 % across subjects
    subchaco=chacovol{i};
    remaps=remappings_34(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end
tiledlayout(5, 5, 'padding', 'none')
for i=1:23
    for k=1:268
        if remappings_34(i,k)==1
            remap{k}='remap';
        else
            remap{k}='no remap';
        end
    end
    if i == 20
        plot(0)
        nexttile;
        continue;
    end
    if i == 12
        plot(0)
        nexttile;
        continue;
    end
    nexttile;
    remap=cellstr(remap');
    chaco=chacovol{i}';
    violinplot(log(chaco), remap)
    ylabel('log(ChaCo)')
    
    [h(i), p(i), ~, stat]=ttest2(log(chaco_remap{i}), log(chaco_noremap{i}));
    if p(i)< 0.05
        title(['p = ', num2str(p(i))])
    end
    tstat_34(i)=stat.tstat;
end
saveas(gcf, strcat(results_dir, 'figures/S3S4_sub_specific_remaps_vs_chaco-log.png'))


for i=1:23 % across subjects
    subchaco=chacovol{i};
    remaps=remappings_45(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end

tiledlayout(5, 5, 'padding', 'none')
for i=1:23
    for k=1:268
        if remappings_45(i,k)==1
            remap{k}='remap';
        else
            remap{k}='no remap';
        end
    end
    if i == 20
        plot(0)
        nexttile;
        continue;
    end
    if i == 12
        plot(0)
        nexttile;
        continue;
    end
    if i == 6
        plot(0)
        nexttile;
        continue;
    end
    nexttile;
    remap=cellstr(remap');
    chaco=chacovol{i}';
    violinplot(log(chaco), remap)
    ylabel('log(ChaCo)')
    
    [h(i), p(i), ~, stat]=ttest2(log(chaco_remap{i}), log(chaco_noremap{i}));
    if p(i)< 0.05
        title(['p = ', num2str(p(i))])
    end
    tstat_34(i)=stat.tstat;
end

saveas(gcf, strcat(results_dir, 'figures/S4S5_sub_specific_remaps_vs_chaco-log.png'))

close all;
histogram([tstat_45, tstat_34, tstat_23, tstat_12],30)
title('t-statistic distribution - log-transform')
xlabel('t-statistic (chaco remap - chaco noremap)')
ylabel('Count')
saveas(gcf, strcat(results_dir, 'figures/allsessions_sub_specific_remaps_vs_chaco_tstats-log.png'))