 
load('ts_shen_resample.mat')

 %GSR required
for i=1:30
    ts=cell2mat(ts_resample(i));
    ts=ts; %time x ROIs
    meants=mean(ts,2); %mean across all gray matter voxels (i.e. where mask == 1)
    confounds=[meants [0; diff(meants)]]; %confounds list
    Q=eye(size(confounds,1))-confounds*pinv(confounds);
    ts_GSR=Q*(ts); %global signal regressed time series
   %ts_shen_GSR{i}=ts_GSR;
    ts_GSR=ts;
    C=cov(ts_GSR);
    save(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/28andme/covariance/cov_day', num2str(i), '.mat'), 'C')
end
