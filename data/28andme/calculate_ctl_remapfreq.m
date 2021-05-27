%load parcellation nodes
a=readmatrix('/Users/emilyolafson/Documents/Thesis/shen_268_parcellation_networklabels.csv')
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});

[dx,s]=sort(a)

left_a=a(135:268,:);
[f,l]=sort(left_a);
for i=1:8
    size(i)=sum(i==f(:,2))
end
l=l(:,2)+134
right_a=a(1:134,:);
[~,r]=sort(right_a);
r=r(:,2)

xticks_aligned=[10,27,38,66,101,117,123,130];
xticks=[xticks_aligned,xticks_aligned+134];

yeo_labels=[r;l];
clear S1S2_np
clear S2S3_np
for i=1:5
    S1S2_np{i}=load(strcat('/Users/emilyolafson/Documents/Thesis/graph_matching/null_distributions/28andme/downsampled/list', num2str(i), '/cols_nopenalty_S1S2.txt'))+1
    S2S3_np{i}=load(strcat('/Users/emilyolafson/Documents/Thesis/graph_matching/null_distributions/28andme/downsampled/list', num2str(i), '/cols_nopenalty_S2S3.txt'))+1
end

% Get remapping matrices (1/0)
order=1:268;

allswap_pairwise=zeros(268,268);
for i=1:5
    sub_indices=S1S2_np{i};
    for j=1:268
        for k=1:268
            if sub_indices(j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s2_s1_freq=allswap_pairwise;

allswap_pairwise=zeros(268,268);
for i=1:5
    sub_indices=S2S3_np{i};
    for j=1:268
        for k=1:268
            if sub_indices(j)==k
                allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
            end
        end
    end
end
norm_s3_s2_freq=allswap_pairwise;


imagesc(norm_s2_s1_freq(yeo_labels,yeo_labels))
colormap hot
set(gca,'XTicklabels', yeolabels,'YTicklabels', yeolabels, 'XTick', xticks, 'YTick', xticks)
xline(19, 'w');xline(34, 'w');xline(42, 'w');xline(88, 'w');xline(113, 'w');xline(121, 'w');xline(126, 'w');xline(134, 'w');
xline(19+135, 'w');xline(34+135, 'w');xline(42+135, 'w');xline(88+135, 'w');xline(113+135, 'w');xline(121+135, 'w');xline(126+135, 'w');xline(134+134);
yline(19, 'w');yline(34, 'w');yline(42, 'w');yline(88, 'w');yline(113, 'w');yline(121, 'w');yline(126, 'w');yline(134, 'w');
yline(19+135, 'w');yline(34+135, 'w');yline(42+135, 'w');yline(88+135, 'w');yline(113+135, 'w');yline(121+135, 'w');yline(126+135, 'w');yline(134+134);
set(gca,'FontSize', 20)
xtickangle(45)
title('S1-S2 (day X - day X+7)')
ytickangle(45)


imagesc(norm_s3_s2_freq(yeo_labels,yeo_labels))
colormap hot
set(gca,'XTicklabels', yeolabels,'YTicklabels', yeolabels, 'XTick', xticks, 'YTick', xticks)
xline(19, 'w');xline(34, 'w');xline(42, 'w');xline(88, 'w');xline(113, 'w');xline(121, 'w');xline(126, 'w');xline(134, 'w');
xline(19+135, 'w');xline(34+135, 'w');xline(42+135, 'w');xline(88+135, 'w');xline(113+135, 'w');xline(121+135, 'w');xline(126+135, 'w');xline(134+134);
yline(19, 'w');yline(34, 'w');yline(42, 'w');yline(88, 'w');yline(113, 'w');yline(121, 'w');yline(126, 'w');yline(134, 'w');
yline(19+135, 'w');yline(34+135, 'w');yline(42+135, 'w');yline(88+135, 'w');yline(113+135, 'w');yline(121+135, 'w');yline(126+135, 'w');yline(134+134);
set(gca,'FontSize', 20)
xtickangle(45)
title('S2-S3 (day X - day X+16)')
ytickangle(45)
