% Calculate remapping frequencies and display on Gummibrain.
close all;
clear all;
alpha=0
beta=1
threshold=1

curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/'

%load cast data in order to find indices that remap
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

%% 28andme
data_dir=strcat(curr_dir, 'data/28andme/results/regularized/')
a=readmatrix('/Users/emilyolafson/GIT/stroke-graph-matching/project/shen_268_parcellation_networklabels.csv')
c=a(:,2);
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
remaps28=sum(remappings_12)

%% combine all remaps from 28andme and cast dataset
remapsall=remaps28+remaps_cast
highremaps_ctl=remapsall>=threshold % cutoff for # of cast windows in which node is remapped


%% load stroke data
data_dir=strcat(curr_dir, '/project/results/precision/');

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

S1S2_np(highremaps_ctl)=NaN
S2S3_np(highremaps_ctl)=NaN
S3S4_np(highremaps_ctl)=NaN
S4S5_np(highremaps_ctl)=NaN


%% Get remapping matrices (1/0)
order=0:267; 
remappings_12=[]
remappings_23=[]
remappings_34=[];
remappings_45=[];
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
remappings_34(:,highremaps_ctl)=NaN
remappings_45(:,highremaps_ctl)=NaN

%% Calculate remap frequencies
sum12=sum(remappings_12,2, 'omitnan');
sum23=sum(remappings_23,2, 'omitnan');
sum34=sum(remappings_34,2, 'omitnan');
sum45=sum(remappings_45,2, 'omitnan');

sum23(20)=NaN;
sum34(12)=NaN;
sum34(20)=NaN;
sum45(20)=NaN;
sum45(12)=NaN;
sum45(6)=NaN;


%% Plot remap frequencies on gummibrain

gummi_remapfreq(sum12, 'Remap frequency Session 1 - Session 2')
gummi_remapfreq(sum23, 'Remap frequency Session 2 - Session 3')
gummi_remapfreq(sum34, 'Remap frequency Session 3 - Session 4')
gummi_remapfreq(sum45, 'Remap frequency Session 4 - Session 5')


