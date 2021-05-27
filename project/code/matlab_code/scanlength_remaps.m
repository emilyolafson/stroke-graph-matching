% Calculate the correlation between scan length and number of remaps
% between sessions

alpha=0; %old regularization method not used in paper.
beta=1;
threshold=1; 

curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/'


%% load cast data in order to find indices that remap
data_dir=strcat(curr_dir, '/cast_data/results/regularized/')
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
data_dir=strcat(curr_dir, '/28andme/results/regularized/')

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

%% length scan after motion censoring vs remaps

length=load('/Users/emilyolafson/GIT/stroke-graph-matching/data/lengthts.mat')
length=length.length_ts;

length(6, 5) =NaN
length(12,4)=NaN
length(12,5)=NaN
length(20,4)=NaN
length(20,3)=NaN
length(20,5)=NaN

length12=mean([length(:,1),length(:,2)],2);
length23=mean([length(:,2),length(:,3)],2);
length34=mean([length(:,3),length(:,4)],2);
length45=mean([length(:,4),length(:,5)],2);

lengtall=[length12;length23;length34;length45];

data_dir=strcat(curr_dir, '/project/results/precision/');
sum12=sum(remappings_12,2, 'omitnan');
sum23=sum(remappings_23,2, 'omitnan');
sum34=sum(remappings_34,2, 'omitnan');
sum45=sum(remappings_45,2, 'omitnan');

[rho, p(1)]=corr(length12, sum12, 'rows', 'complete')
[rho, p(2)]=corr(length23, sum23, 'rows', 'complete')
[rho, p(3)]=corr(length34, sum34, 'rows', 'complete')
[rho, p(4)]=corr(length45, sum45, 'rows', 'complete')

[pvals,c,d,adj_p]=fdr_bh(p, 0.05,'pdep')

