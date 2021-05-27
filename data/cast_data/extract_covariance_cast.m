% for subject 2 and 3: downsample by a factor of 2. (TRs of 1.1s)
for i=1:3
    % convert timeseries to linear correlation & covariance
    if i==1
        nsess=9
    end
    if i==2
        nsess=12
    end
    if i==3
        nsess=14
    end
    for j=1:nsess
        if i==1 && j==1
            j=j+1
        end
        ts=load(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/cast_data/timeseries/sub',num2str(i),'_S', num2str(j), '_shen_GSR_short.mat'));
        ts=ts.avg
        ts=cell2mat(ts);
        if (i ==2 ) || (i ==3)
           ts=resample(ts, 1,2);
        end
        C=cov(ts);
        save(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/cast_data/covariance_short/sub', num2str(i),'_S', num2str(j), '_shen268_GSR_fc.mat'), 'C');
    end
end
