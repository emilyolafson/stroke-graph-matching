
%% save FC to matrices, rows as subjects, columns as sessions.
curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/cast_data'
subdir=strcat(curr_dir, '/precision_short/')
fid = fopen(strcat(subdir, 'subjects.txt'));
line1 = fgetl(fid)

for i=1:34
    mat=load(strcat(subdir, line1));
    all_precision{i} = mat;
    allnames{i}=line1
    line1 = fgetl(fid);
end

new=cell(13,2)
new{1,1} = all_precision{1}%sub1 day 1 to day 8
new{1,2} = all_precision{8}
new{2,1} = all_precision{12}%sub 2 day 1 to day 8
new{2,2} = all_precision{19}
new{3,1} = all_precision{13}%sub2 day 2 to day 9
new{3,2} = all_precision{20}
new{4,1} = all_precision{14}%sub2 day 3 to day 10
new{4,2} = all_precision{9}
new{5,1} = all_precision{15}%sub2 day 4 to day 11
new{5,2} = all_precision{10}
new{6,1} = all_precision{16}%sub2 day 5 to day 12
new{6,2} = all_precision{11}
new{7,1} = all_precision{26}%1
new{7,2} = all_precision{33}%8
new{8,1} = all_precision{27}%2
new{8,2} = all_precision{34}%9
new{9,1} = all_precision{28}%3
new{9,2} = all_precision{21}%10
new{10,1} = all_precision{29}%4
new{10,2} = all_precision{22}%11
new{11,1} = all_precision{30}%5
new{11,2} = all_precision{23}%12
new{12,1} = all_precision{31}%6
new{12,2} = all_precision{24}%13
new{13,1} = all_precision{32}%7
new{13,2} = all_precision{25}%14

for i=1:13
    for j=1:2
        mat=new{i,j}.C;
        mat(logical(eye(268)))=0;
        final{i,j}=mat
    end
end

C_precision=final
curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/cast_data'
subdir=strcat(curr_dir, '/precision_short/')
save(strcat(subdir, 'C_precision.mat'), 'C_precision')

% new{3} = all_precision{12}%1
% new{10} = all_precision{13}%2
% new{11} = all_precision{14}%3
% new{12} = all_precision{15}%4
% new{13} = all_precision{16}%5
% new{14} = all_precision{17}%6
% new{15} = all_precision{18}%7
% new{16} = all_precision{19}%8
% new{17} = all_precision{20}%9
% new{18} = all_precision{9}%10
% new{19} = all_precision{10}%11
% new{20} = all_precision{11}%12
