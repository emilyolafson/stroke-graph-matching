function [overlap_log, overlap_prop] = calculate_overlap_lesion_atlas()
% calculate lesion overlap with each node of the Shen268 atlas to exclude
% them from calculation of ChaCo scores. 

for i=1:23
    lesion=read_avw(sprintf('/Users/emilyolafson/GIT/stroke-graph-matching/data/lesions/SUB%i_lesion2mm.nii.gz', i));
    les{i}=reshape(lesion, 902629, []);
end

atlas=read_avw('/Users/emilyolafson/GIT/stroke-graph-matching/data/shen_2mm_268_parcellation.nii.gz');
atlas=reshape(atlas, 902629, []);

for t=1:size(unique(atlas))-1
    region=atlas==t; % only 1's in ROI t
    for i=1:23
        overlap(i,t)=sum(region.*les{i});
        overlap_prop(i,t)=sum(region.*les{i})/sum(region);
    end
end

%overlap_log=logical(overlap);
overlap_log=logical(overlap);
overlap_prop=overlap_prop;
end

