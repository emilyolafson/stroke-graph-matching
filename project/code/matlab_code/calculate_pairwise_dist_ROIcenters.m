% calculate pairwise euclidean distances betweeen ROI centers in Shen268
% atlas.
load('/Users/emilyolafson/GIT/stroke-graph-matching/data/atlasblobs.mat', 'atlasblobs_list')
roicenters = atlasblobs_list(8).roicenters;

eucl_dist=zeros(268,268);

for i=1:268
    for j=1:268
        eucl_dist(i,j)=norm(roicenters(i)-roicenters(j));
    end
end

save('/Users/emilyolafson/GIT/stroke-graph-matching/data/pairwise_eucl_dist_shen268.mat', 'eucl_dist')
