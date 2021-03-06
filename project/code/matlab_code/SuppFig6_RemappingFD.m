% Calculate the correlation between framewise displacement & remapping.
clear all;
close all;
threshold = 1;
beta = 1;
alpha = 0;  % old regularization; not used (use alpha = 0 for all results in paper)

curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/';

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

remaps_cast=sum(remappings_12)

%% 28andme -  find indices that remap
data_dir=strcat(curr_dir, 'data/28andme/results/regularized/')

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
remaps28=sum(remappings_12);

%% combine all remaps from 28andme and cast dataset
remapsall=remaps28+remaps_cast
highremaps_ctl=remapsall>=threshold % cutoff for # of cast windows in which node is remapped

data_dir=strcat(curr_dir, 'project/results/precision/');

S1S2_np=load(strcat(data_dir, 'cols_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % 
S2S3_np=load(strcat(data_dir, 'cols_S2S3_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); %
S3S4_np=load(strcat(data_dir, 'cols_S3S4_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); %
S4S5_np=load(strcat(data_dir, 'cols_S4S5_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % 

% subjects with missing data
S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];

%% Get remapping matrices - 1 or 0 based on whether a node was remapped or not.
order=1:268;
S1S2_np=S1S2_np+1;
S2S3_np=S2S3_np+1;
S3S4_np=S3S4_np+1;
S4S5_np=S4S5_np+1;

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
tiledlayout(2,2,'padding', 'none')
nexttile;
scatter(mean(framewised(:,1),2)-mean(framewised(:,2),2),sum_12_remappings,'ko','filled')
[rho,p]=corr(mean(framewised(:,1),2)-mean(framewised(:,2),2),sum_12_remappings,'Type', 'Spearman', 'rows', 'complete')
title('1 week - 2 weeks post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 20)
hold on;
b=polyfit(mean(framewised(:,1),2)-mean(framewised(:,2),2), sum_12_remappings,1);
a=polyval(b,mean(framewised(:,1),2)-mean(framewised(:,2),2));
plot(mean(framewised(:,1),2)-mean(framewised(:,2),2), a, '-r')
text(-0.1, 45, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
text(-0.1, 40, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
ylim([0, 50])
xlim([-0.1,0.15])

nexttile;
scatter(mean(framewised(:,2),2)-mean(framewised(:,3),2),sum_23_remappings,'ko','filled')
[rho,p]=corr(mean(framewised(:,2),2)-mean(framewised(:,3),2),sum_23_remappings,'Type', 'Spearman', 'rows', 'complete')
title('2 weeks - 1 month post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 20)
hold on;
b=polyfit(mean(framewised(:,2),2)-mean(framewised(:,3),2), sum_12_remappings,1);
a=polyval(b,mean(framewised(:,2),2)-mean(framewised(:,3),2));
plot(mean(framewised(:,2),2)-mean(framewised(:,3),2), a, '-r')
ylim([0, 50])
text(-0.1, 45, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
text(-0.1, 40, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)

xlim([-0.1,0.15])

nexttile;
scatter(mean(framewised(:,3),2)-mean(framewised(:,4),2),sum_34_remappings,'ko','filled')
[rho,p]=corr(mean(framewised(:,3),2)-mean(framewised(:,4),2),sum_34_remappings,'Type', 'Spearman', 'rows', 'complete')
title('1 month - 3 months post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
set(gca,'FontSize', 20)
hold on;
b=polyfit(mean(framewised(:,3),2)-mean(framewised(:,4),2), sum_12_remappings,1);
a=polyval(b,mean(framewised(:,3),2)-mean(framewised(:,4),2));
plot(mean(framewised(:,3),2)-mean(framewised(:,4),2), a, '-r')
ylim([0, 50])
text(-0.1, 45, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
text(-0.10, 40, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)

xlim([-0.1,0.15])

nexttile;
scatter(mean(framewised(:,4),2)-mean(framewised(:,5),2),sum_45_remappings,'ko','filled')
[rho,p]=corr(mean(framewised(:,4),2)-mean(framewised(:,5),2),sum_45_remappings,'Type', 'Spearman', 'rows', 'complete')
title('3 months - 6 months post-stroke')
xlabel('Difference in framewise displacement')
ylabel('Number of remaps')
xlim([-0.1,0.15])
hold on;
ylim([0, 50])
b=polyfit(mean(framewised(:,4),2)-mean(framewised(:,5),2), sum_12_remappings,1);
a=polyval(b,mean(framewised(:,4),2)-mean(framewised(:,5),2));
plot(mean(framewised(:,4),2)-mean(framewised(:,5),2), a, '-r')
text(-0.1, 45, {['Correlation: ', num2str(round(rho,3))]}, 'FontSize', 20)
text(-0.10, 40, {['p: ', num2str(round(p, 5))]}, 'FontSize', 20)
set(gca,'FontSize', 20)


