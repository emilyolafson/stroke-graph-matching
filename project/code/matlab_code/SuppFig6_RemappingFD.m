% Calculate the correlation between framewise displacement & remapping.

% Load realignment parameters (from CONN) and calculate framewise
% displacement
for i=1:23
    for j=1:5
        if (j==3 && i==20)
            framewise_d{20,3}=0;
            continue
        end
        if (j==4 && i==20)
            framewise_d{20,4}=0;
            continue
        end
        if (j==4 && i==12)
            framewise_d{12,4}=0;
            continue
        end
        if (j==5 && i==20)
            framewise_d{20,5}=0;
            continue
        end
        if (j==5 && i==12)
            framewise_d{12,5}=0;
            continue
        end
        if (j==5 && i==6)
            framewise_d{6,5}=0;
            continue
        end
        
        % load realignment parameters (rp)
        rp{i,j}=load(strcat(curr_dir, 'data/rps/SUB', num2str(i), '/rpfunc_S', num2str(j), '.txt'));
        rps=rp{i,j};
        
        % calculate framewise displacement (fd)
        clear fd
        for k=2:length(rps)
            for p=1:3 % x y z
                fd(k-1,p)=rps(k-1,p)-rps(k,p);
            end
            for p=4:6 % roll pitch yaw
                fd(k-1,p)=rps(k-1,p)*50-rps(k,p)*50;
            end 
            fd=sum(abs(fd),2);
        end
        framewise_d{i,j}=mean(fd(fd<0.5));
    end
end

framewised=cell2mat(framewise_d);
meanfd=mean(framewised,2);

sum_12_remappings=sum(remappings_12,2, 'omitnan');
sum_23_remappings=sum(remappings_23,2, 'omitnan');
sum_34_remappings=sum(remappings_34,2, 'omitnan');
sum_45_remappings=sum(remappings_45,2, 'omitnan');

sum_23_remappings(20)=NaN;
sum_34_remappings(12)=NaN;
sum_34_remappings(20)=NaN;
sum_45_remappings(20)=NaN;
sum_45_remappings(12)=NaN;
sum_45_remappings(6)=NaN;

% plot: avg. framewise displacement vs. sum of remaps between sessions
figure('Position', [0 0 900 700])
tiledlayout(2,2,'padding', 'none')
nexttile;
scatter(mean(framewised(:,1),2)-mean(framewised(:,2),2),sum_12_remappings,'ko','filled')
[rho,p]=corr(mean(framewised(:,1),2)-mean(framewised(:,2),2),sum_12_remappings,'Type', 'Spearman', 'rows', 'complete')
title('1 week - 2 weeks post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 17)
lsline
text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
ylim([0, 150])
xlim([-0.1,0.15])


nexttile;
scatter(mean(framewised(:,2),2)-mean(framewised(:,3),2),sum_23_remappings,'ko','filled')
[rho,p]=corr(mean(framewised(:,2),2)-mean(framewised(:,3),2),sum_23_remappings,'Type', 'Spearman', 'rows', 'complete')
title('2 weeks - 1 month post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 17)

lsline
text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
ylim([0, 150])
xlim([-0.1,0.15])


nexttile;
scatter(mean(framewised(:,3),2)-mean(framewised(:,4),2),sum_34_remappings,'ko','filled')
[rho,p]=corr(mean(framewised(:,3),2)-mean(framewised(:,4),2),sum_34_remappings,'Type', 'Spearman', 'rows', 'complete')
title('1 month - 3 months post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 17)
lsline
text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
ylim([0, 150])
xlim([-0.1,0.15])

nexttile;
scatter(mean(framewised(:,4),2)-mean(framewised(:,5),2),sum_45_remappings,'ko','filled')
[rho,p]=corr(mean(framewised(:,4),2)-mean(framewised(:,5),2),sum_45_remappings,'Type', 'Spearman', 'rows', 'complete')
title('3 months - 6 months post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
xlim([-0.1,0.15])
set(gca,'FontSize', 17)
lsline
text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
ylim([0, 150])
xlim([-0.1,0.15])

saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/supp_FD.png')




% plot: 1st scan framewise displacement vs. sum of remaps between sessions
figure('Position', [0 0 900 700])
tiledlayout(2,2,'padding', 'none')
nexttile;
scatter(framewised(:,1), sum_12_remappings,'ko','filled')
[rho,p]=corr(framewised(:,1),sum_12_remappings,'Type', 'Spearman', 'rows', 'complete')
title('1 week - 2 weeks post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 17)
lsline
%text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
%text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
ylim([0, 150])
%xlim([-0.1,0.15])


nexttile;
scatter(framewised(:,2),sum_23_remappings,'ko','filled')
[rho,p]=corr(framewised(:,2),sum_23_remappings,'Type', 'Spearman', 'rows', 'complete')
title('2 weeks - 1 month post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 17)

lsline
% text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
% text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
% ylim([0, 150])
% xlim([-0.1,0.15])


nexttile;
scatter(framewised(:,3),sum_34_remappings,'ko','filled')
[rho,p]=corr(framewised(:,3),sum_34_remappings,'Type', 'Spearman', 'rows', 'complete')
title('1 month - 3 months post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 17)
lsline
% text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
% text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
% ylim([0, 150])
% xlim([-0.1,0.15])

nexttile;
scatter(framewised(:,4),sum_45_remappings,'ko','filled')
[rho,p]=corr(framewised(:,4),sum_45_remappings,'Type', 'Spearman', 'rows', 'complete')
title('3 months - 6 months post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
% xlim([-0.1,0.15])
set(gca,'FontSize', 17)
lsline
% text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
% text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
% ylim([0, 150])
% xlim([-0.1,0.15])
saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/supp_FD_1stscan_corr.png')




% plot: 1st scan framewise displacement vs. sum of remaps between sessions
figure('Position', [0 0 900 700])
tiledlayout(2,2,'padding', 'none')
nexttile;
scatter(framewised(:,2), sum_12_remappings,'ko','filled')
[rho,p]=corr(framewised(:,2),sum_12_remappings,'Type', 'Spearman', 'rows', 'complete')
title('1 week - 2 weeks post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 17)
lsline
%text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
%text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
ylim([0, 150])
%xlim([-0.1,0.15])


nexttile;
scatter(framewised(:,3),sum_23_remappings,'ko','filled')
[rho,p]=corr(framewised(:,3),sum_23_remappings,'Type', 'Spearman', 'rows', 'complete')
title('2 weeks - 1 month post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 17)

lsline
% text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
% text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
% ylim([0, 150])
% xlim([-0.1,0.15])


nexttile;
scatter(framewised(:,4),sum_34_remappings,'ko','filled')
[rho,p]=corr(framewised(:,4),sum_34_remappings,'Type', 'Spearman', 'rows', 'complete')
title('1 month - 3 months post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 17)
lsline
% text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
% text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
% ylim([0, 150])
% xlim([-0.1,0.15])

nexttile;
scatter(framewised(:,5),sum_45_remappings,'ko','filled')
[rho,p]=corr(framewised(:,5),sum_45_remappings,'Type', 'Spearman', 'rows', 'complete')
title('3 months - 6 months post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
% xlim([-0.1,0.15])
set(gca,'FontSize', 17)
lsline
% text(-0.08, 120, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
% text(-0.08, 100, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
% ylim([0, 150])
% xlim([-0.1,0.15])
saveas(gcf, 'stroke-graph-matching/allfigures/maintxt/precision_FC/supp_FD_2ndscan_corr.png')
