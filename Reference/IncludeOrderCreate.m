clc
clear
for subject = 1:18
    for group = 1:10
        filename = sprintf('Script_B%d_G%d.iqx',subject,group);
        fid = fopen(filename,'w');
        fprintf(fid,'<include>\n');
        fprintf(fid,'/ file = "PictureAndText.iqx"\n');
        fprintf(fid,'/ file = "InstructionPage.iqx"\n');
        fprintf(fid,'/ file = "MainStructure.iqx"\n');
        fprintf(fid,'/ file = "8CR_4page.iqx"\n');
        fprintf(fid,'/ file = "8CR_disks.iqx"\n');
        fprintf(fid,'/ file = "BaseScript_B%d_G%d.iqx"\n',subject,group);
        fprintf(fid,'</include>');
    end
end