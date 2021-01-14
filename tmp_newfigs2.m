% new figures;
% heat map differences for regularization parameters
%Plot the heatmap of the remapping across each time point according to the
%Yeo networks.

curr_dir=pwd;

data_dir=strcat(curr_dir, '/results/jupyter/precision/stroke/');
alphas = [0, 0.0025, 0.0075, 0.0125];
betas = [0, 0.0001, 0.0002, 0.0003];

for d=1:4
    for q=1:4
        suffixes = {'alpha0', 'alpha1', 'alpha2', 'alpha3'};
        suffixes_2 = {'beta0', 'beta1', 'beta2', 'beta3'};
        suffix = strcat(char(suffixes(d)),'_',char(suffixes_2(q)));

        S1S2_np=load(strcat(data_dir, 'cols_S1S2_', suffix, '.txt'));
        S2S3_np=load(strcat(data_dir, 'cols_S2S3_', suffix, '.txt'));
        S3S4_np=load(strcat(data_dir, 'cols_S3S4_', suffix, '.txt'));
        S4S5_np=load(strcat(data_dir, 'cols_S4S5_', suffix, '.txt'));

        results_dir=strcat(curr_dir, '/results/jupyter/precision/stroke/', suffix, '/');

        % Get remapping matrices (1/0)
        order=1:268;

        allswap_pairwise=zeros(268,268);
        sub_indices=S1S2_np;
        for i=1:23
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s2_s1_freq{d,q}=allswap_pairwise;

        allswap_pairwise=zeros(268,268);
        
        clear sub_indices;
        sub_indices=S2S3_np;
        for i=1:22
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s3_s2_freq{d,q}=allswap_pairwise;
        allswap_pairwise=zeros(268,268);

        clear sub_indices;
        sub_indices=S3S4_np;
        for i=1:21
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s4_s3_freq{d,q}=allswap_pairwise;
        
        allswap_pairwise=zeros(268,268);
        clear sub_indices;
        sub_indices=S4S5_np;
        for i=1:20
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s5_s4_freq{d,q}=allswap_pairwise;
    end
end

for d=1:4
    for q=1:4
        all_sums_s1s2{d,q}=yeonetwork_remaps(norm_s2_s1_freq{d,q});
        all_sums_s2s3{d,q}=yeonetwork_remaps(norm_s3_s2_freq{d,q});
        all_sums_s3s4{d,q}=yeonetwork_remaps(norm_s4_s3_freq{d,q});
        all_sums_s4s5{d,q}=yeonetwork_remaps(norm_s5_s4_freq{d,q});
    end
end

%% differences in remap patterns across alphas (rows, :)
% want to capture remap sums across 8*4 networks and with each alpha.
% just go one at a time.
yeolabels=({'Medial frontal', 'Frontoparietal', 'Default mode', 'Subcortical-cerebellum','Motor', 'Visual I', 'Visual II','Visual association'});
tiledlayout(4,4, 'padding', 'none')

% alpha = 0, beta = 0 
nexttile;
sums=all_sums_s1s2{1, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s1s2{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s1s2{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s1s2{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s1s2{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s1s2{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s1s2{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s1s2{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s1s2{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s1s2{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s1s2{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s1s2{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s1s2{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s1s2{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s1s2{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s1s2{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

sgtitle('S1-S2 off-diagonal swaps')


%% S2-S3
tiledlayout(4,4, 'padding', 'none')

% alpha = 0, beta = 0 
nexttile;
sums=all_sums_s2s3{1, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s2s3{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s2s3{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s2s3{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s2s3{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s2s3{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s2s3{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s2s3{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s2s3{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s2s3{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s2s3{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s2s3{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s2s3{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s2s3{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s2s3{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s2s3{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

sgtitle('S2-S3 off-diagonal swaps')


%% S3S4
tiledlayout(4,4, 'padding', 'none')

% alpha = 0, beta = 0 
nexttile;
sums=all_sums_s3s4{1, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s3s4{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s3s4{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s3s4{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s3s4{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s3s4{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s3s4{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s3s4{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s3s4{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s3s4{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s3s4{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s3s4{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s3s4{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s3s4{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s3s4{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s3s4{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

sgtitle('S3-S4 off-diagonal swaps')


%% S4-S5
tiledlayout(4,4, 'padding', 'none')

% alpha = 0, beta = 0 
nexttile;
sums=all_sums_s4s5{1, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s4s5{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s4s5{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s4s5{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s4s5{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s4s5{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s4s5{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s4s5{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s4s5{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s4s5{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s4s5{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s4s5{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s4s5{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s4s5{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s4s5{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s4s5{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(20); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

sgtitle('S4-S5 off-diagonal swaps')