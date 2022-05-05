% statistically valid remapping
% for a node x's remapping, define whether this remapping is statistically valid or not. 
% To do that, I would suggest observing the set of nodes, to which node x got assigned to in 
% the healthy control population along with their frequency. 
% You can make an assumption that, any remapping in the healthy controls is due to noise. 
% Then, if node x gets assigned to node y in a stroke patient, 
% but it never gets assigned to node y in healthy controls, 
% you could consider this as a statistically significant remapping.
curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/'

%% remove all remaps from stroke subjects that appear in controls.
beta=0;alpha=0;t=1;
target=[];
allswap_pairwise_stroke_sig=[]
% load demographically matched controls (24)
% session 1 - session 2 remaps in controls.
data_dir=strcat(curr_dir, 'project/results/controls/precision/')
S1S2_np=load(strcat(data_dir, 'cols_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt'));% no regularization.
controls_s1s2=S1S2_np+1;

order=1:268;
allswap_pairwise_ctrls=zeros(268,268);
sub_indices=controls_s1s2;

for i=1:24
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_ctrls(j,k)=allswap_pairwise_ctrls(j,k)+1;
            end
        end
    end
end

s1s2_ctl_remaps=allswap_pairwise_ctrls>t;
allctl=[allswap_pairwise_ctrls];
% session 2 - session 3 remaps in controls.
data_dir=strcat(curr_dir, 'project/results/controls/precision/')
S2S3_np=load(strcat(data_dir, 'cols_S2S3_alpha', num2str(alpha), '_beta', num2str(beta), '.txt'));% no regularization.
controls_s2s3=S2S3_np+1;

order=1:268;
allswap_pairwise_ctrls=zeros(268,268);
sub_indices=controls_s2s3;

for i=1:24
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_ctrls(j,k)=allswap_pairwise_ctrls(j,k)+1;
            end
        end
    end
end

s2s3_ctl_remaps=allswap_pairwise_ctrls>t;

allctl=allctl+allswap_pairwise_ctrls

% session 3 - session 4 remaps in controls.
data_dir=strcat(curr_dir, 'project/results/controls/precision/')
S3S4_np=load(strcat(data_dir, 'cols_S3S4_alpha', num2str(alpha), '_beta', num2str(beta), '.txt'));% no regularization.
controls_s3s4=S3S4_np+1;

order=1:268;
allswap_pairwise_ctrls=zeros(268,268);
sub_indices=controls_s3s4;

for i=1:24
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_ctrls(j,k)=allswap_pairwise_ctrls(j,k)+1;
            end
        end
    end
end

s3s4_ctl_remaps=allswap_pairwise_ctrls>t;

allctl=allctl+allswap_pairwise_ctrls


% session 4 - session 5 remaps in controls.
data_dir=strcat(curr_dir, 'project/results/controls/precision/')
S4S5_np=load(strcat(data_dir, 'cols_S4S5_alpha', num2str(alpha), '_beta', num2str(beta), '.txt'));% no regularization.
controls_s4s5=S4S5_np+1;

order=1:268;
allswap_pairwise_ctrls=zeros(268,268);
sub_indices=controls_s4s5;

for i=1:24
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_ctrls(j,k)=allswap_pairwise_ctrls(j,k)+1;
            end
        end
    end
end

s4s5_ctl_remaps=allswap_pairwise_ctrls>t;

allctl=allctl+allswap_pairwise_ctrls

allremaps_gr1=allctl>t;
imagesc(allremaps_gr1)

allremaps_gr1(logical(eye(268)))=0; % this is used to eliminate remapping pairs in stroke subejcts; dont want to eliminate non-remaps (i.e., 1's on diagonal) so remove these here




% for each subject, remove node pairs that have any remaps in controls
%% load stroke data
data_dir=strcat(curr_dir, '/project/results/stroke/precision/');

% load remapping indices (row = subject, columns = original node, element
% in cells = which node the original node was mapped to. starts at 0
% because python indexing starts at 0.
S1S2_np=load(strcat(data_dir, 'cols_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S2S3_np=load(strcat(data_dir, 'cols_S2S3_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S3S4_np=load(strcat(data_dir, 'cols_S3S4_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S4S5_np=load(strcat(data_dir, 'cols_S4S5_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];

remapping_12=zeros(23,268);
remapping_23=zeros(23,268);
remapping_34=zeros(23,268);
remapping_45=zeros(23,268);

allswap_pairwise_stroke_sig=[]
% session 1-2
order=1:268;
allswap_pairwise_stroke={};
sub_indices=S1S2_np+1;

sig_remaps=[]

for i=1:23
    allswap_pairwise_stroke{i}=zeros(268,268);
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_stroke{i}(j,k)=allswap_pairwise_stroke{i}(j,k)+1;
            end
        end
    end
end

for i=1:23
    tmp=allswap_pairwise_stroke{i}; % 268x268
    remaps(i)=sum(sum(tmp))
    tmp_new=tmp.*~allremaps_gr1;
    allswap_pairwise_stroke_sig{i,1}=tmp_new;
    for k=1:268 % k = source node
        disp(k)
        try
            target = find(allswap_pairwise_stroke_sig{i,1}(k,:)==1)
            remapping_12(i,k)=target;
        catch
            remapping_12(i,k)=k;
        end
    end
    tmp2=allswap_pairwise_stroke_sig{i,1};
    tmp2(logical(eye(268)))=0;
    sig_remaps(i,1)=sum(sum(tmp2))
end

% session 2-3
order=1:268;
allswap_pairwise_stroke={};
sub_indices=S2S3_np+1;

for i=1:23
    allswap_pairwise_stroke{i}=zeros(268,268);
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_stroke{i}(j,k)=allswap_pairwise_stroke{i}(j,k)+1;
            end
        end
    end
end

for i=1:23
    tmp=allswap_pairwise_stroke{i}; % 268x268
    remaps(i)=sum(sum(tmp))
    tmp_new=tmp.*~allremaps_gr1;
    allswap_pairwise_stroke_sig{i,2}=tmp_new;
    for k=1:268 % k = source node
        disp(k)
        try
            target = find(allswap_pairwise_stroke_sig{i,2}(k,:)==1)
            remapping_23(i,k)=target;
        catch
            remapping_23(i,k)=k;
        end
    end
    tmp2=allswap_pairwise_stroke_sig{i,2};
    tmp2(logical(eye(268)))=0;
    sig_remaps(i,2)=sum(sum(tmp2))
end


% session 3-4
order=1:268;
allswap_pairwise_stroke={};
sub_indices=S3S4_np+1;

for i=1:23
    allswap_pairwise_stroke{i}=zeros(268,268);
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_stroke{i}(j,k)=allswap_pairwise_stroke{i}(j,k)+1;
            end
        end
    end
end

for i=1:23
    tmp=allswap_pairwise_stroke{i}; % 268x268
    remaps(i)=sum(sum(tmp))
    tmp_new=tmp.*~allremaps_gr1;
    allswap_pairwise_stroke_sig{i,3}=tmp_new;
    for k=1:268 % k = source node
        disp(k)
        try
            target = find(allswap_pairwise_stroke_sig{i,3}(k,:)==1)
            remapping_34(i,k)=target;
        catch
            remapping_34(i,k)=k;
        end
    end
    tmp2=allswap_pairwise_stroke_sig{i,3};
    tmp2(logical(eye(268)))=0;
    sig_remaps(i,3)=sum(sum(tmp2))
end

% session 4-5
order=1:268;
allswap_pairwise_stroke={};
sub_indices=S4S5_np+1;

for i=1:23
    allswap_pairwise_stroke{i}=zeros(268,268);
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_stroke{i}(j,k)=allswap_pairwise_stroke{i}(j,k)+1;
            end
        end
    end
end

for i=1:23
    tmp=allswap_pairwise_stroke{i}; % 268x268
    remaps(i)=sum(sum(tmp))
    tmp_new=tmp.*~allremaps_gr1;
    allswap_pairwise_stroke_sig{i,4}=tmp_new;
    for k=1:268 % k = source node
        disp(k)
        try
            target = find(allswap_pairwise_stroke_sig{i,4}(k,:)==1)
            remapping_45(i,k)=target;
        catch
            remapping_45(i,k)=k;
        end
    end
    tmp2=allswap_pairwise_stroke_sig{i,4};
    tmp2(logical(eye(268)))=0;
    sig_remaps(i,4)=sum(sum(tmp2))
end

controlsum=s4s5_ctl_remaps+s1s2_ctl_remaps+s3s4_ctl_remaps+s2s3_ctl_remaps
%% is there any overlap in the nodes that remap in stroke subjects?
% Nodal level: 

% session 1-2
str_s1=[];
for i=1:23
    str_s1=cat(3, str_s1, cell2mat(allswap_pairwise_stroke_sig(i,1)));
end

str_s1_cat=sum(str_s1,3)
str_s1_cat(logical(eye(268)))=NaN
remappingfreq_12=sum(str_s1_cat,2,'omitnan')./23
save('str_s1_cat.mat', 'str_s1_cat')

% session 2-3
str_s2=[];
for i=1:23
    if i==20
        continue
    end
    str_s2=cat(3, str_s2, cell2mat(allswap_pairwise_stroke_sig(i,2)));
end

str_s2_cat=sum(str_s2,3)
str_s2_cat(logical(eye(268)))=NaN
remappingfreq_23=sum(str_s2_cat,2,'omitnan')./22
save('str_s2_cat.mat', 'str_s2_cat')

% session 3-4
str_s3=[];
for i=1:23
    if i==20
        continue
    end
    if i==12
        continue
    end
    str_s3=cat(3, str_s3, cell2mat(allswap_pairwise_stroke_sig(i,3)));
end

str_s3_cat=sum(str_s3,3)
str_s3_cat(logical(eye(268)))=NaN
remappingfreq_34=sum(str_s3_cat,2,'omitnan')./21
save('str_s3_cat.mat', 'str_s3_cat')

% session 3-4
str_s4=[];
for i=1:23
    if i==20
        continue
    end
    if i==12
        continue
    end
    str_s4=cat(3, str_s4, cell2mat(allswap_pairwise_stroke_sig(i,4)));
end

permu1=cell2mat(allswap_pairwise_stroke_sig(i,1));
figure('Position', [0 0 520 500])
imagesc(~permu1)
colormap gray

str_s4_cat=sum(str_s4,3)
str_s4_cat(logical(eye(268)))=NaN
remappingfreq_45=sum(str_s4_cat,2,'omitnan')./20
save('str_s4_cat.mat', 'str_s4_cat')



allremaps=str_s4_cat+str_s3_cat+str_s2_cat+str_s1_cat


save('allremaps_stroke.mat', 'allremaps')
save('allremaps_control.mat', 'allctl')


% set some to nan that have missing scans
remapping_23(20,:)=NaN
remapping_34(12,:)=NaN
remapping_34(20,:)=NaN
remapping_45(6,:)=NaN
remapping_45(12,:)=NaN
remapping_45(20,:)=NaN

%% Get remapping matrices (1/0)
order=1:268;

for j=1:23
    for i=1:268
        if (remapping_12(j,i)==order(i))
            remappings_12(j,i)=0;
        else
            remappings_12(j,i)=1;
        end
        if (remapping_23(j,i)==order(i))
            remappings_23(j,i)=0;
        else
            remappings_23(j,i)=1;
         end
         if (remapping_34(j,i)==order(i))
            remappings_34(j,i)=0;
         else
            remappings_34(j,i)=1;
         end
         if (remapping_45(j,i)==order(i))
            remappings_45(j,i)=0;
        else
            remappings_45(j,i)=1;
        end
    end
end

stroke_graphmatching(1).permutation_matrices = remappings_12
stroke_graphmatching(2).permutation_matrices = remappings_23
stroke_graphmatching(3).permutation_matrices = remappings_34
stroke_graphmatching(4).permutation_matrices = remappings_45

stroke_graphmatching(1).node_remapping_freq = remappingfreq_12
stroke_graphmatching(2).node_remapping_freq = remappingfreq_23
stroke_graphmatching(3).node_remapping_freq = remappingfreq_34
stroke_graphmatching(4).node_remapping_freq = remappingfreq_45

save(strcat(curr_dir, '/project/results/stroke_graphmatching_outputs.mat'), 'stroke_graphmatching')
%% NO ADJUSTMENT FOR CONTORL REMAPS 
data_dir=strcat(curr_dir, '/project/results/stroke/precision/');

alpha=0
beta=0
t=1
%without taking out ocntrol data
S1S2_np=load(strcat(data_dir, 'cols_S1S2_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S2S3_np=load(strcat(data_dir, 'cols_S2S3_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S3S4_np=load(strcat(data_dir, 'cols_S3S4_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S4S5_np=load(strcat(data_dir, 'cols_S4S5_alpha', num2str(alpha), '_beta', num2str(beta), '.txt')); % no regularization.
S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];

remapping_12=zeros(23,268);
remapping_23=zeros(23,268);
remapping_34=zeros(23,268);
remapping_45=zeros(23,268);

allswap_pairwise_stroke_sig=[]
% session 1-2
order=1:268;
allswap_pairwise_stroke={};
sub_indices=S1S2_np+1;

sig_remaps=[]

for i=1:23
    allswap_pairwise_stroke{i}=zeros(268,268);
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_stroke{i}(j,k)=allswap_pairwise_stroke{i}(j,k)+1;
            end
        end
    end
end

for i=1:23
    tmp=allswap_pairwise_stroke{i}; % 268x268
    remaps(i)=sum(sum(tmp))
    tmp_new=tmp
    allswap_pairwise_stroke_sig{i,1}=tmp_new;
    for k=1:268 % k = source node
        disp(k)
        try
            target = find(allswap_pairwise_stroke_sig{i,1}(k,:)==1)
            remapping_12(i,k)=target;
        catch
            remapping_12(i,k)=k;
        end
    end
    tmp2=allswap_pairwise_stroke_sig{i,1};
    tmp2(logical(eye(268)))=0;
    sig_remaps(i,1)=sum(sum(tmp2))
end

% session 2-3
order=1:268;
allswap_pairwise_stroke={};
sub_indices=S2S3_np+1;

for i=1:23
    allswap_pairwise_stroke{i}=zeros(268,268);
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_stroke{i}(j,k)=allswap_pairwise_stroke{i}(j,k)+1;
            end
        end
    end
end

for i=1:23
    tmp=allswap_pairwise_stroke{i}; % 268x268
    remaps(i)=sum(sum(tmp))
    tmp_new=tmp
    allswap_pairwise_stroke_sig{i,2}=tmp_new;
    for k=1:268 % k = source node
        disp(k)
        try
            target = find(allswap_pairwise_stroke_sig{i,2}(k,:)==1)
            remapping_23(i,k)=target;
        catch
            remapping_23(i,k)=k;
        end
    end
    tmp2=allswap_pairwise_stroke_sig{i,2};
    tmp2(logical(eye(268)))=0;
    sig_remaps(i,2)=sum(sum(tmp2))
end


% session 3-4
order=1:268;
allswap_pairwise_stroke={};
sub_indices=S3S4_np+1;

for i=1:23
    allswap_pairwise_stroke{i}=zeros(268,268);
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_stroke{i}(j,k)=allswap_pairwise_stroke{i}(j,k)+1;
            end
        end
    end
end

for i=1:23
    tmp=allswap_pairwise_stroke{i}; % 268x268
    remaps(i)=sum(sum(tmp))
    tmp_new=tmp
    allswap_pairwise_stroke_sig{i,3}=tmp_new;
    for k=1:268 % k = source node
        disp(k)
        try
            target = find(allswap_pairwise_stroke_sig{i,3}(k,:)==1)
            remapping_34(i,k)=target;
        catch
            remapping_34(i,k)=k;
        end
    end
    tmp2=allswap_pairwise_stroke_sig{i,3};
    tmp2(logical(eye(268)))=0;
    sig_remaps(i,3)=sum(sum(tmp2))
end

% session 4-5
order=1:268;
allswap_pairwise_stroke={};
sub_indices=S4S5_np+1;

for i=1:23
    allswap_pairwise_stroke{i}=zeros(268,268);
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise_stroke{i}(j,k)=allswap_pairwise_stroke{i}(j,k)+1;
            end
        end
    end
end

for i=1:23
    tmp=allswap_pairwise_stroke{i}; % 268x268
    remaps(i)=sum(sum(tmp))
    tmp_new=tmp
    allswap_pairwise_stroke_sig{i,4}=tmp_new;
    for k=1:268 % k = source node
        disp(k)
        try
            target = find(allswap_pairwise_stroke_sig{i,4}(k,:)==1)
            remapping_45(i,k)=target;
        catch
            remapping_45(i,k)=k;
        end
    end
    tmp2=allswap_pairwise_stroke_sig{i,4};
    tmp2(logical(eye(268)))=0;
    sig_remaps(i,4)=sum(sum(tmp2))
end



% session 1-2
str_s1=[];
for i=1:23
    str_s1=cat(3, str_s1, cell2mat(allswap_pairwise_stroke_sig(i,1)));
end

str_s1_cat=sum(str_s1,3)
str_s1_cat(logical(eye(268)))=NaN
remappingfreq_12=sum(str_s1_cat,2,'omitnan')./23

% session 2-3
str_s2=[];
for i=1:23
    if i==20
        continue
    end
    str_s2=cat(3, str_s2, cell2mat(allswap_pairwise_stroke_sig(i,2)));
end

str_s2_cat=sum(str_s2,3)
str_s2_cat(logical(eye(268)))=NaN
remappingfreq_23=sum(str_s2_cat,2,'omitnan')./22

% session 3-4
str_s3=[];
for i=1:23
    if i==20
        continue
    end
    if i==12
        continue
    end
    str_s3=cat(3, str_s3, cell2mat(allswap_pairwise_stroke_sig(i,3)));
end

str_s3_cat=sum(str_s3,3)
str_s3_cat(logical(eye(268)))=NaN
remappingfreq_34=sum(str_s3_cat,2,'omitnan')./21

% session 3-4
str_s4=[];
for i=1:23
    if i==20
        continue
    end
    if i==12
        continue
    end
    str_s4=cat(3, str_s4, cell2mat(allswap_pairwise_stroke_sig(i,4)));
end

permu1=cell2mat(allswap_pairwise_stroke_sig(i,1));
figure('Position', [0 0 520 500])
imagesc(~permu1)
colormap gray

str_s4_cat=sum(str_s4,3)
str_s4_cat(logical(eye(268)))=NaN
remappingfreq_45=sum(str_s4_cat,2,'omitnan')./20


% set some to nan that have missing scans
remapping_23(20,:)=NaN
remapping_34(12,:)=NaN
remapping_34(20,:)=NaN
remapping_45(6,:)=NaN
remapping_45(12,:)=NaN
remapping_45(20,:)=NaN

allremaps=str_s4_cat+str_s3_cat+str_s2_cat+str_s1_cat



data2=sum(allremaps, 'omitnan')
data2(1)=mean(data2)

data2=data2/max(data2)
allctl(logical(eye(268)))=NaN
data=sum(allctl, 'omitnan')
data1=data./max(data)

colormap(brewermap([], 'RdBu')) 
cmap=parula
gummi_remapfreq(data2-data1)

newallremaps=data2-data1

[rho, p]=corr(log(mean_chacovol(idx))', newallremaps(idx)')

%% is the difference in nodal remapping frequency related to structural disconnection? 

% load shen 268 network annotation
a=readmatrix('/Users/emilyolafson/GIT/stroke-graph-matching/project/shen_268_parcellation_networklabels.csv')
c=a(:,2);
colrs=jet(8);
colrs=[colrs(5:8,:); colrs(1:4,:)]
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});

i=4
idx=c==i;
[rho, p]=corr(newallremaps(idx)',log(mean_chacovol(idx))')
scatter(newallremaps(idx)',log(mean_chacovol(idx))', 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
b=polyfit(newallremaps(idx), log(mean_chacovol(idx)),1);
a=polyval(b,newallremaps(idx));
hold on;
plot(newallremaps(idx), a, '-r')   
xlabel('Difference in node remapping freq. stroke - control')
ylabel('median Log(ChaCo score')
set(gca, 'FontSize', 15)


figure()
for i=1:8
    idx=c==i;
    scatter(newallremaps(idx)',log(mean_chacovol(idx)), 40, colrs(i,:), 'filled', 'MarkerFaceAlpha', 0.8)
    hold on;
end

xlabel('Difference in node remapping freq. stroke - control')
ylabel('log(median ChaCo)')
title('All remaps')
ylim([-14, 0])
yticks([-14  -10 -6 -2 ])
yticklabels({'10^{-14}','10^{-10}','10^{-6}','10^{-2}'})
%text(0.05, -1, {['Rho: ', num2str(round(results.corr_w_chaco.s1s2.rho, 3))],['p = 0.002']}, 'FontSize', 15)
idz=isnan(newallremaps);
b=polyfit(newallremaps(~idz), log(mean_chacovol(~idz)),1);
a=polyval(b,newallremaps(~idz));
hold on;
plot(newallremaps(~idz), a, '-r')
set(gca, 'FontSize', 15)




