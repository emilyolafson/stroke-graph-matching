% Correlation between ChaCo scores and remap frequencies

curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/'

%% 
% run calculate_overlap_lesion_atlas;
load('allremaps_stroke.mat', 'allremaps')
load('allremaps_control.mat', 'allctl')

 overlap_log = calculate_overlap_lesion_atlas;
 for i=1:23
     chacovol{i}=load(strcat(curr_dir, 'data/nemo_oct21_bug/SUB', num2str(i), '_lesion_1mmMNI_shen268_mean_chacovol.csv'));
     chacovol_bin{i}=chacovol{i}>1e-3;
     chacovol{i}(overlap_log(i,:))=NaN
     %chacovol_bin{i}(overlap_log(i,:))=NaN
 end
 
chacofreq=cell2mat(chacovol_bin')
chacofreq=sum(chacofreq)./23;

[pval, corr_obs, crit_corr, est_alpha, seed_state] = mult_comp_perm_corr([remappingfreq_12, remappingfreq_23, remappingfreq_34, remappingfreq_45],[chacofreq', chacofreq', chacofreq', chacofreq'], 1000)

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
mean_chacovol=chacofreq;
% load shen 268 network annotation
a=readmatrix('/Users/emilyolafson/GIT/stroke-graph-matching/project/shen_268_parcellation_networklabels.csv')
c=a(:,2);
colrs=jet(8);
colrs=[colrs(5:8,:); colrs(1:4,:)]
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});

figure('Position', [0 0 700 700]) 
tiledlayout(2,2,'padding', 'none')
nexttile;

for i=1:8
    idx=c==i;
    scatter(remappingfreq_12(idx)',mean_chacovol(idx), 55, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8, 'jitter', 'on', 'jitterAmount', 0.05);
    hold on;
end

xlabel('Remap frequency')
ylabel('Disconnectivity frequency')
title('Session 1 - Session 2')
%ylim([0, 1.5])
%yticks([-14  -10 -6 -2 ])
%yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
text(0.5,0.6, {['Rho: ', num2str(round(results.corr_w_chaco.s1s2.rho, 3))],['p < 0.001']}, 'FontSize', 11)
idz=isnan(remappingfreq_12);
b=polyfit(remappingfreq_12(~idz), mean_chacovol(~idz),1);
a=polyval(b,remappingfreq_12(~idz));
hold on;
plot(remappingfreq_12(~idz), a, '-r')
set(gca, 'FontSize', 15)

nexttile;
for i=1:8
    idx=c==i;
    scatter(remappingfreq_23(idx),mean_chacovol(idx), 55, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8, 'jitter', 'on', 'jitterAmount', 0.05);
    hold on;
end
xlabel('Remap frequency')
ylabel('Disconnectivity frequency')
title('Session 2 - Session 3')
text(0.5,0.6, {['Rho: ', num2str(round(results.corr_w_chaco.s2s3.rho, 3))],['p < 0.001']}, 'FontSize', 11)

%yticks([-14  -10 -6 -2 ])
%yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
%ylim([0, 1.5])

b=polyfit(remappingfreq_23(~idz), mean_chacovol(~idz),1);
a=polyval(b,remappingfreq_23(~idz));
hold on;
plot(remappingfreq_23(~idz), a, '-r')
set(gca, 'FontSize', 15)

nexttile;
for i=1:8
    idx=c==i;
    scatter(remappingfreq_34(idx),mean_chacovol(idx), 55, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8, 'jitter', 'on', 'jitterAmount', 0.05);
    hold on;
end
xlabel('Remap frequency')
ylabel('Disconnectivity frequency')
title('Session 3 - Session 4')
%ylim([-14, 0])
%ylim([0, 1.5])
%yticks([-14  -10 -6 -2 ])
%yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
text(0.5,0.6, {['Rho: ', num2str(round(results.corr_w_chaco.s3s4.rho, 3))],['p < 0.001']}, 'FontSize', 11)
b=polyfit(remappingfreq_34(~idz), mean_chacovol(~idz),1);
a=polyval(b,remappingfreq_34(~idz));
hold on;
plot(remappingfreq_34(~idz), a, '-r')
set(gca, 'FontSize', 15)

nexttile;
for i=1:8
    idx=c==i;
    scatter(remappingfreq_45(idx),mean_chacovol(idx), 55, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8, 'jitter', 'on', 'jitterAmount', 0.05);
    hold on;
end
xlabel('Remap frequency')
ylabel('Disconnectivity frequency')
%yticks([-14  -10 -6 -2 ])
%yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
title('Session 4 - Session 5')
%ylim([0, 1.5])
%xlim([0 0.7])
text(0.5,0.6, {['Rho: ', num2str(round(results.corr_w_chaco.s4s5.rho, 3))],['p < 0.001']}, 'FontSize', 11)
b=polyfit(remappingfreq_45(~idz), mean_chacovol(~idz),1);
a=polyval(b,remappingfreq_45(~idz));
hold on;
plot(remappingfreq_45(~idz), a, '-r')
set(gca, 'FontSize', 15)


saveas(gcf, 'allfigures/maintxt/precision_FC/rev_Fig4A_ChaCo_remaps_disc_freq_Oct22.png')
legend(yeolabels)

%% legend
%nexttile;

mean_chacovol=median(allchaco, 'omitnan');
% remapping_AB = nsub x nROIs 1's and 0's with remapping or not.
figure('Position', [0 0 700 700]) 

tiledlayout(2, 2, 'padding', 'none')
nexttile;

for i=1:23 % across subjects
    subchaco=chacovol_bin{i}
    remaps=remappings_12(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
    
    noremap=cell2mat(chaco_noremap);
    rmp=cell2mat(chaco_remap);

    prop_noremap(i)=sum(chaco_noremap{i})/size(chaco_noremap{i},2)
    prop_remap(i)=sum(chaco_remap{i})/size(chaco_remap{i},2)
end

violinplot([prop_noremap',prop_remap'])

xticklabels({'Not remapped', 'Remapped'})
ylabel('Proportion of nodes disconnected')
set(gca, 'FontSize', 12)
title('1 week - 2 weeks post-stroke')
ylim([0.1 1.1])
[p, obs, eff]=permutationTest(prop_noremap,prop_remap,10000)
text(1, 1, ['p = ', num2str(round(p, 3))], 'FontSize', 12)
text(1, 0.9, ['Hedges g = ', num2str(round(eff,3))], 'FontSize', 12) 

nexttile;


for i=1:23 % across subjects
    
     if i==20
        continue
    end
    subchaco=chacovol_bin{i}
    remaps=remappings_23(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
    
    noremap=cell2mat(chaco_noremap);
    rmp=cell2mat(chaco_remap);

    prop_noremap(i)=sum(chaco_noremap{i})/size(chaco_noremap{i},2)
    prop_remap(i)=sum(chaco_remap{i})/size(chaco_remap{i},2)
end

violinplot([prop_noremap',prop_remap'])

xticklabels({'Not remapped', 'Remapped'})
ylabel('Proportion of nodes disconnected')
set(gca, 'FontSize', 12)
title('2 weeks - 1 month post-stroke')
ylim([0.1 1.1])
[p, obs, eff]=permutationTest(prop_noremap,prop_remap,10000)
text(1, 1, ['p = ', num2str(round(p, 3))], 'FontSize', 12)
text(1, 0.9, ['Hedges g = ', num2str(round(eff,3))], 'FontSize', 12) 



nexttile;

for i=1:23 % across subjects
     if i==20
        continue
    end
    if i==12
        continue
    end
    subchaco=chacovol_bin{i}
    remaps=remappings_34(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
    
    noremap=cell2mat(chaco_noremap);
    rmp=cell2mat(chaco_remap);

    prop_noremap(i)=sum(chaco_noremap{i})/size(chaco_noremap{i},2)
    prop_remap(i)=sum(chaco_remap{i})/size(chaco_remap{i},2)
end

violinplot([prop_noremap',prop_remap'])

xticklabels({'Not remapped', 'Remapped'})
ylabel('Proportion of nodes disconnected')
set(gca, 'FontSize', 12)
title('1 month - 3 months post-stroke')
ylim([0.1 1.1])
[p, obs, eff]=permutationTest(prop_noremap,prop_remap,10000)
text(1, 1, ['p = ', num2str(round(p, 3))], 'FontSize', 12)
text(1, 0.9, ['Hedges g = ', num2str(round(eff,3))], 'FontSize', 12) 




nexttile;

for i=1:23 % across subjects
    if i==20
        continue
    end
    if i==12
        continue
    end
    if i==6
        continue
    end
    subchaco=chacovol_bin{i}
    remaps=remappings_45(i,:);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
    
    noremap=cell2mat(chaco_noremap);
    rmp=cell2mat(chaco_remap);

    prop_noremap(i)=sum(chaco_noremap{i})/size(chaco_noremap{i},2)
    prop_remap(i)=sum(chaco_remap{i})/size(chaco_remap{i},2)
end

violinplot([prop_noremap',prop_remap'])

xticklabels({'Not remapped', 'Remapped'})
ylabel('Proportion of nodes disconnected')
set(gca, 'FontSize', 12)
title('3 months - 6 months post-stroke')
ylim([0.1 1.1])
[p, obs, eff]=permutationTest(prop_noremap,prop_remap,10000)
text(1, 1, ['p = ', num2str(round(p, 3))], 'FontSize', 12)
text(1, 0.9, ['Hedges g = ', num2str(round(eff,3))], 'FontSize', 12) 



saveas(gcf, 'allfigures/maintxt/rev_Fig4B_ChaCo_remap_vs_noremap_Oct22.png')




