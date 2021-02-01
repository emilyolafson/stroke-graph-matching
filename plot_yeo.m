function [] = plot_yeo(matrix,tit, cmap, range, linecolor)
    %plot_yeo(matrix,tit, cmap, range, linecolor)
    curr_dir=pwd;

    Lyeolabels=({'L - Medial frontal', 'L - Frontoparietal', 'L - Default mode', 'L - Subcortical-cerebellum','L - Motor', 'L - Visual I', 'L - Visual II','L - Visual association'});
    Ryeolabels=({'R - Medial frontal', 'R - Frontoparietal', 'R - Default mode', 'R - Subcortical-cerebellum','R - Motor', 'R - Visual I', 'R - Visual II','R - Visual association'});
    allyeolabels=[Ryeolabels,Lyeolabels];
    
    a=readmatrix(strcat(pwd, '/shen_268_parcellation_networklabels.csv'))
    [dx,s]=sort(a);

    left_a=a(135:268,:);
    [f,l]=sort(left_a);
    for i=1:8
        size(i)=sum(i==f(:,2))
    end
    l=l(:,2)+134;
    right_a=a(1:134,:);
    [~,r]=sort(right_a);
    r=r(:,2)

    xticks_aligned=[10,27,38,66,101,117,123,130];
    xticks=[xticks_aligned,xticks_aligned+134];

    yeo_labels=[r;l];
    
    imagesc(matrix(yeo_labels,yeo_labels), range)
    colormap(cmap)
    set(gca,'XTicklabels', allyeolabels,'YTicklabels', allyeolabels, 'XTick', xticks, 'YTick', xticks)
    xline(19, linecolor);xline(34, linecolor);xline(42, linecolor);xline(88, linecolor);xline(113, linecolor);xline(121, linecolor);xline(126, linecolor);xline(134, linecolor);
    xline(19+135, linecolor);xline(34+135, linecolor);xline(42+135, linecolor);xline(88+135, linecolor);xline(113+135, linecolor);xline(121+135, linecolor);xline(126+135, linecolor);xline(134+134);
    yline(19, linecolor);yline(34, linecolor);yline(42, linecolor);yline(88, linecolor);yline(113, linecolor);yline(121, linecolor);yline(126, linecolor);yline(134, linecolor);
    yline(19+135, linecolor);yline(34+135, linecolor);yline(42+135, linecolor);yline(88+135, linecolor);yline(113+135, linecolor);yline(121+135, linecolor);yline(126+135, linecolor);yline(134+134);
    set(gca,'FontSize', 12)
    xtickangle(45)
    colorbar;
    title(tit)
    ytickangle(0)
end
