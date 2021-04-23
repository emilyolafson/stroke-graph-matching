% resample TRs.

load('/Users/emilyolafson/GIT/stroke-graph-matching/28andme/ts_shen.mat')

clear ts_resample
for i=1:30
    ts=ts_shen{i};
    
    ts_resample{i}=resample(ts', 1,4);
end

save('/Users/emilyolafson/GIT/stroke-graph-matching/28andme/ts_shen_resample.mat', 'ts_resample')