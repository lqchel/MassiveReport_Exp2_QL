clc
clear
for subject = 1:1
    for group = 1:3
        filename = sprintf('Script_S%d.iqx',subject);
        fid = fopen(filename,'w');
        fprintf(fid,'<include>\n');
%         fprintf(fid,'/ file = "ConcentrationResponse.iqx"\n');
        fprintf(fid,'/ file = "Calibration.iqx"\n');
        fprintf(fid,'/ file = "PictureAndText_V2.iqx"\n');
        fprintf(fid,'/ file = "Instruction.iqx"\n');
        fprintf(fid,'/ file = "MainStructure_V2.iqx"\n');
        fprintf(fid,'/ file = "8CR_4page.iqx"\n');
        fprintf(fid,'/ file = "8CR_disks.iqx"\n');
        fprintf(fid,'/ file = "PracticeTrial.iqx"\n')
        fprintf(fid,'/ file = "BaseScript_S%d.iqx"\n',subject);
        fprintf(fid,'</include>');
    end
end