function [sums] = yeonetwork_remaps(remapping_freqs)
    % 16 total networks (left and right separated)
    a=readmatrix(strcat(pwd, '/project/shen_268_parcellation_networklabels.csv'));
    Lyeolabels=({'L - Medial frontal', 'L - Frontoparietal', 'L - Default mode', 'L - Subcortical-cerebellum','L - Motor', 'L - Visual I', 'L - Visual II','L - Visual association'});
    Ryeolabels=({'R - Medial frontal', 'R - Frontoparietal', 'R - Default mode', 'R - Subcortical-cerebellum','R - Motor', 'R - Visual I', 'R - Visual II','R - Visual association'});
    allyeolabels=[Ryeolabels,Lyeolabels];
    
    left_a=a(135:268,:);
    [f,l]=sort(left_a);
    networksl = f(:,2);
    for i=1:8
        sizez(i)=sum(i==f(:,2));
    end
    l=l(:,2)+134;
    right_a=a(1:134,:);
    [h,r]=sort(right_a);
    networksr = h(:,2);
    r=r(:,2);
    
    yeo_labels=[r;l];
    yeo_networks=[networksr; networksl];
    for i=1:8
        count{i}=sum(double(networksr==i))
    end
    count=cell2mat(count);
    
    organized_matrix = remapping_freqs(yeo_labels,yeo_labels);
    organized_matrixll = organized_matrix(135:268,135:268);
    organized_matrixrr = organized_matrix(1:134,1:134);
    organized_matrixlr = organized_matrix(135:268,1:134);
    organized_matrixrl = organized_matrix(1:134,135:268);

    for i=1:8
        for j=1:8
            subnetwork = organized_matrixll(networksl==i, networksl==j);
            sum_networks_ll{i,j} = sum(sum(subnetwork));
            sum_networks_ll_offdiagonal{i,j} = sum(sum(subnetwork.*~eye(size(subnetwork))))/count(i);
        end
    end
    for i=1:8
        for j=1:8
            subnetwork = organized_matrixrr(networksr==i, networksr==j);
            sum_networks_rr{i,j} = sum(sum(subnetwork));
            sum_networks_rr_offdiagonal{i,j} = sum(sum(subnetwork.*~eye(size(subnetwork))))/count(i);
        end
    end   
    for i=1:8
        for j=1:8
            subnetwork = organized_matrixrl(networksr==i, networksl==j);
            sum_networks_rl{i,j} = sum(sum(subnetwork));
            sum_networks_rl_offdiagonal{i,j} = sum(sum(subnetwork.*~eye(size(subnetwork))))/count(i);
        end
    end  
    for i=1:8
        for j=1:8
            subnetwork = organized_matrixlr(networksl==i, networksr==j);
            sum_networks_lr{i,j} = sum(sum(subnetwork));
            sum_networks_lr_offdiagonal{i,j} = sum(sum(subnetwork.*~eye(size(subnetwork))))/count(i);
        end
    end  
    sums1=[sum_networks_rr_offdiagonal,sum_networks_rl_offdiagonal];
    sums2=[sum_networks_lr_offdiagonal,sum_networks_ll_offdiagonal];
    sums=[cell2mat(sums1);cell2mat(sums2)];
    
end