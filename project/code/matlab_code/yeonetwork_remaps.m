function [sums] = yeonetwork_remaps(remapping_freqs, curr_dir)
    % Calculates the number of remaps within and between Yeo networks
    % (separated by whether the lesion remaps from left to right, left to
    % left, right to right, and right to left).
    % used to generate figure 3 C, D in Fig3CD_Contra_Ipsi_Yeo_remaps.m
        
    a=readmatrix(strcat(curr_dir, '/project/shen_268_parcellation_networklabels.csv'));
    Lyeolabels=({'L - Medial frontal', 'L - Frontoparietal', 'L - Default mode', 'L - Subcortical-cerebellum','L - Motor', 'L - Visual I', 'L - Visual II','L - Visual association'});
    Ryeolabels=({'R - Medial frontal', 'R - Frontoparietal', 'R - Default mode', 'R - Subcortical-cerebellum','R - Motor', 'R - Visual I', 'R - Visual II','R - Visual association'});
    allyeolabels=[Ryeolabels,Lyeolabels];
    
    left_a=a(135:268,:);
    [tmpl,l]=sort(left_a);
    networksl = tmpl(:,2); % network assignment of LH ROIs
    l=l(:,2)+134;
    
    % number of ROIs in LH per network
    for i=1:8
        sizel(i)=sum(i==tmpl(:,2));
    end
    
    right_a=a(1:134,:);
    [tmpr,r]=sort(right_a);
    networksr = tmpr(:,2); % network assignment of RH ROIs
    r=r(:,2);
    
    yeo_labels=[r;l]; % ROIs ordered based on network assignment (R, L and within each R & L, networks 1-8)
    yeo_networks=[networksr; networksl];
    
    % number of ROIs in RH per network
    for i=1:8
        sizer(i)=sum(i==tmpr(:,2));
    end
    
    countr=sizer;
    countl=sizel;

    organized_matrix = remapping_freqs(yeo_labels,yeo_labels);
    organized_matrixll = organized_matrix(135:268,135:268);
    organized_matrixrr = organized_matrix(1:134,1:134);
    organized_matrixlr = organized_matrix(135:268,1:134);
    organized_matrixrl = organized_matrix(1:134,135:268);

    for i=1:8
        for j=1:8
            subnetwork = organized_matrixll(networksl==i, networksl==j);
            sum_networks_ll{i,j} = sum(sum(subnetwork));
            sum_networks_ll_offdiagonal{i,j} = sum(sum(subnetwork.*~eye(size(subnetwork))))/countl(i);
        end
    end
    for i=1:8
        for j=1:8
            subnetwork = organized_matrixrr(networksr==i, networksr==j);
            sum_networks_rr{i,j} = sum(sum(subnetwork));
            sum_networks_rr_offdiagonal{i,j} = sum(sum(subnetwork.*~eye(size(subnetwork))))/countr(i);
        end
    end   
    for i=1:8
        for j=1:8
            subnetwork = organized_matrixrl(networksr==i, networksl==j);
            sum_networks_rl{i,j} = sum(sum(subnetwork));
            sum_networks_rl_offdiagonal{i,j} = sum(sum(subnetwork.*~eye(size(subnetwork))))/countr(i);
        end
    end  
    for i=1:8
        for j=1:8
            subnetwork = organized_matrixlr(networksl==i, networksr==j);
            sum_networks_lr{i,j} = sum(sum(subnetwork));
            sum_networks_lr_offdiagonal{i,j} = sum(sum(subnetwork.*~eye(size(subnetwork))))/countl(i);
        end
    end  
    sums1=[sum_networks_rr_offdiagonal,sum_networks_rl_offdiagonal];
    sums2=[sum_networks_lr_offdiagonal,sum_networks_ll_offdiagonal];
    sums=[cell2mat(sums1);cell2mat(sums2)];
    
end
