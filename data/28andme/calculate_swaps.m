
S1S2_np=load(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/28andme/results/cols_S1S2_alpha0.txt'))+1
S2S3_np=load(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/28andme/results/cols_S2S3_alpha0.txt'))+1

remappings12=[];
remappings23=[];

order=1:268;
for i=1:6
    for j=1:268
        disp(j)
        if (S1S2_np(i,j)==order(j))
            remappings12(i,j)=0;
        else
            remappings12(i,j)=1;
        end
         if (S2S3_np(i,j)==order(j))
            remappings23(i,j)=0;
        else
            remappings23(i,j)=1;
         end
    end
end

% display remappings across time for all subjects
figure(2);
tiledlayout(1,2)
nexttile;
imagesc(remappings12)
title('S1-S2')
ylabel('subject')
xlabel('Node')

nexttile;
imagesc(remappings23)
title('S2-S3')
ylabel('subject')
xlabel('Node')

allswap_pairwise=zeros(268,268);
sub_indices=S1S2_np;
for i=1:6
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s2_s1_freq=allswap_pairwise;

allswap_pairwise=zeros(268,268);

clear sub_indices;
sub_indices=S2S3_np;
for i=1:6
    for j=1:268
        for k=1:268
            if sub_indices(i,j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s3_s2_freq=allswap_pairwise;
allswap_pairwise=zeros(268,268);


figure('Position', [0 0 800 700])
plot_yeo(norm_s2_s1_freq, 'S1-S2 stroke pairwise remap frequencies', 'hot', [0 1], 'w')
h = colorbar;
set(get(h,'label'),'string','Number of subjects with remap');
saveas(gcf, strcat('/Users/emilyolafson/GIT/stroke-graph-matching/apaper/figs/28andme_remapping_matrices_S1S2.png'))
close all;

figure('Position', [0 0 800 700])
plot_yeo(norm_s3_s2_freq, 'S2-S3 stroke pairwise remap frequencies', 'hot', [0 1], 'w')
h = colorbar;
set(get(h,'label'),'string','Number of subjects with remap');
saveas(gcf, strcat('/Users/emilyolafson/GIT/stroke-graph-matching/apaper/figs/28andme_remapping_matrices_S2S3.png'))
close all;
