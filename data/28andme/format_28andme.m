%sort data into 5 lists of nonoverlapping tests

prec = load('28andme/precision/FCprec_concat_allsub.mat')
prec=prec.C;

list1=[1 8 24]
list2=list1+1;
list3=list1+2;
list4=list1+3;
list5=list1+4;
list6=list1+5;
list7=list1+6;
alllist=[list1; list2; list3 ;list4; list5 ;list6]

for j=1:6
    for i=1:3
         mat=squeeze(prec(alllist(j,i),:,:));
         mat(logical(eye(268)))=0;
         C_precision{j,i}=mat;
    end
end

save('28andme/precision/C_precision_6lists.mat', 'C_precision')

%sort data into 5 lists of nonoverlapping tests

correl = load('/Users/emilyolafson/GIT/stroke-graph-matching/28andme/pearson_FC/FC_ds.mat')
correl=correl.fc_shen_ds_GSR;

alllist=[list1; list2; list3 ;list4; list5 ;list6; list7]

for j=1:7
    for i=1:3
        C_fc{j,i}=squeeze(correl{alllist(j,i)});
    end
end

save('stroke-graph-matching/28andme/pearson_fc/C_fc_7lists.mat', 'C_fc')


