clc
clear
for batch = 1:4              
    for group = 1:4
        filename = sprintf('Group_Script_B%d_G%d.iqx',batch,group);
        DesDir = sprintf('Batch_%d_Group_%d',batch,group);
        DST_PATH_t = ['WebVersion\',DesDir];%??????
        fid = fopen(filename,'w');
            for subject = 1:45
                fprintf(fid,'<batch>\n');
                fprintf(fid,'/subjects = (%d of 45)\n',subject);
                if subject >= 1 && subject <= 15
                    script_subject_code = subject;
                elseif subject > 15 && subject <= 30
                    script_subject_code = subject - 15;
                elseif subject > 30
                    script_subject_code = subject - 30;
                end
                fprintf(fid,'/file = "Script_B%d_G%d_S%d.iqx"\n',batch,group,script_subject_code);
                fprintf(fid,'</batch>\n\n');
            end
    end
end