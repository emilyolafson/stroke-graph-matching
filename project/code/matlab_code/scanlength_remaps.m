% Calculate the correlation between scan length and number of remaps
% between sessions


%% length scan after motion censoring vs remaps

length=load(strcat(curr_dir, 'data/lengthts.mat'))
length=length.length_ts;

length(6, 5) =NaN
length(12,4)=NaN
length(12,5)=NaN
length(20,4)=NaN
length(20,3)=NaN
length(20,5)=NaN

length12=mean([length(:,1),length(:,2)],2);
length23=mean([length(:,2),length(:,3)],2);
length34=mean([length(:,3),length(:,4)],2);
length45=mean([length(:,4),length(:,5)],2);

lengtall=[length12;length23;length34;length45];

data_dir=strcat(curr_dir, '/project/results/precision/');
sum12=sum(remappings_12,2, 'omitnan');
sum23=sum(remappings_23,2, 'omitnan');
sum34=sum(remappings_34,2, 'omitnan');
sum45=sum(remappings_45,2, 'omitnan');

[rho(1), p(1)]=corr(length12, sum12, 'rows', 'complete')
[rho(2), p(2)]=corr(length23, sum23, 'rows', 'complete')
[rho(3), p(3)]=corr(length34, sum34, 'rows', 'complete')
[rho(4), p(4)]=corr(length45, sum45, 'rows', 'complete')



[rho_all(1,1), p_all(1,1)]=corr(length1, sum12, 'rows', 'complete')
[rho_all(2,1), p_all(2,1)]=corr(length2, sum23, 'rows', 'complete')
[rho_all(3,1), p_all(3,1)]=corr(length3, sum34, 'rows', 'complete')
[rho_all(4,1), p_all(4,1)]=corr(length4, sum45, 'rows', 'complete')


[rho_all(1,2), p_all(1,2)]=corr(length2, sum12, 'rows', 'complete')
[rho_all(2,2), p_all(2,2)]=corr(length3, sum23, 'rows', 'complete')
[rho_all(3,2), p_all(3,2)]=corr(length4, sum34, 'rows', 'complete')
[rho_all(4,2), p_all(4,2)]=corr(length5, sum45, 'rows', 'complete')

tiledlayout(3,4,'padding','none')

[rho(1), p(1)]=corr(length12, sum12, 'rows', 'complete')
[rho(2), p(2)]=corr(length23, sum23, 'rows', 'complete')
[rho(3), p(3)]=corr(length34, sum34, 'rows', 'complete')
[rho(4), p(4)]=corr(length45, sum45, 'rows', 'complete')

nexttile
scatter(length12,sum12, 'k', 'filled');xlim([0 400]);ylim([0 150])
xlabel('Scan length (avg)');ylabel('# remaps')
lsline
text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho(1), p(1)), 'FontSize', 15)
nexttile
scatter(length23,sum23, 'k', 'filled');xlim([0 400]);ylim([0 150])
xlabel('Scan length (avg)');ylabel('# remaps')

lsline
text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho(2), p(2)), 'FontSize', 15)
nexttile
scatter(length34,sum34, 'k', 'filled');xlim([0 400]);ylim([0 150])
xlabel('Scan length (avg)');ylabel('# remaps')

lsline
text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho(3), p(3)), 'FontSize', 15)
nexttile
scatter(length45,sum45, 'k', 'filled');xlim([0 400]);ylim([0 150])
xlabel('Scan length (avg)');ylabel('# remaps')

lsline
text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho(4), p(4)), 'FontSize', 15)


[rho_all(1,1), p_all(1,1)]=corr(length1, sum12, 'rows', 'complete')
[rho_all(2,1), p_all(2,1)]=corr(length2, sum23, 'rows', 'complete')
[rho_all(3,1), p_all(3,1)]=corr(length3, sum34, 'rows', 'complete')
[rho_all(4,1), p_all(4,1)]=corr(length4, sum45, 'rows', 'complete')


[rho_all(1,2), p_all(1,2)]=corr(length2, sum12, 'rows', 'complete')
[rho_all(2,2), p_all(2,2)]=corr(length3, sum23, 'rows', 'complete')
[rho_all(3,2), p_all(3,2)]=corr(length4, sum34, 'rows', 'complete')
[rho_all(4,2), p_all(4,2)]=corr(length5, sum45, 'rows', 'complete')



nexttile
scatter(length1,sum12, 'k', 'filled');xlim([0 400]);ylim([0 150])
lsline
xlabel('Scan length');ylabel('# remaps')
text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho_all(1,1), p_all(1,1)), 'FontSize', 15)
nexttile
scatter(length2,sum23, 'k', 'filled');xlim([0 400]);ylim([0 150])
lsline
xlabel('Scan length');ylabel('# remaps')

text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho_all(2,1), p_all(2,1)), 'FontSize', 15)
nexttile
scatter(length3,sum34, 'k', 'filled');xlim([0 400]);ylim([0 150])
lsline
xlabel('Scan length');ylabel('# remaps')

text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho_all(3,1), p_all(3,1)), 'FontSize', 15)
nexttile
scatter(length4,sum45, 'k', 'filled');xlim([0 400]);ylim([0 150])
lsline
xlabel('Scan length');ylabel('# remaps')

text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho_all(4,1), p_all(4,1)), 'FontSize', 15)



nexttile
scatter(length2,sum12, 'k', 'filled');xlim([0 400]);ylim([0 150])
lsline
xlabel('Scan length');ylabel('# remaps')

text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho_all(1,2), p_all(1,2)), 'FontSize', 15)
nexttile
scatter(length3,sum23, 'k', 'filled');xlim([0 400]);ylim([0 150])
lsline
xlabel('Scan length');ylabel('# remaps')

text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho_all(2,2), p_all(2,2)), 'FontSize', 15)
nexttile
scatter(length4,sum34, 'k', 'filled');xlim([0 400]);ylim([0 150])
lsline
xlabel('Scan length');ylabel('# remaps')

text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho_all(3,2), p_all(3,2)), 'FontSize', 15)
nexttile
scatter(length5,sum45, 'k', 'filled');xlim([0 400]);ylim([0 150])
lsline
xlabel('Scan length');ylabel('# remaps')

text(10, 30, sprintf('corr. = %0.2f \n p = %0.2f', rho_all(4,2), p_all(4,2)), 'FontSize', 15)




