%% Add paths for FSL, SPM, and keith's matlab_common

if(isempty(which('read_avw')))
    setenv('FSLDIR','/usr/local/fsl');
    addpath('/usr/local/fsl/etc/matlab');
end
if(isempty(which('spm_vol')))
    addpath('~/MATLAB_TOOLBOXES/spm12');
end
%if(isempty(which('iso2meshver')))
%    addpath('~/MATLAB_TOOLBOXES/iso2mesh');
%end
if(isempty(which('clearb')))
    addpath('~/Source/matlab_common');
end


%% plot figures
setenv('FSLDIR', '/usr/local/fsl')
fsldir=getenv('FSLDIR')
addpath(fsldir, '/Users/emilyolafson/MATLAB')
shen268=make_atlas_blobs('/Users/emilyolafson/Documents/Thesis/shen_2mm_268_parcellation.nii');
atlasblobs_list=load('/Users/emilyolafson/Documents/Thesis/gummibrain/atlasblobs_saved.mat');
atlasblobs_list=atlasblobs_list.atlasblobs;
atlasblobs=shen268;
shen268.backgroundslice=atlasblobs_list(1).backgroundslice;

shen268.backgroundposition=atlasblobs_list(1).backgroundposition;
shen268.atlasname='shen268';
atlasblobs_list(8)=shen268;
save('/Users/emilyolafson/Documents/Thesis/gummibrain/atlasblobs_saved.mat', 'atlasblobs_list')
roicents = shen268.roicenters
save('/Users/emilyolafson/Documents/Thesis/reoicents.mat', 'roicents')

yeo=readtable('/Users/emilyolafson/Downloads/shen_268_parcellation_networklabels.csv')
yeo_atlas=yeo(:, 2)
yeo_char=num2str(yeo_atlas)

yeo_atlas=table2array(yeo_atlas)
load('/Users/emilyolafson/Documents/Thesis/reoicents.mat')
colors=ones(268, 1);
sizes =ones(268,1);

node_file = array2table([roicents, colors, sizes])

node_file

writetable(node_file,'/Users/emilyolafson/Documents/Thesis/nodes_yeo.txt')

for i=23
    V = load(strcat('/Users/emilyolafson/Documents/Thesis/SUB1_23_data/NeMo_SUB1_23/shen_regional/SUB', num2str(i), '_lesion_1mmMNI_shen268_mean_chacovol.csv'))
    %set colormap
    cmap=hot;

    %choose atlas
    %options for whichatlas: aal, cc200, cc400, ez, ho, tt, fs86
    whichatlas={'shen268'}
    clc;

    %set data you want to plot
    data=V';

    %set min/max limits for plot
    clim=[0,0.1];

    img=display_atlas_blobs(data,atlasblobs_list,...
        'atlasname',whichatlas,...
        'render',true,...
        'backgroundimage',true,...
        'crop',true,...
        'colormap',cmap,...
        'clim', clim);

    figure;
    imshow(img);

    %to show colorbar
    c=colorbar('SouthOutside', 'fontsize', 16);
    c.Label.String='';
    set(gca,'colormap',cmap);
    caxis([0 0.1]);
    title(strcat('Subject', num2str(i)), 'fontsize',18);

    % to annotate RH, LH, medial, lateral sides fo the brain
    annotation('textbox',[.835 .38 .1 .2],'String','RH','EdgeColor','none', 'fontsize',16,'color','white')
    annotation('textbox',[.12 .38 .1 .2],'String','LH','EdgeColor','none', 'fontsize',16,'color','white')
    annotation('textbox',[.45 .9 .1 .04],'String','Lateral','EdgeColor','none', 'fontsize',16,'color','white', 'horizontalalignment','center','backgroundcolor','black')
    annotation('textbox',[.45 .21 .1 .04],'String','Medial','EdgeColor','none', 'fontsize',16,'color','white', 'horizontalalignment','center', 'backgroundcolor','black')

    %save image
    saveas(gcf,strcat('/Users/emilyolafson/Documents/Thesis/Figures/June26_shen268_chaco/SUB', num2str(i), '_chaco_shen268.png'));
end
