% convert timeseries to linear correlation & covariance
nsess=[5;5;5;5;5;4;5;5;5;5;5;3;5;5;5;5;5;5;5;2;5;5;5]
nsess(24:47)=5;

for i=1:23
    for j=1:nsess(i)
        ts=load(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/data/timeseries/session', num2str(j),'/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR.mat'));
        ts=ts.avg;
        ts=cell2mat(ts);
        C=corrcoef(ts);
        save(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/data/pearson_fc/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR_fc.mat'), 'C');
    end
end

for i=1:23
    for j=1:nsess(i)
        ts=load(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/data/pearson_fc/5min/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR_short.mat'));
        ts=ts.newscan;
        C=cov(ts);
        save(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/data/covariance/5min/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR_fc_cov.mat'), 'C');
    end
end


