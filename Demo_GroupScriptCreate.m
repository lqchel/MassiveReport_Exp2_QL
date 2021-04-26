clc
clear
for batch = 1:1              
    for group = 1:2
        filename = sprintf('Group_Script_B%d_G%d.iqx',batch,group);
        DesDir = sprintf('Batch_%d_Group_%d',batch,group);
        DST_PATH_t = ['WebVersion\',DesDir];%??????
        fid = fopen(filename,'w');
            for subject = 1:3
                fprintf(fid,'<batch>\n');
                fprintf(fid,'/subjects = (%d of 15)\n',subject);
                fprintf(fid,'/file = "Script_B%d_G%d_S%d.iqx"\n',batch,group,subject);
                fprintf(fid,'</batch>\n\n');
            end
    end
end