%%%% this script generates main scripts for inquisit experiments
clc
clear
for batch = 1:4
    for group = 1:4
        for subject = 1:15
            filename = sprintf('Script_B%d_G%d_S%d.iqx',batch,group,subject);
           % filename = sprintf('Script_QL_demo.iqx');
            fid = fopen(filename,'w');
            fprintf(fid,'<include>\n');
            fprintf(fid,'/ file = "calibration_demo.iqx"\n');
            fprintf(fid,'/ file = "PictureAndText_V2.iqx"\n');
            fprintf(fid,'/ file = "Instruction.iqx"\n');
            fprintf(fid,'/ file = "MainStructure_V2.iqx"\n');
            fprintf(fid,'/ file = "8CR_4page.iqx"\n');
            fprintf(fid,'/ file = "8CR_disks.iqx"\n');
            fprintf(fid,'/ file = "BaseScript_B%d_G%d_S%d.iqx"\n',batch,group,subject);
            fprintf(fid,'</include>');
        end
    end
end