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
shen268=read_avw('/Users/emilyolafson/Documents/Thesis/graph_matching/overlap_w_lesion/shen_2mm_268_parcellation.nii')
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

S1S2_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/roichanges_nopenalty_S1S2.txt')
%S1S2_np=S1S2_np.remap_freq1;
S2S3_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/roichanges_nopenalty_S2S3.txt')
%S2S3_np=S2S3_np.remap_freq2;
S3S4_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/roichanges_nopenalty_S3S4.txt')
%S3S4_np=S3S4_np.remap_freq3;
S4S5_np=load('/Users/emilyolafson/Documents/Thesis/graph_matching/roichanges_nopenalty_S4S5.txt')

tiledlayout(2,2,'padding','none')
nexttile;
plot(S1S2_np,mean_overlap, '*r')
[rho,p]=corr(mean_overlap, S1S2_np)
b=polyfit(S1S2_np,mean_overlap,1);
a=polyval(b,S1S2_np);
hold on;
plot(S1S2_np, a, '-b')
ylabel('Mean proportion overlap with lesion')
xlabel('Remapping frequency')
title('S1-S2')
ylim([-0.001 0.03])
set(gca,'FontSize', 20)

nexttile;
plot(S2S3_np,mean_overlap, '*r')
[rho,p]=corr(mean_overlap, S2S3_np)
b=polyfit(S2S3_np,mean_overlap,1);
a=polyval(b,S2S3_np);
hold on;
plot(S2S3_np, a, '-b')
ylabel('Mean proportion overlap with lesion')
xlabel('Remapping frequency')
title('S2-S3')
ylim([-0.001 0.03])
set(gca,'FontSize', 20)


nexttile;
plot(S3S4_np,mean_overlap, '*r')
[rho,p]=corr(mean_overlap, S3S4_np)
b=polyfit(S3S4_np,mean_overlap,1);
a=polyval(b,S3S4_np);
hold on;
plot(S3S4_np, a, '-b')
ylabel('Mean proportion overlap with lesion')
xlabel('Remapping frequency')
title('S3-S4')
ylim([-0.001 0.03])
set(gca,'FontSize', 20)

nexttile;
plot(S4S5_np,mean_overlap, '*r')
[rho,p]=corr(mean_overlap, S4S5_np)
b=polyfit(S4S5_np,mean_overlap,1);
a=polyval(b,S4S5_np);
hold on;
plot(S4S5_np, a, '-b')
ylabel('Mean proportion overlap with lesion')
xlabel('Remapping frequency')
title('S4-S5')
ylim([-0.001 0.03])
set(gca,'FontSize', 20)

allremapfreq=mean([S1S2_np,S2S3_np,S3S4_np,S4S5_np],2)
plot(mean_overlap, allremapfreq, '*r')
[rho,p]=corr(mean_overlap, allremapfreq, 'Type', 'Spearman')

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


