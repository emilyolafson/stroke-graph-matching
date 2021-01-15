% new figures  - instead of L/R split, contra/ipsilesional spltit
% heat map differences for regularization parameters
%Plot the heatmap of the remapping across each time point according to the
%Yeo networks.

curr_dir=pwd;

alphas = [0, 0.0025, 0.0075, 0.0125];
betas = [0, 0.0001, 0.0002, 0.0003];
rightlesion = [1,1,0,0,1,0,1,1,1,1,0,0 0,1,1,0,0,1,1,1,1,0,1];

data_dir=strcat(curr_dir, '/results/jupyter/precision/stroke/');


% right lesions
for d=1:4
    for q=1:4

        suffixes = {'alpha0', 'alpha1', 'alpha2', 'alpha3'};
        suffixes_2 = {'beta0', 'beta1', 'beta2', 'beta3'};
        suffix = strcat(char(suffixes(d)),'_',char(suffixes_2(q)));
        results_dir=strcat(curr_dir, '/results/jupyter/precision/stroke/', suffix, '/');

        S1S2_np=load(strcat(data_dir, 'cols_S1S2_', suffix, '.txt'));
        S2S3_np=load(strcat(data_dir, 'cols_S2S3_', suffix, '.txt'));
        S3S4_np=load(strcat(data_dir, 'cols_S3S4_', suffix, '.txt'));
        S4S5_np=load(strcat(data_dir, 'cols_S4S5_', suffix, '.txt'));

        S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
        S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
        S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];

        subjects=[1:23];
        rsub=subjects(logical(rightlesion));
        
        S1S2_npR=S1S2_np(rsub,:);
        S2S3_npR=S2S3_np(rsub,:);
        S3S4_npR=S3S4_np(rsub,:);
        S4S5_npR=S4S5_np(rsub,:);

        % Get remapping matrices (1/0)
        order=1:268;
        allswap_pairwise=zeros(268,268);
        sub_indices=S1S2_npR
        for i=1:14
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s2_s1_freq_right{d,q}=allswap_pairwise;

        allswap_pairwise=zeros(268,268);
        
        clear sub_indices;
        sub_indices=S2S3_npR;
        for i=1:14
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s3_s2_freq_right{d,q}=allswap_pairwise;
        allswap_pairwise=zeros(268,268);

        clear sub_indices;
        sub_indices=S3S4_npR;
        for i=1:14
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s4_s3_freq_right{d,q}=allswap_pairwise;
        
        allswap_pairwise=zeros(268,268);
        clear sub_indices;
        sub_indices=S4S5_npR;
        for i=1:14
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s5_s4_freq_right{d,q}=allswap_pairwise;
    end
end
% right lesions
for d=1:4
    for q=1:4
        all_sums_s1s2_right{d,q}=yeonetwork_remaps(norm_s2_s1_freq_right{d,q});
        all_sums_s2s3_right{d,q}=yeonetwork_remaps(norm_s3_s2_freq_right{d,q});
        all_sums_s3s4_right{d,q}=yeonetwork_remaps(norm_s4_s3_freq_right{d,q});
        all_sums_s4s5_right{d,q}=yeonetwork_remaps(norm_s5_s4_freq_right{d,q});
    end
end


% left lesions
for d=1:4
    for q=1:4
        
        suffixes = {'alpha0', 'alpha1', 'alpha2', 'alpha3'};
        suffixes_2 = {'beta0', 'beta1', 'beta2', 'beta3'};
        suffix = strcat(char(suffixes(d)),'_',char(suffixes_2(q)));
        results_dir=strcat(curr_dir, '/results/jupyter/precision/stroke/', suffix, '/');

        S1S2_np=load(strcat(data_dir, 'cols_S1S2_', suffix, '.txt'));
        S2S3_np=load(strcat(data_dir, 'cols_S2S3_', suffix, '.txt'));
        S3S4_np=load(strcat(data_dir, 'cols_S3S4_', suffix, '.txt'));
        S4S5_np=load(strcat(data_dir, 'cols_S4S5_', suffix, '.txt'));

        S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
        S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
        S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];

        subjects=[1:23];
        lsub=subjects(~logical(rightlesion));

        S1S2_npL=S1S2_np(lsub,:);
        S2S3_npL=S2S3_np(lsub,:);
        S3S4_npL=S3S4_np(lsub,:);
        S4S5_npL=S4S5_np(lsub,:);
        % Get remapping matrices (1/0)
        order=1:268;

        allswap_pairwise=zeros(268,268);
        sub_indices=S1S2_npL;
        for i=1:9
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s2_s1_freq_left{d,q}=allswap_pairwise;

        allswap_pairwise=zeros(268,268);
        
        clear sub_indices;
        sub_indices=S2S3_npL;
        for i=1:9
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s3_s2_freq_left{d,q}=allswap_pairwise;
        allswap_pairwise=zeros(268,268);

        clear sub_indices;
        sub_indices=S3S4_npL;
        for i=1:9
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s4_s3_freq_left{d,q}=allswap_pairwise;
        
        allswap_pairwise=zeros(268,268);
        clear sub_indices;
        sub_indices=S4S5_npL;
        for i=1:9
            for j=1:268
                for k=1:268
                    if sub_indices(i,j)==k-1
                        allswap_pairwise(j,k)=allswap_pairwise(j,k)+1;
                    end
                end
            end
        end
        norm_s5_s4_freq_left{d,q}=allswap_pairwise;
    end
end
% left lesions
for d=1:4
    for q=1:4
        all_sums_s1s2_left{d,q}=yeonetwork_remaps(norm_s2_s1_freq_left{d,q});
        all_sums_s2s3_left{d,q}=yeonetwork_remaps(norm_s3_s2_freq_left{d,q});
        all_sums_s3s4_left{d,q}=yeonetwork_remaps(norm_s4_s3_freq_left{d,q});
        all_sums_s4s5_left{d,q}=yeonetwork_remaps(norm_s5_s4_freq_left{d,q});
    end
end


%combine Left and Right into "Contralesional" versus "Ipsilesional"
for d=1:4 %alphas
    for q=1:4 %betas
        % all_sums row order: ll, rr, rl, lr
        combined{d,q}(1,:)=all_sums_s1s2_left{d,q}(1,:)+all_sums_s1s2_right{d,q}(2,:);%first row: ipsi-ipsi
        combined{d,q}(2,:)=all_sums_s1s2_left{d,q}(2,:)+all_sums_s1s2_right{d,q}(1,:);%second row: contra-contra
        combined{d,q}(3,:)=all_sums_s1s2_left{d,q}(4,:)+all_sums_s1s2_right{d,q}(3,:);%third row: ipsi-contra
        combined{d,q}(4,:)=all_sums_s1s2_left{d,q}(3,:)+all_sums_s1s2_right{d,q}(4,:);%fourth row: contra-ipsi
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
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s1s2{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s1s2{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s1s2{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s1s2{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s1s2{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s1s2{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s1s2{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s1s2{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s1s2{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s1s2{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s1s2{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s1s2{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s1s2{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s1s2{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s1s2{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Ipsi-Ipsi', 'Contra-Contra', 'Ipsi-Contra','Contra-Ipsi'})

sgtitle('S1-S2 off-diagonal swaps')


%% S2-S3
tiledlayout(4,4, 'padding', 'none')

% alpha = 0, beta = 0 
nexttile;
sums=all_sums_s2s3{1, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s2s3{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s2s3{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s2s3{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s2s3{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s2s3{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s2s3{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s2s3{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s2s3{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s2s3{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s2s3{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s2s3{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s2s3{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s2s3{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s2s3{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s2s3{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
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
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s3s4{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s3s4{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s3s4{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s3s4{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s3s4{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s3s4{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s3s4{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s3s4{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s3s4{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s3s4{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s3s4{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s3s4{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s3s4{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s3s4{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s3s4{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
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
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 1 
nexttile;
sums=all_sums_s4s5{1, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 0, beta = 2
nexttile;
sums=all_sums_s4s5{1, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 0, beta = 3
nexttile;
sums=all_sums_s4s5{1, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})


% alpha = 1, beta = 0
nexttile;
sums=all_sums_s4s5{2, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 1
nexttile;
sums=all_sums_s4s5{2, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 2
nexttile;
sums=all_sums_s4s5{2, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 1, beta = 3
nexttile;
sums=all_sums_s4s5{2, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 0
nexttile;
sums=all_sums_s4s5{3, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 1
nexttile;
sums=all_sums_s4s5{3, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 2
nexttile;
sums=all_sums_s4s5{3, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 2, beta = 3
nexttile;
sums=all_sums_s4s5{3, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 0
nexttile;
sums=all_sums_s4s5{4, 1};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 1
nexttile;
sums=all_sums_s4s5{4, 2};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 2
nexttile;
sums=all_sums_s4s5{4, 3};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

% alpha = 3, beta = 3
nexttile;
sums=all_sums_s4s5{4, 4};
imagesc(sums, [0 130])
colorbar;
xtickangle(40); set(gca,'FontSize', 10)
yticks(1:8)
xticks(1:8)
xticklabels(yeolabels)
yticklabels({'Left-left', 'Right-right', 'Right-left','Left-right'})

sgtitle('S4-S5 off-diagonal swaps')