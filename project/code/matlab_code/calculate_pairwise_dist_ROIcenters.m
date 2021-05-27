% calculate pairwise euclidean distances betweeen ROI centers in Shen268
% atlas.

roicenters = atlasblobs_list(8).roicenters;

eucl_dist=zeros(268,268);

for i=1:268
    for j=1:268
        eucl_dist(i,j)=norm(roicenters(i)-roicenters(j));
    end
end

eucl_dist_norm=eucl_dist./max(max(eucl_dist))

plot_yeo(eucl_dist, 'Euclidean distances between mean centers of Shen268 nodes', 'summer', [0 100], 'r')
saveas(gcf,'results/pairwise_euclidean_dist_shen268nodes.png')
save('/Users/emilyolafson/GIT/stroke-graph-matching/results/pairwise_eucl_dist_shen268.mat', 'eucl_dist')
save('/Users/emilyolafson/GIT/stroke-graph-matching/results/pairwise_eucl_dist_shen268_normalized.mat', 'eucl_dist_norm')
