% Calculate functional connectivity and node strength from precision FC
% calculations by taking a z-score of each node relative to controls, load ChaCo scores for eaech node from NeMo tool,
% and relate these measures of functional and structural disconnection to
% remapping frequencies for each node


%% 1. Calculate FC & differences in node strength between stroke & control

% load precision FC for stroke and controls
controls=load('/Users/emilyolafson/GIT/stroke-graph-matching/data/controls/precision/C_precision_diagonal.mat')
controls=controls.C_precision; %24 sub x 5 time points

stroke=load('/Users/emilyolafson/GIT/stroke-graph-matching/data/precision/C_precision_diagonal.mat')
stroke=stroke.C_precision; % 23 sub x 5 tps

% Calculate FC for session 1 (1 week post-stroke)
% session 1
str=stroke(:,1);
ctl=controls(:,1);

l=1; % sess variable =1
% calculate FC for stroke subs
for i=1:23
    fc=atanh(cell2mat(str(i)));
    for j=1:268
        for k=1:268
            fc_stroke(i,j,k,l)=fc(j,k); % i = sub, j = node, k = node, l = time point
        end
    end
end

% calculate FC for controls subs
for i=1:24
    fc=atanh(cell2mat(ctl(i)));
    for j=1:268
        for k=1:268
            fc_control(i,j,k,l)=fc(j,k); % i = sub, j = node, k = node, l = time point
        end
    end    
end

% ttest for each node pair
for i=1:268
    for j=1:268
        [~, p(i,j), ~, stats]=ttest2(fc_stroke(:,i,j),fc_control(:,i,j),'Vartype','unequal');
        tval(i,j)=stats.tstat;
    end
end

% adjust pvalues for multiple comparisons
[pvalues,~,~,adj_p(:,j)]=fdr_bh(p, 0.05,'pdep')

sig=sum(sum(adj_p<0.05))
tstat=tval.*pvalues;

% save results
save('data/ttest_precision_FC_sess1_tvals.mat', 'tval')
save('data/ttest_precision_FC_sess1_tvals_sig.mat', 'tstat')

% Calculate FC for session 2 (2 week2 post-stroke)
str=stroke(:,2);
ctl=controls(:,2);

l=2;
% calculate FC for stroke subs
for i=1:23
    fc=atanh(cell2mat(str(i)));
    for j=1:268
        for k=1:268
            fc_stroke(i,j,k,l)=fc(j,k);
        end
    end
end

% calculate FC for control subs
for i=1:24
    fc=atanh(cell2mat(ctl(i)));
    for j=1:268
        for k=1:268
            fc_control(i,j,k,l)=fc(j,k);
        end
    end    
end
% ttest for each node pair
for i=1:268
    for j=1:268
        [~, p(i,j), ~, stats]=ttest2(fc_stroke(:,i,j),fc_control(:,i,j),'Vartype','unequal');
        tval(i,j)=stats.tstat;
    end
end

[pvalues,~,~,adj_p(:,j)]=fdr_bh(p, 0.05,'pdep')

sig=sum(sum(adj_p<0.05))
tstat=tval.*pvalues;

save('data/ttest_precision_FC_sess2_tvals.mat', 'tval')
save('data/ttest_precision_FC_sess2_tvals_sig.mat', 'tstat')


% Calculate FC for session 3 (1 month post-stroke)
str=stroke(:,3);
ctl=controls(:,3);
l=3
% calculate FC for stroke subs
for i=1:23
    if i==20
        continue
    end   
    fc=atanh(cell2mat(str(i)));
    for j=1:268
        for k=1:268
            fc_stroke(i,j,k,l)=fc(j,k);
        end
    end
end

% calculate FC for control subs

for i=1:24
    fc=atanh(cell2mat(ctl(i)));
    for j=1:268
        for k=1:268
            fc_control(i,j,k,l)=fc(j,k);
        end
    end    
end
% ttest for each node pair
for i=1:268
    for j=1:268
        [~, p(i,j), ~, stats]=ttest2(fc_stroke(:,i,j),fc_control(:,i,j),'Vartype','unequal');
        tval(i,j)=stats.tstat;
    end
end

[pvalues,c,d,adj_p(:,j)]=fdr_bh(p, 0.05,'pdep')

sig=sum(sum(adj_p<0.05))
tstat=tval.*pvalues;

save('data/ttest_precision_FC_sess3_tvals.mat', 'tval')
save('data/ttest_precision_FC_sess3_tvals_sig.mat', 'tstat')


% Calculate FC for session 4 (3 months post-stroke)
str=stroke(:,4);
ctl=controls(:,4);
l=4
% calculate FC for stroke subs
for i=1:23
    if i==20
        continue
    end
    if i==12
        continue
    end
   
    fc=atanh(cell2mat(str(i)));
    for j=1:268
        for k=1:268
            fc_stroke(i,j,k,l)=fc(j,k);
        end
    end
end

% calculate FC for control subs

for i=1:24
    fc=atanh(cell2mat(ctl(i)));
    for j=1:268
        for k=1:268
            fc_control(i,j,k,l)=fc(j,k);
        end
    end    
end
% ttest for each node pair
for i=1:268
    for j=1:268
        [~, p(i,j), ~, stats]=ttest2(fc_stroke(:,i,j),fc_control(:,i,j));
        tval(i,j)=stats.tstat;
    end
end

[pvalues,c,d,adj_p(:,j)]=fdr_bh(p, 0.05,'pdep')

sig=sum(sum(adj_p<0.05))
tstat=tval.*pvalues;

save('data/ttest_precision_FC_sess4_tvals.mat', 'tval')
save('data/ttest_precision_FC_sess4_tvals_sig.mat', 'tstat')


% Calculate FC for session 5 (6 months post-stroke)
str=stroke(:,5);
ctl=controls(:,5);

l=5
% calculate FC for stroke subs
for i=1:23
    if i==20
        continue
    end
    if i==12
        continue
    end
    if i==6
        continue
    end
    
    fc=atanh(cell2mat(str(i)));
    for j=1:268
        for k=1:268
            fc_stroke(i,j,k,l)=fc(j,k);
        end
    end
end

% calculate FC for control subs
for i=1:24
    fc=atanh(cell2mat(ctl(i)));
    for j=1:268
        for k=1:268
            fc_control(i,j,k,l)=fc(j,k);
        end
    end    
end
% ttest for each node pair
for i=1:268
    for j=1:268
        [~, p(i,j), ~, stats]=ttest2(fc_stroke(:,i,j),fc_control(:,i,j));
        tval(i,j)=stats.tstat;
    end
end

[pvalues,c,d,adj_p]=fdr_bh(p, 0.05,'pdep')

sig=sum(sum(adj_p<0.05))
tstat=tval.*pvalues;

save('data/ttest_precision_FC_sess5_tvals.mat', 'tval')
save('data/ttest_precision_FC_sess5_tvals_sig.mat', 'tstat')

%% 2. Calculate node strength & differences in node strength (t-statistic for each node from stroke-control ttest)

clear p
clear tval
clear adj_p
for j=1:5
    for i=1:23
        if j==3 && i==20
            continue
        elseif j==4 && i==12
            continue
        elseif j==4 && i==20
            continue
        elseif j==5 && i==6
            continue
        elseif j==5 && i==12
            continue
        elseif j==5 && i==20
            continue
        end
        fcmat=squeeze(fc_stroke(i,:,:,j));
        fcmat(logical(eye(268)))=0;

        for k=1:268
            ns_stroke(i,k)=sum(fcmat(k,:));
        end
    end

    for i=1:24
        fcmat=squeeze(fc_control(i,:,:,j));
        fcmat(logical(eye(268)))=0;

        for k=1:268
            ns_control(i,k)=sum(fcmat(k,:));
        end
    end

    for i=1:268
        [~, p(i), ~, stats]=ttest2(ns_stroke(:,i),ns_control(:,i));
        tval(i,j)=stats.tstat;
    end
    [pvalues,c,d,adj_p(:,j)]=fdr_bh(p, 0.05,'pdep')
end


%% 3. Calculate correlation between node strength and remapping frequency 

% session 1-2
% correlation between tstats of session 1 and remapping frequency 1-2 
figure('Position', [0 0 1000 500])
tiledlayout(1,2,'padding','none')
nexttile;
remapvar=remappingfreq_12;
tstat=tval(:,1)
[p, rho] = mult_comp_perm_corr(tstat,remapvar, 1000)

scatter(remapvar,tstat, 'ok', 'filled', 'jitter', 'on', 'jitterAmount', 0.01);
ylabel('Session 1 t-statistic node strength (stroke - control)')
xlabel('Node remapping frequency')
ylim([-5, 5])

if p==0
     text(0.4, 4, sprintf('Correlation: %0.2f \n p < 0.001', rho))
else
    text(0.4, 4, sprintf('Correlation: %0.2f \n p: %0.3e', rho, p))
end
title('Session 1-2 remapping freq, Session 1 FC')
set(gca, 'FontSize', 14)

nexttile;
% correlation between tstats of session 2 and remapping frequency 1-2 

tstat=tval(:,2)
[p, rho] = mult_comp_perm_corr(tstat,remapvar, 1000)
scatter(remapvar,tstat, 'ok', 'filled', 'jitter', 'on', 'jitterAmount', 0.01);
ylabel('Session 2 t-statistic node strength (stroke - control)')
xlabel('Node remapping frequency')
ylim([-5, 5])

if p==0
     text(0.4, 4, sprintf('Correlation: %0.2f \n p < 0.001', rho))
else
    text(0.4, 4, sprintf('Correlation: %0.2f \n p: %0.3e', rho, p))
end
title('Session 1-2 remapping freq, Session 2 FC')
set(gca, 'FontSize', 14)
saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/allfigures/supplementary/sess12_remapvar_tstat.png')



% session 2-3
% correlation between tstats of session 2 and remapping frequency 2-3
figure('Position', [0 0 1000 500])
tiledlayout(1,2,'padding','none')
nexttile;
remapvar=remappingfreq_23;
tstat=tval(:,2)
[p, rho] = mult_comp_perm_corr(tstat,remapvar, 1000)
scatter(remapvar,tstat, 'ok', 'filled', 'jitter', 'on', 'jitterAmount', 0.01);
ylabel('Session 2 t-statistic node strength (stroke - control)')
xlabel('Node remapping frequency')
ylim([-5, 5])

if p==0
     text(0.4, 4, sprintf('Correlation: %0.2f \n p < 0.001', rho))
else
    text(0.4, 4, sprintf('Correlation: %0.2f \n p: %0.3e', rho, p))
end
title('Session 2-3 remapping freq, Session 2 FC')
set(gca, 'FontSize', 14)

nexttile;
% correlation between tstats of session 3 and remapping frequency 2-3
tstat=tval(:,3)
[p, rho] = mult_comp_perm_corr(tstat,remapvar, 1000)
scatter(remapvar,tstat, 'ok', 'filled', 'jitter', 'on', 'jitterAmount', 0.01);
ylabel('Session 3 t-statistic node strength (stroke - control)')
xlabel('Node remapping frequency')
ylim([-5, 5])

if p==0
     text(0.4, 4, sprintf('Correlation: %0.2f \n p < 0.001', rho))
else
    text(0.4, 4, sprintf('Correlation: %0.2f \n p: %0.3e', rho, p))
end
title('Session 2-3 remapping freq, Session 3 FC')
set(gca, 'FontSize', 14)
saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/allfigures/supplementary/sess23_remapvar_tstat.png')

% session 3-4
% correlation between tstats of session 3 and remapping frequency 3-4
figure('Position', [0 0 1000 500])

tiledlayout(1,2,'padding','none')
nexttile;
remapvar=remappingfreq_34;
tstat=tval(:,3)
[p, rho] = mult_comp_perm_corr(tstat,remapvar, 1000)
scatter(remapvar,tstat, 'ok', 'filled', 'jitter', 'on', 'jitterAmount', 0.01);
ylabel('Session 3 t-statistic node strength (stroke - control)')
xlabel('Node remapping frequency')
ylim([-5, 5])

if p==0
     text(0.4, 4, sprintf('Correlation: %0.2f \n p < 0.001', rho))
else
    text(0.4, 4, sprintf('Correlation: %0.2f \n p: %0.3e', rho, p))
end
title('Session 3-4 remapping freq, Session 3 FC')
set(gca, 'FontSize', 14)

nexttile;
% correlation between tstats of session 4 and remapping frequency 3-4
tstat=tval(:,4)
[p, rho] = mult_comp_perm_corr(tstat,remapvar, 1000)
scatter(remapvar,tstat, 'ok', 'filled', 'jitter', 'on', 'jitterAmount', 0.01);
ylabel('Session 4 t-statistic node strength (stroke - control)')
xlabel('Node remapping frequency')
ylim([-5, 5])

if p==0
     text(0.4, 4, sprintf('Correlation: %0.2f \n p < 0.001', rho))
else
    text(0.4, 4, sprintf('Correlation: %0.2f \n p: %0.3e', rho, p))
end
title('Session 3-4 remapping freq, Session 4 FC')
set(gca, 'FontSize', 14)
saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/allfigures/supplementary/sess34_remapvar_tstat.png')


% session 4-5
% correlation between tstats of session 4 and remapping frequency 4-5
figure('Position', [0 0 1000 500])

tiledlayout(1,2,'padding','none')
nexttile;
remapvar=remappingfreq_45;
tstat=tval(:,4)
[p, rho] = mult_comp_perm_corr(tstat,remapvar, 1000)
scatter(remapvar,tstat, 'ok', 'filled', 'jitter', 'on', 'jitterAmount', 0.01);
ylabel('Session 4 t-statistic node strength (stroke - control)')
xlabel('Node remapping frequency')
ylim([-5, 5])

if p==0
     text(0.4, 4, sprintf('Correlation: %0.2f \n p < 0.001', rho))
else
    text(0.4, 4, sprintf('Correlation: %0.2f \n p: %0.3e', rho, p))
end
title('Session 4-5 remapping freq, Session 4 FC')
set(gca, 'FontSize', 14)

nexttile;
% correlation between tstats of session 5 and remapping frequency 4-5

tstat=tval(:,5)
[p, rho] = mult_comp_perm_corr(tstat,remapvar, 1000)
scatter(remapvar,tstat, 'ok', 'filled', 'jitter', 'on', 'jitterAmount', 0.01);
ylabel('Session 5 t-statistic node strength (stroke - control)')
xlabel('Node remapping frequency')
ylim([-5, 5])
if p==0
     text(0.4, 4, sprintf('Correlation: %0.2f \n p < 0.001', rho))
else
    text(0.4, 4, sprintf('Correlation: %0.2f \n p: %0.3e', rho, p))
end
title('Session 4-5 remapping freq, Session 5 FC')
set(gca, 'FontSize', 14)
saveas(gcf, '/Users/emilyolafson/GIT/stroke-graph-matching/allfigures/supplementary/sess45_remapvar_tstat.png')


%% 4. Calculate correlation between ChaCo scores, node strength t-stats, and remapping frequencies 
% for session 1

overlap_log = calculate_overlap_lesion_atlas;

% Calculate ChaCo scores excluding nodes containing the lesion
 for i=1:23
     chacovol{i}=load(strcat(curr_dir, 'data/nemo_oct21_bug/SUB', num2str(i), '_lesion_1mmMNI_shen268_mean_chacovol.csv'));
     chacovol{i}(overlap_log(i,:))=NaN; % exclude lesioned ROIs
 end
 
mean_chacovol=median(cell2mat(chacovol'), 'omitnan'); %median ChaCo scores across subjects 
remapvar=remappingfreq_45;
tstat=tval(:,4); 

a=readmatrix('/Users/emilyolafson/GIT/stroke-graph-matching/project/shen_268_parcellation_networklabels.csv') % load Shen268 atlas labels
c=a(:,2);
colrs=jet(8);
colrs=[colrs(5:8,:); colrs(1:4,:)]
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});

% 1. Remap freq vs T-statistics
figure('Position', [0 0 1600 500])
tiledlayout(1,3,'padding','none')
nexttile;
for i=1:8 % plot each node with color based on yeo network assignment
    idx=c==i;
    scatter(remapvar(idx),tstat(idx), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8, 'jitter', 'on', 'jitterAmount', 0.01)
    hold on;
end
[rho, p]=corr(remapvar, tstat)

text(0.5, 2, sprintf('Corr: %0.2f \n p: %0.2e', rho, p), 'FontSize', 14)

Fit = polyfit(remapvar,tstat,1); % x = x data, y = y data, 1 = order of the polynomial i.e a straight line 
plot(remapvar,polyval(Fit,remapvar))

xlabel('Node remapping frequency')
ylabel('T-statistic (stroke - control)')
set(gca, 'FontSize', 14)

% 2. Remap freq vs ChaCo scores
nexttile;
for i=1:8
    idx=c==i;
    scatter(remapvar(idx)',log(mean_chacovol(idx)), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8, 'jitter', 'on', 'jitterAmount', 0.01)
    hold on;
end
[rho, p]=corr(remapvar, log(mean_chacovol'))

Fit = polyfit(remapvar,log(mean_chacovol)',1); % x = x data, y = y data, 1 = order of the polynomial i.e a straight line 

text(0.05, -2, sprintf('Corr: %0.2f \n p: %0.2e', rho, p), 'FontSize', 14)

plot(remapvar,polyval(Fit,remapvar))
xlabel('Node remapping frequency')
ylabel('Log(median ChaCo scores)')
set(gca, 'FontSize', 14)

% 3. ChaCo scores vs T-statistics
nexttile;
for i=1:8
    idx=c==i;
    scatter( tstat(idx), log(mean_chacovol(idx)), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8, 'jitter', 'on', 'jitterAmount', 0.01)
    hold on;
end
[rho, p]=corr(tstat, log(mean_chacovol'))

text(1, -2, sprintf('Corr: %0.2f \n p: %0.2e', rho, p), 'FontSize', 14)

yline(-6, '-.b')
ylabel('Log(median ChaCo scores)')
xlabel('T-statistic')
set(gca, 'FontSize', 14)

saveas(gcf,'allfigures/maintxt/Fig4_ChaCo_NodeStrength_remap_s45_oct21.png')


%% 5. Calculate correlation between ChaCo scores, node strength t-stats, and remapping frequencies, above and below a threshold of structural disconnection 
figure('Position', [0 0 300 400])

tiledlayout(2,1,'padding', 'none')
% values above ChaCo threshold
idxes=log(mean_chacovol)>-6; % set threshold
nexttile;
for i=1:8
    idx=c==i;
    scatter(tstat(idx), log(mean_chacovol(idx)), 24, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
    hold on;
end
ylim([-6 -2])
xlim([-5 5])
xticks(-5:5)
xticklabels({'-5', '-4', '-3', '-2', '-1', '0', '1', '2', '3', '4', '5'})
Fit = polyfit(tstat(idxes),log(mean_chacovol(idxes))',1); % x = x data, y = y data, 1 = order of the polynomial i.e a straight line 
plot(tstat(idxes),polyval(Fit,tstat(idxes)))

[rho, p]=corr(tstat(idxes), log(mean_chacovol(idxes)'))
text(1, -3, sprintf('Corr: %0.2f \n p: %0.2e', rho, p))
ylabel('Log(median ChaCo scores)')
xlabel('T-statistic')
set(gca, 'FontSize', 10)

nexttile;

idxes=log(mean_chacovol)<-6;

for i=1:8
    idx=c==i;
    scatter(tstat(idx), log(mean_chacovol(idx)), 24, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
    hold on;
end
ylim([-14 -6])
xticks(-5:5)

xlim([-5 5])
xticklabels({'-5', '-4', '-3', '-2', '-1', '0', '1', '2', '3', '4', '5'})

Fit = polyfit(tstat(idxes),log(mean_chacovol(idxes))',1); % x = x data, y = y data, 1 = order of the polynomial i.e a straight line 
hold on;
plot(tstat(idxes),polyval(Fit,tstat(idxes)),'r')

[rho, p]=corr(tstat(idxes), log(mean_chacovol(idxes)'))
text(1, -13, sprintf('Corr: %0.2f \n p: %0.2e', rho, p))

ylabel('Log(median ChaCo scores)')
xlabel('T-statistic')
set(gca, 'FontSize', 10)
saveas(gcf,'allfigures/maintxt/Fig4_ChaCo_NodeStrength_remap_s45_thresholded_oct21.png')







