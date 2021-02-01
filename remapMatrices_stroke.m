
%Plot the heatmap of the remapping across each time point according to the
%Yeo networks.

curr_dir=pwd;

data_dir=strcat(curr_dir, '/results/jupyter/precision/stroke/');
alphas = [0, 0.0025, 0.0075, 0.0125];
betas = [0, 0.0001, 0.0002, 0.0003];

we wfor d=1
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
        norm_s2_s1_freq=allswap_pairwise;

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
        norm_s3_s2_freq=allswap_pairwise;
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
        norm_s4_s3_freq=allswap_pairwise;
        
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
        norm_s5_s4_freq=allswap_pairwise;

        figure('Position', [0 0 700 700])
        plot_yeo(norm_s2_s1_freq, 'S1-S2 stroke pairwise remap frequencies', 'hot', [0 3], 'w')
        saveas(gcf, strcat(results_dir, 'figures/remapping_matrices_S1S2.png'))
        close all;

        figure('Position', [0 0 700 700])
        plot_yeo(norm_s3_s2_freq, 'S2-S3 stroke pairwise remap frequencies', 'hot', [0 3], 'w')
        saveas(gcf, strcat(results_dir, 'figures/remapping_matrices_S2S3.png'))
        close all;

        figure('Position', [0 0 700 700])
        plot_yeo(norm_s4_s3_freq, 'S3-S4 stroke pairwise remap frequencies', 'hot', [0 3], 'w')
        saveas(gcf, strcat(results_dir, 'figures/remapping_matrices_S3S4.png'))
        close all;

        figure('Position', [0 0 700 700])
        plot_yeo(norm_s5_s4_freq, 'S4-S5 stroke pairwise remap frequencies', 'hot', [0 3], 'w')
        saveas(gcf, strcat(results_dir, 'figures/remapping_matrices_S4S5.png'))
        close all;

    end
end

clear norm_s2_s1_freq
clear norm_s3_s2_freq
clear norm_s4_s3_freq
clear norm_s5_s4_freq
