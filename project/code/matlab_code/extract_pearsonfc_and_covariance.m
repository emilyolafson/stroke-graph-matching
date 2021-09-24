% convert timeseries to linear correlation & covariance
nsess=[5;5;5;5;5;4;5;5;5;5;5;3;5;5;5;5;5;5;5;2;5;5;5]
nsess(24:47)=5;

for i=1:47
    for j=1:nsess(i)
        ts=load(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/data/timeseries/session', num2str(j),'/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR.mat'));
        ts=ts.avg;
        ts=cell2mat(ts);
        length_ts(i,j)=size(ts,1)
        C=corr(ts);
        save(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/data/pearson_fc/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR_fc.mat'), 'C');
    end
end

%save('/Users/emilyolafson/GIT/stroke-graph-matching/data/lengthts.mat', 'length_ts')
leng=[]
for i=1:23
    for j=1:nsess(i)
        ts=load(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/data/timeseries/session', num2str(j),'/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR.mat'));
        ts=ts.avg;
        ts=cell2mat(ts);
    
        C=corrcoef(ts);
        C_all{i,j}=C;
        save(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/data/pearson_fc/10min/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR_fc_cov.mat'), 'C');
    end
end

%save('/Users/emilyolafson/GIT/stroke-graph-matching/data/lengthts.mat', 'length_ts')
leng=[]
C_all=[]
for i=24:47
    nsess=5
    if i==6
        nsess=4
    end
    if i==12
        nsess=3
    end
    if i==20
        nsess=2
    end
    disp(i)
    for j=1:nsess
        disp(j)
        ts=load(strcat('/Users/emilyolafson/GIT/dynamic-brainstates/data/timeseries/SUB', num2str(i),'_S', num2str(j), '_shen_GSR.mat'));
        ts=ts.avg;
        ts=cell2mat(ts);       
        C=cov(ts);
        C_all{i,j}=C;
        save(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/data/covariance_may29/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR_fc_cov.mat'), 'C');
    end
end

for i=1:23
    imagesc(C_all{i,1})
    pause
end

all=load('/Users/emilyolafson/GIT/stroke-graph-matching/data/precision/10min/stroke/FCprec_concat_allsub.mat')
all=all.C;

for i=1:40
    imagesc(squeeze(all(i,:,:)))
    pause
end

all=load('/Users/emilyolafson/GIT/stroke-graph-matching/data/precision/FCprec_concat_allsub.mat')
all=all.C;
for i=1:40
    imagesc(squeeze(all(i,:,:)))
    pause
end




leng=[]
for i=1:23
    for j=1:nsess(i)
        ts=load(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/data/timeseries/session', num2str(j),'/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR.mat'));
        ts=ts.avg;
        ts=cell2mat(ts);
        disp(i)
        disp(j)
        
        C=cov(ts);
        C_all{i,j}=C;
        save(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/data/covariance/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR_fc_cov.mat'), 'C');
    end
end