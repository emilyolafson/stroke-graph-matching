%calculate regularized precision matrices.

nsess=[5;5;5;5;5;4;5;5;5;5;5;3;5;5;5;5;5;5;5;2;5;5;5]
nsess(24:47)=5;

gamma=[0:0.02:1];

%calculate group unregularized precision matrix.
unreg_precision=[];
for i=4:47
    for j=1:nsess(i)
        ts=load(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/session', num2str(j),'/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR.mat'));
        ts=cell2mat(ts.avg);
        C=corrcoef(ts);
        save(strcat('/Users/emilyolafson/GIT/stroke-graph-matching/session', num2str(j),'/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR.mat'),'C');
        %correlation=corr(ts);
        %identity=eye(268);
        %unreg_precision=cat(3,unreg_precision, inv(correlation));
    end
end

precision_mean=mean(unreg_precision,3)


%We have N subjects, and for each subject, we have d parcels. 
% In the case of optimization of the regularising parameters, we first calculated the difference between the 
% regularized subject precision matrices and the group average of the unregularised subject
% precision matrices. Then, we calculated the sum of the resulting matrices (after squaring matrix elements),
% and obtained a  resulting matrix. Then, we summed up the elements in the upper triangular of the resulting matrix, 
% and lastly computed the square root.
% (root mean square distance)

reg_precision=[];
dist=[];
distances=[];
for k=1:length(gamma)
    reg_precision=[];
    reg_stored=[];
    
    distance=[];
    disp(gamma(k))
    for i=1:3
        for j=1:nsess(i)
            ts=load(strcat('/Users/emilyolafson/Documents/Thesis/session', num2str(j),'/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR.mat'));
            ts=cell2mat(ts.avg);
            correlation=corr(ts);
            identity=eye(268);
            reg_precision=inv(correlation+gamma(k).*identity)*(-1);
            reg_stored=cat(3,reg_stored,reg_precision);
           % distance to mean precision matrix
            dist=cat(3,dist,norm(reg_precision-precision_mean, 'fro'));
        end
    end
    distances{k}=dist;
    dist=[]
end

for i=1:3
    tmp=squeeze(distances{i})
    distances_allsub(i)=sum(tmp)
end

plot(distances_allsub(2:51))
xlabel('Gamma')
ylabel('Sum of frobenius norm across all scans')
set(gca, 'FontSize', 20)

[num,idx]=min(distances_allsub)
disp(gamma(idx))




% Generate regularized precision matrices with variable of interest.
for i=1:23
    for j=1:nsess(i)
        ts=load(strcat('/Users/emilyolafson/Documents/Thesis/SUB1_23_data/session', num2str(j),'/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR.mat'));
        ts=cell2mat(ts.avg);
        covariance=cov(ts);
        identity=eye(268);
        reg_precision=inv(covariance+gamma(idx).*identity);
        reg_precision(logical(identity))=0;
        partialcorr{i,j}=reg_precision;
    end
end
 
save(strcat('/Users/emilyolafson/Documents/Thesis/SUB1_23_data/FCprecision.mat'), 'partialcorr')

for i=24:47
    for j=1:nsess(i)
        ts=load(strcat('/Users/emilyolafson/Documents/Thesis/SUB1_23_data/session', num2str(j),'/SUB', num2str(i),'_S', num2str(j), '_shen268_GSR.mat'));
        ts=cell2mat(ts.avg);
        covariance=cov(ts);
        identity=eye(268);
        reg_precision=inv(covariance+gamma(idx).*identity);
        reg_precision(logical(identity))=0;
        partialcorr{i,j}=reg_precision;
    end
end
 
save(strcat('/Users/emilyolafson/Documents/Thesis/SUB24_47_data/FCprecision.mat'), 'partialcorr')



%% plot FC precision vs linear
ts=load(strcat('/Users/emilyolafson/Documents/Thesis/SUB1_23_data/session2/SUB1_S2_shen268_GSR.mat'));
ts=cell2mat(ts.avg);
covariance=cov(ts);
identity=eye(268);
reg_precision=inv(covariance+gamma(idx).*identity);
reg_precision(logical(identity))=0;
correlation=corr(ts);
correlation(logical(identity))=0;

figure(1)
plot_yeo(reg_precision, 'Single Subject precision', 'jet')
figure(3)
plot_yeo(correlation, 'Single Subject correlation', 'jet')
