
curr_dir=pwd;
costdir=strcat(curr_dir, '/data/precision/')

cost_all = load(strcat(costdir, '[0, 1]costmatrix.mat'));
cost_all = cost_all.cost_matrix;

tiledlayout(6,4, 'padding', 'none')
for i=1:24
    nexttile;
    sub=cost_all(i, :, :);
    histogram(sub)
    xlim([0 1])
    ylim([0 9000])
    title(['subject: ', num2str(i)])
    xlabel('Euclildean distance')
    ylabel('Count')
    
    sub=squeeze(sub);
    sub=reshape(sub, [268*268, 1]);
    stdev_ctl_12(i)=std(sub);
    
end
sgtitle('Controls - S1-S2')
saveas(gcf, strcat(costdir, 'controls-s1-s2-eucdlid_dist.png'))

%% 
cost_all = load(strcat(costdir, '[1, 2]costmatrix.mat'));
cost_all = cost_all.cost_matrix;

tiledlayout(6,4, 'padding', 'none')
for i=1:24
    nexttile;
    sub=cost_all(i, :, :);
    histogram(sub)
    xlim([0 1])
    ylim([0 9000])
    title(['subject: ', num2str(i)])
    xlabel('Euclildean distance')
    ylabel('Count')
    
    
    sub=squeeze(sub);
    sub=reshape(sub, [268*268, 1]);
    stdev_ctl_23(i)=std(sub);
    
end
sgtitle('Controls - S2-S3')
saveas(gcf, strcat(costdir, 'controls-s2-s3-eucdlid_dist.png'))

%%
cost_all = load(strcat(costdir, '[2, 3]costmatrix.mat'));
cost_all = cost_all.cost_matrix;

tiledlayout(6,4, 'padding', 'none')
for i=1:24
    nexttile;
    sub=cost_all(i, :, :);
    histogram(sub)
    xlim([0 1])
    ylim([0 9000])
    title(['subject: ', num2str(i)])
    xlabel('Euclildean distance')
    ylabel('Count')
    
    sub=squeeze(sub);
    sub=reshape(sub, [268*268, 1]);
    stdev_ctl_34(i)=std(sub);
end
sgtitle('Controls - S3-S4')
saveas(gcf, strcat(costdir, 'controls-s3-s4-eucdlid_dist.png'))

%%
cost_all = load(strcat(costdir, '[3, 4]costmatrix.mat'));
cost_all = cost_all.cost_matrix;

tiledlayout(6,4, 'padding', 'none')
for i=1:24
    nexttile;
    sub=cost_all(i, :, :);
    histogram(sub)
    xlim([0 1])
    ylim([0 9000])
    title(['subject: ', num2str(i)])
    xlabel('Euclildean distance')
    ylabel('Count')
    
    sub=squeeze(sub);
    sub=reshape(sub, [268*268, 1]);
    stdev_ctl_45(i)=std(sub);
end
sgtitle('Controls - S4-S5')
saveas(gcf, strcat(costdir, 'controls-s4-s5-eucdlid_dist.png'))



%% STROKE

curr_dir=pwd;
costdir=strcat(curr_dir, '/data/precision/')

cost_all = load(strcat(costdir, '[0, 1]costmatrix_stroke.mat'));
cost_all = cost_all.cost_matrix;

tiledlayout(6,4, 'padding', 'none')
counter=1;
for i=1:23
    nexttile;
    sub=cost_all(counter, :, :);
    histogram(sub)
   
    counter=counter+1;

    xlim([0 1])
    ylim([0 9000])
    title(['subject: ', num2str(i)])
    xlabel('Euclildean distance')
    ylabel('Count')
    sub=squeeze(sub);
    sub=reshape(sub, [268*268, 1]);
    stdev_str_12(i)=std(sub);
end
sgtitle('Stroke - S1-S2')
saveas(gcf, strcat(costdir, 'stroke-s1-s2-eucdlid_dist.png'))

%% 

cost_all = load(strcat(costdir, '[1, 2]costmatrix_stroke.mat'));
cost_all = cost_all.cost_matrix;

tiledlayout(6,4, 'padding', 'none')
counter=1;

for i=1:23
    nexttile;
    if i==20
        plot(0);
        title(['subject: ', num2str(i)])
        counter=counter-1;
        continue
    end
    sub=cost_all(counter, :, :);
    histogram(sub)
   
    counter=counter+1;

    xlim([0 1])
    ylim([0 9000])
    title(['subject: ', num2str(i)])
    xlabel('Euclildean distance')
    ylabel('Count')
    sub=squeeze(sub);
    sub=reshape(sub, [268*268, 1]);
    stdev_str_23(i)=std(sub);
end
sgtitle('Stroke - S2-S3')
saveas(gcf, strcat(costdir, 'stroke-s2-s3-eucdlid_dist.png'))

%%
cost_all = load(strcat(costdir, '[2, 3]costmatrix_stroke.mat'));
cost_all = cost_all.cost_matrix;

tiledlayout(6,4, 'padding', 'none')
counter=1;

for i=1:23
    nexttile;
    if i==12
        plot(0);
        title(['subject: ', num2str(i)])
        counter=counter-1;
        continue
    end
    if i==20
        plot(0);
        title(['subject: ', num2str(i)])
        counter=counter-1;
        continue
    end
    sub=cost_all(counter, :, :);
    histogram(sub)
   
    counter=counter+1;

    xlim([0 1])
    ylim([0 9000])
    title(['subject: ', num2str(i)])
    xlabel('Euclildean distance')
    ylabel('Count')
    sub=squeeze(sub);
    sub=reshape(sub, [268*268, 1]);
    stdev_str_34(i)=std(sub);
end
sgtitle('Stroke - S3-S4')
saveas(gcf, strcat(costdir, 'stroke-s3-s4-eucdlid_dist.png'))

%%
cost_all = load(strcat(costdir, '[3, 4]costmatrix_stroke.mat'));
cost_all = cost_all.cost_matrix;

tiledlayout(6,4, 'padding', 'none')
counter=1;
for i=1:23
    nexttile;
    
    if i==6
        plot(0);
        title(['subject: ', num2str(i)])
        counter=counter-1;
        continue
    end
    if i==12
        plot(0);
        title(['subject: ', num2str(i)])
        counter=counter-1;
        continue
    end
    if i==20
        plot(0);
        title(['subject: ', num2str(i)])
        counter=counter-1;
        continue
    end
    sub=cost_all(counter, :, :);
    histogram(sub)
   
    counter=counter+1;

    xlim([0 1])
    ylim([0 9000])
    title(['subject: ', num2str(i)])
    xlabel('Euclildean distance')
    ylabel('Count')
    sub=squeeze(sub);
    sub=reshape(sub, [268*268, 1]);
    stdev_str_45(i)=std(sub);
end
sgtitle('Stroke - S4-S5')
saveas(gcf, strcat(costdir, 'stroke-s4-s5-eucdlid_dist.png'))


%% 
figure(2)
tiledlayout(1,2, 'padding', 'none')
nexttile;
labels={'S1-S2', 'S2-S3', 'S3-S4', 'S4-S5'}
violinplot([stdev_str_12; stdev_str_23;stdev_str_34;stdev_str_45]', labels)
title('Stroke')
ylabel('Standard deviation of euclidean distances')
set(gca, 'FontSize', 20)

nexttile;
violinplot([stdev_ctl_12; stdev_ctl_23;stdev_ctl_34;stdev_ctl_45]',labels)
title('Controls')
ylabel('Standard deviation of euclidean distances')
set(gca, 'FontSize', 20)
saveas(gcf, strcat(costdir, 'stroke-control-diff-stdev-eucdlid_dist.png'))


[~, p]= ttest2(stdev_str_12, stdev_ctl_12)
[~, p]= ttest2(stdev_str_23, stdev_ctl_23)
[~, p]= ttest2(stdev_str_34, stdev_ctl_34)
[~, p]= ttest2(stdev_str_45, stdev_ctl_45)


%% 
% in controls for each subject
% calculate the amount of reduction in 'cost' for mapping to new node relative to mapping to
% itself.
% get a null distribution across all nodes?

curr_dir=pwd;
datadir=strcat(curr_dir, '/results/jupyter/precision/control/');
costdir=strcat(curr_dir, '/data/precision/')

S1S2_np=load(strcat(datadir, 'cols_S1S2.txt'));
S2S3_np=load(strcat(datadir, 'cols_S2S3.txt'));
S3S4_np=load(strcat(datadir, 'cols_S3S4.txt'));
S4S5_np=load(strcat(datadir, 'cols_S4S5.txt'));
S1S2_remapfreq=load(strcat(datadir, 'roichanges_S1S2.txt'));
S2S3_remapfreq=load(strcat(datadir, 'roichanges_S2S3.txt'));
S3S4_remapfreq=load(strcat(datadir, 'roichanges_S3S4.txt'));
S4S5_remapfreq=load(strcat(datadir, 'roichanges_S4S5.txt'));
order=0:267;

for j=1:24
    for i=1:268
        if (S1S2_np(j,i)==order(i))
            remappings_12(j,i)=0;
        else
            remappings_12(j,i)=1;
        end
         if (S2S3_np(j,i)==order(i))
            remappings_23(j,i)=0;
        else
            remappings_23(j,i)=1;
         end
         if (S3S4_np(j,i)==order(i))
            remappings_34(j,i)=0;
         else
            remappings_34(j,i)=1;
         end
         if (S4S5_np(j,i)==order(i))
            remappings_45(j,i)=0;
        else
            remappings_45(j,i)=1;
        end
    end
end

cost_all = load(strcat(costdir, '[0, 1]costmatrix.mat'));
cost_all=cost_all.cost_matrix;

for i=1:24
    remaps=logical(remappings_12(i,:));
    mappings=S1S2_np(i,:)+1;
    cost_sub=squeeze(cost_all(i,:,:));
    cost_noswaps=cost_sub(logical(eye(268)));
    for k=1:268
        disp(k)
        disp(mappings(k))
        disp('next')
        cost_swaps(k)=cost_sub(k,mappings(k));
    end
    deltas_all=cost_noswaps-cost_swaps';
    deltas{i}=deltas_all(remaps);
end
deltas{2}=zeros(3,1);
%% 
tiledlayout(6,4,'padding', 'none')
for i=1:24
    nexttile;
    histogram(deltas{i})
    xlabel('Change in euclidean dist. from swap')
    ylabel('Count')
    title(strcat('Subject', num2str(i)))
end


