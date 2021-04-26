clc
clear
for batch = 1:1
    for group = 1:2
        for subject = 1:3
            filename = sprintf('Script_B%d_G%d_S%d.iqx',batch,group,subject);
           % filename = sprintf('Script_QL_demo.iqx');
            fid = fopen(filename,'w');
            fprintf(fid,'<include>\n');
            fprintf(fid,'/ file = "PictureAndText_V2.iqx"\n');
            fprintf(fid,'/ file = "Instruction.iqx"\n');
            fprintf(fid,'/ file = "Demo_MainStructure.iqx"\n');
            fprintf(fid,'/ file = "8CR_4page.iqx"\n');
            fprintf(fid,'/ file = "8CR_disks.iqx"\n');
            fprintf(fid,'/ file = "BaseScript_B%d_G%d_S%d.iqx"\n',batch,group,subject);
            fprintf(fid,'</include>');
        end
    end
end