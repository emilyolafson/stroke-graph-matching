% Correlation between ChaCo scores and remap frequencies

curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/'

%% 
% run calculate_overlap_lesion_atlas;

 overlap_log = calculate_overlap_lesion_atlas;
 for i=1:23
     chacovol{i}=load(strcat(curr_dir, 'data/chaco/SUB', num2str(i), '_lesion_1mmMNI_shen268_mean_chacovol.csv'));
     chacovol_bin{i}=chacovol{i}>1e-4;
     %chacovol{i}(overlap_log(i,:))=NaN
     %chacovol_bin{i}(overlap_log(i,:))=NaN
 end
 
chacofreq=cell2mat(chacovol_bin')
chacofreq=sum(chacofreq)./23;



allchaco=cell2mat(chacovol');

mean_chacovol=median(allchaco, 'omitnan');


[pval, corr_obs, crit_corr, est_alpha, seed_state] = mult_comp_perm_corr([remappingfreq_12, remappingfreq_23, remappingfreq_34, remappingfreq_45],[mean_chacovol', mean_chacovol', mean_chacovol', mean_chacovol'], 1000)

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
    scatter(remappingfreq_12(idx)',log(mean_chacovol(idx)), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
    hold on;
end

xlabel('Remap frequency')
ylabel('log(median ChaCo)')
title('S1-S2')
ylim([-14, 0])
yticks([-14  -10 -6 -2 ])
yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s1s2.rho, 3))],['p < 0.001']}, 'FontSize', 15)
idz=isnan(remappingfreq_12);
b=polyfit(remappingfreq_12(~idz), log(mean_chacovol(~idz)),1);
a=polyval(b,remappingfreq_12(~idz));
hold on;
plot(remappingfreq_12(~idz), a, '-r')
set(gca, 'FontSize', 15)

nexttile;
for i=1:8
    idx=c==i;
    scatter(remappingfreq_23(idx),log(mean_chacovol(idx)), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
    hold on;
end
xlabel('Remap frequency')
ylabel('log(median ChaCo)')
title('S2-S3')
text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s2s3.rho, 3))],['p < 0.001']}, 'FontSize', 15)

yticks([-14  -10 -6 -2 ])
yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
ylim([-14, 0])

b=polyfit(remappingfreq_23(~idz), log(mean_chacovol(~idz)),1);
a=polyval(b,remappingfreq_23(~idz));
hold on;
plot(remappingfreq_23(~idz), a, '-r')
set(gca, 'FontSize', 15)

nexttile;
for i=1:8
    idx=c==i;
    scatter(remappingfreq_34(idx),log(mean_chacovol(idx)), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
    hold on;
end
xlabel('Remap frequency')
ylabel('log(median ChaCo)')
title('S3-S4')
ylim([-14, 0])
%xlim([0 0.7])
yticks([-14  -10 -6 -2 ])
yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s3s4.rho, 3))],['p < 0.001']}, 'FontSize', 15)
b=polyfit(remappingfreq_34(~idz), log(mean_chacovol(~idz)),1);
a=polyval(b,remappingfreq_34(~idz));
hold on;
plot(remappingfreq_34(~idz), a, '-r')
set(gca, 'FontSize', 15)

nexttile;
for i=1:8
    idx=c==i;
    scatter(remappingfreq_45(idx),log(mean_chacovol(idx)), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
    hold on;
end
xlabel('Remap frequency')
ylabel('log(median ChaCo)')
yticks([-14  -10 -6 -2 ])
yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
title('S4-S5')
ylim([-14, 0])
%xlim([0 0.7])
text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s4s5.rho, 3))],['p < 0.001']}, 'FontSize', 15)
b=polyfit(remappingfreq_45(~idz), log(mean_chacovol(~idz)),1);
a=polyval(b,remappingfreq_45(~idz));
hold on;
plot(remappingfreq_45(~idz), a, '-r')
set(gca, 'FontSize', 15)

%% legend
%nexttile;

saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/rev_Fig4A_ChaCo_remaps.png')
%legend(yeolabels)
