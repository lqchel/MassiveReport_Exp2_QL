clc
clear
for subject = 1:4
    for group = 1:4
        filename = sprintf('Script_B%d_G%d.iqx',subject,group);
       % filename = sprintf('Script_QL_demo.iqx');
        fid = fopen(filename,'w');
        fprintf(fid,'<include>\n');
%         fprintf(fid,'/ file = "ConcentrationResponse.iqx"\n');
        fprintf(fid,'/ file = "calibration_demo.iqx"\n');
        fprintf(fid,'/ file = "SchizotypySurvey.iqx"\n');
        fprintf(fid, '/ file = "participant_demographics.iqx"\n');
        fprintf(fid,'/ file = "PictureAndText_V2.iqx"\n');
        fprintf(fid,'/ file = "Instruction.iqx"\n');
        fprintf(fid,'/ file = "MainStructure_V2.iqx"\n');
        fprintf(fid,'/ file = "8CR_4page.iqx"\n');
        fprintf(fid,'/ file = "8CR_disks.iqx"\n');
        fprintf(fid,'/ file = "BaseScript_B%d_G%d.iqx"\n',subject,group);
        fprintf(fid,'</include>');
    end
end