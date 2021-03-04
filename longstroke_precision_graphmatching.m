% load remapping indices (row = subject, columns = original node, element
% in cells = which node the original node was mapped to. starts at 0
% because python indexing starts at 0.

curr_dir=pwd;

data_dir=strcat(curr_dir, '/results/');
alphas = [0, 0.0025, 0.0075, 0.0125];

% no_alpha, alpha1, alpha2, alpha3

for i=1
 %   suffixes = {'alpha0', 'alpha1', 'alpha2', 'alpha3'};
    suffixes = {'beta0', 'beta1', 'beta2', 'beta3'};

    suffix = char(strcat('alpha0_', suffixes(i)));
    S1S2_np=load(strcat(data_dir, 'cols_S1S2_', suffix, '.txt'));
    S2S3_np=load(strcat(data_dir, 'cols_S2S3_', suffix, '.txt'));
    S3S4_np=load(strcat(data_dir, 'cols_S3S4_', suffix, '.txt'));
    S4S5_np=load(strcat(data_dir, 'cols_S4S5_', suffix, '.txt'));

    S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
    S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
    S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];
    suffix = char(suffixes(i))
    suffixz = char(strcat('alpha0_', suffixes(i)));

    results_dir=strcat(curr_dir, '/project/results/', suffix, '/');

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

    set(gcf,'Position',[0 0 1400 700])
    set(gca, 'FontSize', 20)
    
    sgtitle('Remapping patterns across all subjects & time intervals')

    saveas(gcf, strcat(results_dir, 'figures/remapping_raster_allsubjects_overtime.png'))

    %% Plot remap frequencies on gummibrain

    S1S2_np=load(strcat(data_dir, 'roichanges_S1S2_', suffixz, '.txt'));
    S2S3_np=load(strcat(data_dir, 'roichanges_S2S3_', suffixz, '.txt'));
    S3S4_np=load(strcat(data_dir, 'roichanges_S3S4_', suffixz, '.txt'));
    S4S5_np=load(strcat(data_dir, 'roichanges_S4S5_', suffixz, '.txt'));
    
   % gummi_remapfreq(S1S2_np, results_dir, 'S1-S2_remap_gummibrain')
   % gummi_remapfreq(S2S3_np, results_dir, 'S2-S3_remap_gummibrain')
   % gummi_remapfreq(S3S4_np, results_dir, 'S3-S4_remap_gummibrain')
   % gummi_remapfreq(S4S5_np, results_dir, 'S4-S5_remap_gummibrain')

    %% Correlate remap frequency with chaco scores.
    %log(chaco) vs remapping - can you make the points three colors indicating cerebellum
    % motor/premotor/somatosensory and other cortex?
    close all;
    clear chacovol

    for i=1:23
        chacovol{i}=load(strcat(curr_dir,'/data/chaco/SUB', num2str(i), '_lesion_1mmMNI_shen268_mean_chacovol.csv'));
    end

    mean_chacovol=mean(cell2mat(chacovol'));

    [rho,p]=corr(S1S2_np,log(mean_chacovol'));
    rho1=rho;
    p1=p;
    [rho,p]=corr(S2S3_np,log(mean_chacovol'));
    rho2=rho;
    p2=p;
    [rho,p]=corr(S3S4_np,log(mean_chacovol'));
    rho3=rho;
    p3=p;
    [rho,p]=corr(S4S5_np,log(mean_chacovol'));
    rho4=rho;
    p4=p;

    results.corr_w_chaco.s1s2.p=p1
    results.corr_w_chaco.s1s2.rho=rho1
    results.corr_w_chaco.s2s3.p=p2
    results.corr_w_chaco.s2s3.rho=rho2
    results.corr_w_chaco.s3s4.p=p3
    results.corr_w_chaco.s3s4.rho=rho3
    results.corr_w_chaco.s4s5.p=p4
    results.corr_w_chaco.s4s5.rho=rho4

    figure('Position', [0 0 500 500]) 
    tiledlayout(2,2,'padding', 'none')
    nexttile;
    scatter(S1S2_np,log(mean_chacovol), 'ko', 'filled', 'MarkerFaceAlpha', 0.8)
    xlabel('Remap frequency')
    ylabel('log(mean ChaCo)')
    title('S1-S2')
    ylim([-14, 0])
    xlim([0 0.7])
    yticks([-14  -10 -6 -2 ])
    yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
    text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s1s2.rho, 3))],['p: ', sprintf(' %.2g ', results.corr_w_chaco.s1s2.p)]}, 'FontSize', 15)
    b=polyfit(S1S2_np, log(mean_chacovol),1);
    a=polyval(b,S1S2_np);
    hold on;
    plot(S1S2_np, a, '-r')
    set(gca, 'FontSize', 15)

    nexttile;
    scatter(S2S3_np,log(mean_chacovol), 'ko', 'filled', 'MarkerFaceAlpha', 0.8)
    xlabel('Remap frequency')
    ylabel('log(mean ChaCo)')
    title('S2-S3')
    text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s2s3.rho, 3))],['p: ', sprintf(' %.2g ', results.corr_w_chaco.s2s3.p)]}, 'FontSize', 15)
  
   yticks([-14  -10 -6 -2 ])
    yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
    ylim([-14, 0])
    xlim([0 0.7])
    b=polyfit(S2S3_np, log(mean_chacovol),1);
    a=polyval(b,S2S3_np);
    hold on;
    plot(S2S3_np, a, '-r')
    set(gca, 'FontSize', 15)

    nexttile;
    scatter(S3S4_np,log(mean_chacovol), 'ko', 'filled', 'MarkerFaceAlpha', 0.8)
    xlabel('Remap frequency')
    ylabel('log(mean ChaCo)')
    title('S3-S4')
    ylim([-14, 0])
    xlim([0 0.7])
    yticks([-14  -10 -6 -2 ])
    yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
    text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s3s4.rho, 3))],['p: ',sprintf(' %.2g ', results.corr_w_chaco.s3s4.p)]}, 'FontSize', 15)
    b=polyfit(S3S4_np, log(mean_chacovol),1);
    a=polyval(b,S3S4_np);
    hold on;
    plot(S3S4_np, a, '-r')
    set(gca, 'FontSize', 15)

    nexttile;
    scatter(S4S5_np,log(mean_chacovol), 'ko', 'filled', 'MarkerFaceAlpha', 0.8)
    xlabel('Remap frequency')
    ylabel('log(mean ChaCo)')
    yticks([-14  -10 -6 -2 ])
    yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
    title('S4-S5')
    ylim([-14, 0])
    xlim([0 0.7])
    text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s4s5.rho, 3))],['p: ', sprintf(' %.2g ', results.corr_w_chaco.s4s5.p)]}, 'FontSize', 15)
    idx=isnan(log(mean_chacovol))
    b=polyfit(S4S5_np, log(mean_chacovol),1);
    a=polyval(b,S4S5_np);
    hold on;
    plot(S4S5_np, a, '-r')
    set(gca, 'FontSize', 15)
    
  %  sgtitle('Remap frequency (individual sessions) vs. mean ChaCo across subjects')
    saveas(gcf, strcat(results_dir, 'figures/corr_remapping_chaco.png'))
    saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/apaper/figs/corr_remapping_chaco.png')


    %%
    % Mean ChaCo vs. mean remaps
    all=S4S5_np+S3S4_np+S2S3_np+S1S2_np;
    all_remaps=mean([remappings_12;remappings_23;remappings_34;remappings_45]);

    [rho1,p1]=corr(all_remaps', mean_chacovol', 'Type', 'Pearson');
    [rho2,p2]=corr(all_remaps', mean_chacovol', 'Type', 'Spearman');

    results.corr_w_chaco_allsessions.spearman_p=p1;
    results.corr_w_chaco_allsessions.spearman_rho=rho1;
    results.corr_w_chaco_allsessions.pearson_p=p2;
    results.corr_w_chaco_allsessions.pearson_rho=rho2;
    
    figure('Position', [0 0 500 500])
    scatter(all_remaps,mean_chacovol, 'k', 'filled')
    b=polyfit(all_remaps, mean_chacovol,1);
    a=polyval(b,all_remaps);
    hold on;
    title([{'Remap frequency averaged over all sessions'},{' vs. mean ChaCo across subjects'}])
    xlabel('Average remap freq. across time points')
    ylabel('Mean ChaCo score across subjects')
    set(gca, 'FontSize', 13)
    saveas(gcf, strcat(results_dir, 'figures/corr_remapping_chaco_allsessions.png'))
    saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/apaper/figs/corr_remapping_chaco_allsessions.png')

    figure('Position', [0 0 500 500])
    scatter(all_remaps, log(mean_chacovol),'k', 'filled');
    hold on;
    xlabel('Average remap freq. across time points')
    ylabel('Mean log(ChaCo) score across subjects')
    set(gca,'FontSize', 13)
    title([{'Remap frequency averaged over all sessions'},{' vs. log(mean ChaCo) across subjects'}])
    plot(all_remaps, log(mean_chacovol), 'ok')
    b=polyfit(all_remaps,  log(mean_chacovol),1);
    a=polyval(b,all_remaps);
    plot(all_remaps, a, '-r')

    saveas(gcf, strcat(results_dir, 'figures/corr_remapping_chaco_allsessions_log.png'))
    saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/apaper/figs/corr_remapping_chaco_allsessions_log.png')

    [rho1,p1]=corr(all_remaps', log(mean_chacovol)', 'Type', 'Spearman');
    results.corr_w_chaco_allsessions_log.pearson_p=p1;
    results.corr_w_chaco_allsessions_log.pearson_rho=rho1;
    
 
    
    %% remapping vs motor recovery
    fm_dir=strcat(pwd, '/data/');
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
    totalswap=sum(sum_all_swaps,2)
    
   %% lesion vol. vs remaps
    lesionvol = load('allpts_lesionvol.txt')
    vol=lesionvol(:,1);
    
    figure('Position', [0 0 500 500])
    scatter(sum12, vol, 'ko', 'filled')
    hold on;
    b=polyfit(sum12, vol,1);
    a=polyval(b,sum12);
    plot(sum12, a, '-r')
    [rho,p]=corr(sum12,vol, 'Type', 'Pearson');
    title({'Number of remaps S1-S2 vs.' ,'Lesion volume'})
    xlabel('Total # remaps')
    ylabel('Lesion volume')
    text(10, 250, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
    text(10, 230, {['p: ', sprintf('%.2g',p)]}, 'FontSize', 20)
    set(gca, 'FontSize', 20)
    saveas(gcf, strcat(results_dir, 'figures/lesionvol_remapss1s2.png'))
    saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/apaper/figs/lesionvol_remapss1s2.png')

    
    lesionload=load('CSTlesionload.mat')
    lesionload=lesionload.lesionload
    
    [rho,p]=corr(sum12, cell2mat(lesionload), 'rows','complete')
   
    figure('Position', [0 0 500 500])
    scatter(sum12, cell2mat(lesionload), 'ko', 'filled')
    hold on;
    b=polyfit(sum12, cell2mat(lesionload),1);
    a=polyval(b,sum12);
    plot(sum12, a, '-r')
    [rho,p]=corr(sum12,cell2mat(lesionload), 'Type', 'Pearson');
    title({'Number of remaps S1-S2 vs.' ,'CST lesion load'})
    xlabel('Total # remaps')
    ylabel('Lesion load on CST')
    xlim([0 150])
    text(3, 0.024, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
    text(3, 0.022, {['p: ', sprintf('%.2g',p)]}, 'FontSize', 20)
    set(gca, 'FontSize', 20)
    saveas(gcf, strcat(results_dir, 'figures/lesionload_remapss1s2.png'))
    saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/apaper/figs/lesionload_remapss1s2.png')

    [rho, p]=corr(fm_1,vol, 'rows', 'complete')
    
    [rho,p]=corr(sum23, vol, 'rows', 'complete')
    [rho,p]=corr(sum34, vol, 'rows', 'complete')
    [rho,p]=corr(sum45, vol, 'rows', 'complete')

    [rho,p]=corr(fm_1, sum12, 'rows', 'complete')
    
    % baseline impairment vs. sum of swaps 1 to 2.
    figure('Position', [0 0 500 500])
    scatter(sum12(1:21), fm_1(1:21), 'ko', 'filled')
    hold on;
    b=polyfit(sum12(1:21), fm_1(1:21),1);
    a=polyval(b,sum12(1:21));
    plot(sum12(1:21), a, '-r')
    [rho,p]=corr(sum12(1:21),fm_1(1:21), 'Type', 'Pearson');
    title({'Baseline Fugl-Meyer scores vs.' ,'sum of remaps S2-S1'})
    xlabel('Total # remaps')
    ylabel('Baseline F-M score')
    xlim([0 150])
    ylim([0 105])
    text(75, 90, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
    text(75, 84, {['p: ', num2str(round(p, 3))]}, 'FontSize', 20)
    set(gca, 'FontSize', 20)
    results.baselineFM_remaps_s1s2.p=p;
    results.baselineFM_remaps_s1s2.rho=rho;

    saveas(gcf, strcat(results_dir, 'figures/baselineFM_remaps_s1s2.png'))
    saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/apaper/figs/baselineFM_remaps_s1s2.png')

    % 6 month recovery recovery vs S1-S2 swaps.
    figure('Position', [0 0 500 500])
    scatter(sum12, fm_5-fm_1,'ko', 'filled')
    [rho,p]=corr(sum12,fm_5-fm_1,'rows', 'complete');
    hold on;
    recovery=fm_5-fm_1;
    idx = isnan(recovery);
    b=polyfit(sum12(~idx), recovery(~idx),1);
    a=polyval(b,sum12);
    xlim([0 150])
    plot(sum12, a, '-r')
    xlabel('Total # remaps S1-S2')
    ylabel('Change in Fugl-Meyer (last baseline-followup)')
    title({'Baseline # swaps vs', ' 6 month improvement motor scores'})
    set(gca, 'FontSize', 20)
    text(2, 90, {['Rho: ', num2str(round(rho,3))]}, 'FontSize', 20)
    text(2, 84, {['p: ', num2str(round(p, 3))]}, 'FontSize', 20)
    results.baselineswaps_6monthFM.p=p;
    results.baselineswaps_6monthFM.rho=rho;
    
    saveas(gcf, strcat(results_dir, 'figures/baselineswaps_6monthFM.png'))
    saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/apaper/figs/baselineswaps_6monthFM.png')

    %%
    % What we want to test is whether the number of swaps from Session k to Session k+1
    % is correlated with the change in motor scores.
    figure('Position', [0 0 700 700])
    motor=[fm_1,fm_2,fm_3,fm_4,fm_5];
    [nr,nc] = size(motor);
    pcolor([motor nan(nr,1); nan(1,nc+1)]);
    colorbar
    yticks(1:23)
    yticklabels({1:23})
    xticks([1 2 3 4 5])
    set(gca,'FontSize', 13)
    title('Fugl-Meyer scores over sessions')
    xlabel('Session')
    ylabel('Subjects')
    set(gca,'FontSize', 20)
    colormap parula
    colorbar
    legend('no data')

    
    %saveas(gcf, strcat(results_dir, 'figures/FM_overtime.png'))
    %saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/apaper/figs/FM_overtime.png')

    fm12=(fm_2-fm_1);
    fm23=(fm_3-fm_2);
    fm34=(fm_4-fm_3);
    fm45=(fm_5-fm_4);

    % all inter-scan changes in FM and # remaps
    allrecover=[fm12;fm23;fm34;fm45];
    allsum=[sum12;sum23;sum34;sum45];

    sex=[0;1;1;1;1;0;1;1;1;1;1;0;1;1;0;0;1;1;0;0;1;1;0];
    age=[54;57;59;48;63;34;60;61;56;68;62;74;55;54;73;62;60;56;64;55;42;40;56];
    lesionvol=load(strcat(fm_dir, 'allpts_lesionvol.txt'));
    lesionvol=lesionvol(:,1);
    lesion_all=[lesionvol;lesionvol;lesionvol;lesionvol];
    sex_all=[sex;sex;sex;sex];
    age_all=[age;age;age;age];

    figure('Position', [0 0 700 700])
    plot(allsum, allrecover,'ko')
    [rho,p]=corr(allsum, allrecover, 'rows', 'complete', 'Type', 'Spearman');
    xlabel('Sum of remaps between all pairs of sessions')
    ylabel('Change FM between all pairs of sessions')
    set(gca,'FontSize', 13)
    title('Change in Fugl-Meyer scores vs. sum of remaps between all pairs of sessions')
    saveas(gcf, strcat(results_dir, 'figures/sum_remaps_recovery_allsessions.png'))

    results.corr_recovery_remaps.spearman_p=p;
    results.corr_recovery_remaps.spearman_rho=rho;

    results.partialcorr_recovery_remaps.order={'sum remaps', 'recovery', 'sex', 'age'};

    [rho,p]=partialcorr([allsum,allrecover,sex_all,age_all], 'rows', 'complete', 'Type', 'Spearman');
    results.partialcorr_recovery_remaps.spearman_p=p;
    results.partialcorr_recovery_remaps.spearman_corr=rho;

    [rho,p]=partialcorr([allsum,allrecover,sex_all,age_all], 'rows', 'complete', 'Type', 'Pearson');
    results.partialcorr_recovery_remaps.pearson_p=p;
    results.partialcorr_recovery_remaps.pearson_corr=rho;

    [rho,p]=partialcorr([allsum,allrecover,sex_all,age_all,lesion_all], 'rows', 'complete', 'Type', 'Spearman');

    %% 
    figure('Position', [0 0 500 500])
    tiledlayout(2,2, 'padding', 'none')
    nexttile;
    scatter(sum12, fm12,'ko', 'filled')
    [rho,p]=corr(sum12,fm12, 'rows', 'complete', 'Type', 'Pearson');
    results.corr_recovery_remap_sessionspecific.s1s2.p=p;
    results.corr_recovery_remap_sessionspecific.s1s2.rho=rho;
    hold on;
    idx=isnan(fm12);
    b=polyfit(sum12(~idx), fm12(~idx),1);
    a=polyval(b,sum12);
    plot(sum12, a, '-r')
    title({'FM2-FM1 vs','# remaps S1-S2'})
    xlabel('Sum of remaps')
    ylabel('\Delta FM score')
    text(2, -20, {['rho: ', num2str(round(rho,3))], ['p: ', num2str(round(p,3))]}, 'FontSize', 15)
    ylim([-40 80])
    xlim([0 150])
    set(gca,'FontSize', 15)

    nexttile;
    scatter(sum23, fm23,'ko', 'filled')
    [rho,p]=corr(sum23,fm23, 'rows', 'complete', 'Type', 'Pearson');
    results.corr_recovery_remap_sessionspecific.s2s3.p=p;
    results.corr_recovery_remap_sessionspecific.s2s3.rho=rho;
    hold on;
    idx=isnan(fm23);
    b=polyfit(sum23(~idx), fm23(~idx),1);
    a=polyval(b,sum23);
    plot(sum23, a, '-r')
    title({'FM3-FM2 vs','# remaps S2-S3'})
    xlabel('Sum of remaps')
    ylabel('\Delta FM score')
    text(2, -20, {['rho: ', num2str(round(rho,3))], ['p: ', num2str(round(p,3))]}, 'FontSize', 15)
    ylim([-40 80])
    xlim([0 150])
    set(gca,'FontSize', 15)

    nexttile;
    scatter(sum34, fm34,'ko', 'filled')
    [rho,p]=corr(sum34,fm34, 'rows', 'complete', 'Type', 'Pearson');
    results.corr_recovery_remap_sessionspecific.s3s4.p=p;
    results.corr_recovery_remap_sessionspecific.s3s4.rho=rho;
    hold on;
    idx=isnan(fm34);
    b=polyfit(sum34(~idx), fm34(~idx),1);
    a=polyval(b,sum34);
    plot(sum34, a, '-r')
    title({'FM4-FM3 vs','# remaps S3-S4'})
    xlabel('Sum of remaps')
    ylabel('\Delta FM score')
    text(2, -20, {['rho: ', num2str(round(rho,3))], ['p: ', num2str(round(p,3))]}, 'FontSize', 15)
    ylim([-40 80])
    xlim([0 150])
    set(gca,'FontSize', 15)

    nexttile
    scatter(sum45, fm45,'ko', 'filled')
    [rho,p]=corr(sum45,fm45, 'rows', 'complete', 'Type', 'Pearson');
    results.corr_recovery_remap_sessionspecific.s4s5.p=p;
    results.corr_recovery_remap_sessionspecific.s4s5.rho=rho;
    hold on;
    idx=isnan(fm45);
    b=polyfit(sum45(~idx), fm45(~idx),1);
    a=polyval(b,sum45);
    plot(sum45, a, '-r')
    title({'FM5-FM4 vs','# remaps S4-S5'})
    xlabel('Sum of remaps')
    ylabel('\Delta FM score')
    text(2, -20, {['rho: ', num2str(round(rho,3))], ['p: ', num2str(round(p,3))]}, 'FontSize', 15)
    ylim([-40 80])
    xlim([0 150])
    set(gca,'FontSize', 15)
    
   % sgtitle('Session-specific change in Fugl-Meyer scores vs. sum of remaps')
    saveas(gcf, strcat(results_dir, 'figures/remaps_recovery_sessionspecific.png'))
    saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/apaper/figs/remaps_recovery_sessionspecific.png')

    close all;
    %% 
    save(strcat(results_dir, 'results.mat'), 'results')
end

i=1

plot_yeo
