% Calculate difference between ChaCo scores of nodes that remap vs. those
% that don't, across stroke subjects.
% Uses Violinplot: https://github.com/bastibe/Violinplot-Matlab
close all;
clear all;
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

remaps_cast=sum(remappings_12);

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

S1S2_np(:,highremaps_ctl)=NaN;
S2S3_np(:,highremaps_ctl)=NaN;
S3S4_np(:,highremaps_ctl)=NaN;
S4S5_np(:,highremaps_ctl)=NaN;

%% Load ChaCo scores
for i=1:23
    chacovol{i}=load(strcat(curr_dir,'/data/chaco/SUB', num2str(i), '_lesion_1mmMNI_shen268_mean_chacovol.csv'));
end

mean_chacovol=mean(cell2mat(chacovol'));
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

remappings_12(:,highremaps_ctl)=NaN
remappings_23(:,highremaps_ctl)=NaN
remappings_23(20,:)=NaN
remappings_34(:,highremaps_ctl)=NaN
remappings_34(12,:)=NaN
remappings_34(20,:)=NaN
remappings_45(:,highremaps_ctl)=NaN
remappings_45(6,:)=NaN
remappings_45(12,:)=NaN
remappings_45(20,:)=NaN

%% Get ChaCo score of nodes that remap versus nodes that don't remap for each subject separately
tiledlayout(2, 2, 'padding', 'none')
nexttile;

for i=1:23 % across subjects
    subchaco=chacovol{i}(~highremaps_ctl);
    remaps=remappings_12(i,~highremaps_ctl);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end

noremap=cell2mat(chaco_noremap);
rmp=cell2mat(chaco_remap);
code=[zeros(size(noremap)), ones(size(rmp))];
violinplot([log(noremap) log(rmp)], code);
[p, obs, eff]=permutationTest(noremap,rmp,10000)
text(0.9, 0, ['p = ', num2str(p)], 'FontSize', 12)
text(0.9, 2, ['Hedges g = ', num2str(round(eff,3))], 'FontSize', 12) 

xticklabels({'Not remapped', 'Remapped'})
ylabel('Log-transformed ChaCo score')
set(gca, 'FontSize', 12)
ylim([-18, 3])
title('1 week - 2 weeks post-stroke')

nexttile;
for i=1:23 % across subjects
    if i==20
        continue;
    end
    subchaco=chacovol{i}(~highremaps_ctl);
    remaps=remappings_23(i,~highremaps_ctl);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end

noremap=cell2mat(chaco_noremap);
rmp=cell2mat(chaco_remap);
code=[zeros(size(noremap)), ones(size(rmp))];
violinplot([log(noremap) log(rmp)], code);
[p, obs, eff]=permutationTest(noremap,rmp,10000)
xticklabels({'Not remapped', 'Remapped'})
ylabel('Log-transformed ChaCo score')
set(gca, 'FontSize', 12)
text(0.9, 0, ['p = ', num2str(p)], 'FontSize', 12)
text(0.9, 2, ['Hedges g = ', num2str(round(eff,3))], 'FontSize', 12) 

ylim([-18, 3])
title('2 weeks - 1 month post-stroke')

 nexttile;

for i=1:23 % across subjects
    if i==20
        continue;
    end
    if i==12
        continue;
    end
    subchaco=chacovol{i}(~highremaps_ctl);
    remaps=remappings_34(i,~highremaps_ctl);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end

noremap=cell2mat(chaco_noremap);
rmp=cell2mat(chaco_remap);
code=[zeros(size(noremap)), ones(size(rmp))];
violinplot([log(noremap) log(rmp)], code);
[p, obs, eff]=permutationTest(noremap,rmp,10000)
xticklabels({'Not remapped', 'Remapped'})
ylabel('Log-transformed ChaCo score')
set(gca, 'FontSize', 12)
text(0.9, 0, ['p = ', num2str(p)], 'FontSize', 12)
text(0.9, 2, ['Hedges g = ', num2str(round(eff,3))], 'FontSize', 12) 

ylim([-18, 3])
title('1 month - 3 months post-stroke')

nexttile;

for i=1:23 % across subjects
    if i==20
        continue;
    end
    if i==12
        continue;
    end
    if i==6
        continue;
    end
    subchaco=chacovol{i}(~highremaps_ctl);
    remaps=remappings_45(i,~highremaps_ctl);
    chaco_remap{i}=subchaco(logical(remaps));
    chaco_noremap{i}=subchaco(~logical(remaps));
end

noremap=cell2mat(chaco_noremap);
rmp=cell2mat(chaco_remap);
code=[zeros(size(noremap)), ones(size(rmp))];
violinplot([log(noremap) log(rmp)], code)
[p, obs, eff]=permutationTest(noremap,rmp,10000);
xticklabels({'Not remapped', 'Remapped'})
ylabel('Log-transformed ChaCo score')
text(0.9, 0, ['p = ', num2str(p)], 'FontSize', 12)
text(0.9, 2, ['Hedges g = ', num2str(round(eff,3))], 'FontSize', 12) 
ylim([-18, 3])

title('3 months - 6 months post-stroke')

set(gca, 'FontSize', 12)


