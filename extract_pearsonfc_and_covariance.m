% convert timeseries to linear correlation & covariance
for i=1:47
    for j=1:nsess(i)
        ts=load(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/timeseries/session', num2str(j),'/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR.mat'));
        ts=ts.avg;
        ts=cell2mat(ts);
        C=corrcoef(ts);
        save(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/pearson_fc/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR_fc.mat'), 'C');
    end
end

for i=1:47
    for j=1:nsess(i)
        ts=load(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/timeseries/session', num2str(j),'/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR.mat'));
        ts=ts.avg;
        ts=cell2mat(ts);
        C=cov(ts);
        save(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/covariance/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR_fc_cov.mat'), 'C');
    end
end


