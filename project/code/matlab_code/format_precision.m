% Create cell array with cells containing 268x268 precision FCs (for input
% to graph matching).
% Rows of cell array should be subjects; columns should be longitudinal
% time points (e.g. col 1 = time point 1, col 2 = time point 2 etc).

% Additional formatting that is essential for graph matching: Set diagonals
% of FC matrices to 0. If you do not do this, you will get artifically low
% remapping.

%% save FC to cell array: rows as subjects, columns as sessions
curr_dir='/Users/emilyolafson/GIT/stroke-graph-matching/';
subdir=strcat(curr_dir, 'data/precision/')
fid = fopen(strcat(subdir, 'subjects.txt'))

line1 = fgetl(fid)
for i=1:300
    mat=load(strcat(subdir, line1));
    session = strfind(line1, '_S');
    sub_num = line1(session -2:session - 1)
    session_num=strcat('S', line1(session+2)); 
    
    if (strfind(sub_num, 'B') == 1)
        sub_num=str2double(sub_num(2))
    else
        sub_num=str2double(sub_num)
    end
    allfc_stroke(sub_num).(session_num) = mat;
    line1 = fgetl(fid);
end

precision=allfc_stroke;
precision=struct2cell(precision);
precision=squeeze(precision);
precision=precision';

%% Set diagonal to zero
nsess=[5;5;5;5;5;4;5;5;5;5;5;3;5;5;5;5;5;5;5;2;5;5;5]
nsess2=ones(24, 1)*5;
nsess=[nsess;nsess2]

for i=1:24
    for j=1:nsess(i)
        mat=precision{i,j}.C;
        mat(logical(eye(268)))=0;
        C_precision{i,j}=mat;
    end
end
subdir=strcat(curr_dir, 'data/precision/stroke/')

save(strcat(subdir, '/C_precision.mat'), 'C_precision')



for i=24:47
    for j=1:nsess(i)
        mat=precision{i,j}.C;
        mat(logical(eye(268)))=0;
        C_precision{i,j}=mat;
    end
end

C_precision = C_precision(24:47,:)
subdir=strcat(curr_dir, 'data/precision/control/')

save(strcat(subdir, '/C_precision.mat'), 'C_precision')
