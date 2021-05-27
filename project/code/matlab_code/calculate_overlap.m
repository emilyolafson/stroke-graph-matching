% calculate proportional overlap of each ROI with the lesion mask.
% (2mm MNI space)

setenv( 'FSLDIR', '/usr/local/fsl');
fsldir = getenv('FSLDIR');
fsldirmpath = sprintf('%s/etc/matlab',fsldir);
path(path, fsldirmpath);
clear fsldir fsldirmpath;

% load lesion masks.
for i=1:23
    lesionMask{i}=read_avw(strcat('/Users/emilyolafson/Documents/Thesis/graph_matching/overlap_w_lesion/SUB',num2str(i), '_lesion2mm.nii.gz'))
    lesionMask_reshape{i}=reshape(lesionMask{i}, [1 902629])
end

for i=1:23
    lesionMask{i}=read_avw(strcat('/Users/emilyolafson/Documents/Thesis/SUB1_23_data/lesionMasks_SUB1_23/SUB',num2str(i), '_lesion_1mmMNI.nii.gz'))
    lesionMask_reshape{i}=reshape(lesionMask{i}, [1 7221032])
end

% load parcellation.
shen268=read_avw(strat(curr_dir, 'data/shen_2mm_268_parcellation.nii')
shen_reshape=reshape(shen268,[1 902629]);

for i=1:268
    for j=1:23
        roi=shen_reshape==i;
        sizeroi=sum(roi);
        overlap=logical(roi).*logical(lesionMask_reshape{j});
        sum(overlap)
        proportion_overlap{i,j}=sum(overlap)/sizeroi;
    end
end

proportion_overlap=cell2mat(proportion_overlap)
imagesc(proportion_overlap')
colormap hot
set(gca,'FontSize', 20)
xlabel('Nodes (right/left)')
ylabel('Subjects')

mean_overlap=mean(proportion_overlap,2)

lesioncount=zeros(1,902629);
for j=1:902629
    for i=1:23
        subject=lesionMask_reshape{i};
        if subject(j)==1
            lesioncount(j)=lesioncount(j)+1;
        end
    end
end

lesioncount=reshape(lesioncount, [91 109 91]);
save_avw(lesioncount,'/Users/emilyolafson/Documents/Thesis/alllesionmasks.nii', 'f', [2 2 2 2])


lesioncount=zeros(1,7221032);
for j=1:7221032
    for i=1:23
        subject=lesionMask_reshape{i};
        if subject(j)==1
            lesioncount(j)=lesioncount(j)+1;
        end
    end
end

lesioncount=reshape(lesioncount, [182 218 182]);
save_avw(lesioncount,'/Users/emilyolafson/Documents/Thesis/alllesionmasks_1mm.nii', 'f', [1 1 1 2])


