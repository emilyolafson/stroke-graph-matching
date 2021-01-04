nsess=[5;5;5;5;5;4;5;5;5;5;5;3;5;5;5;5;5;5;5;2;5;5;5]
nsess(24:47)=5;

%% create array with 1's for stroke subs, 0 for controls (for next section)
clear dx_id
curr_dir=pwd;
subdir=strcat(curr_dir, '/data/')
fid = fopen(strcat(subdir, 'subjects.txt'));
line1 = fgetl(fid)

dx_id=zeros(229,1)
c = 1;
while ischar(line1)
    % parse fieldname and find subject number
    session = strfind(line1, '_S');
    sub_num = line1(session -2:session - 1)
    if (strfind(sub_num, 'B') == 1)
        dx_id(c) = 1;
        c = c + 1;
        line1 = fgetl(fid);
        continue;
    end
    if str2double(sub_num) < 24
        dx_id(c) = 1;
    else
        dx_id(c) = 0;
    end
    c = c + 1;
    line1 = fgetl(fid);
end
fclose(fid);

% open  file for writing
fid = fopen(strcat(subdir, 'dx_id.txt'),'wt');
% write the matrix
if fid > 0
    fprintf(fid,'%d \n',dx_id);
    fclose(fid);
end

%% save FC to matrices, rows as subjects, columns as sessions
curr_dir=pwd;
subdir=strcat(curr_dir, '/data/precision/')
fid = fopen(strcat(subdir, 'subjects.txt'));
line1 = fgetl(fid)

for i=1:229
    mat=load(strcat(subdir, line1));
    session = strfind(line1, '_S');
    sub_num = line1(session -2:session - 1)
    session_num=strcat('S', line1(session+2)); 
    
    if (strfind(sub_num, 'B') == 1)
        sub_num=str2double(sub_num(2))
    else
        sub_num=str2double(sub_num)
    end
    if (dx_id(i) == 1)
        allfc_stroke(sub_num).(session_num) = mat;
    end
    if (dx_id(i)==0)
        allfc_controls(sub_num-23).(session_num) = mat;
    end
    line1 = fgetl(fid);
end

clear C_precision2
C_precision=allfc_stroke;
C_precision=struct2cell(C_precision)
C_precision=squeeze(C_precision)
C_precision=C_precision'
C_precision=C_precision

for i=1:23
    for j=1:nsess(i)
        C_precision2{i,j}=C_precision{i,j}.C
    end
end
C_precision=C_precision2;
save(strcat(subdir, '/precision/stroke/C_precision.mat'), 'C_precision')

clear C_precision2
C_precision=allfc_controls;
C_precision=struct2cell(C_precision)
C_precision=squeeze(C_precision)
C_precision=C_precision'
for i=24:47
    for j=1:nsess(i)
        C_precision2{i-23,j}=C_precision{i-23,j}.C
    end
end
C_precision=C_precision2;
save(strcat(subdir, '/precision/control/C_precision.mat'), 'C_precision')
