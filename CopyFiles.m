   clc
clear
fileFolder=fullfile('response');%????plane
dirOutput=dir(fullfile(fileFolder,'*'));%??????????????*?????????????????'.'???????????.jpg?
fileNames={dirOutput.name}';
for batch = 1:4
    for group = 1:4
        DesDir = sprintf('Batch_%d_Group_%d',batch,group);
        DST_PATH_t = ['WebVersion\',DesDir];%??????
                %     Copy Commom Scripts
        file_1 = 'GIFSource\FixAndPresent.gif';
        file_2 = 'GIFSource\patchPresentation.gif';
        file_3 = 'GIFSource\responsePage.jpg';
        file_4 = 'GIFSource\seriesPatch.gif';
        file_5 = 'CommonFile\monash-logo-mono.png';
        file_6 = 'CommonFile\consent_form.html';
        file_7 = 'GIFSource\CalibrationInstruction.gif';
%         
        location1 = 'CommonFile\location1.png';
        location2 = 'CommonFile\location2.png';
        location3 = 'CommonFile\location3.png';
        location4 = 'CommonFile\location4.png';
        location5 = 'CommonFile\location5.png';
        location6 = 'CommonFile\location6.png';
        location7 = 'CommonFile\location7.png';
        location8 = 'CommonFile\location8.png';
        location9 = 'CommonFile\location9.png';

        location10 = 'CommonFile\CalibrationLine.png';
        location11 = 'CommonFile\card.png';
        location12 = 'CommonFile\CalibrationPage5.png';
        location13 = 'CommonFile\CalibrationPage6.png';
        copyfile(file_1,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        copyfile(file_2,DST_PATH_t);
        copyfile(file_3,DST_PATH_t);
        copyfile(file_4,DST_PATH_t);
        copyfile(file_5,DST_PATH_t);
        copyfile(file_6,DST_PATH_t);
        copyfile(file_7,DST_PATH_t);

        copyfile(location1,DST_PATH_t);
        copyfile(location2,DST_PATH_t);
        copyfile(location3,DST_PATH_t);
        copyfile(location4,DST_PATH_t);
        copyfile(location5,DST_PATH_t);
        copyfile(location6,DST_PATH_t);
        copyfile(location7,DST_PATH_t);
        copyfile(location8,DST_PATH_t);
        copyfile(location9,DST_PATH_t);
        copyfile(location10,DST_PATH_t);
        copyfile(location11,DST_PATH_t);
        copyfile(location12,DST_PATH_t);
        copyfile(location13,DST_PATH_t);
        file_name = 'calibration_main.iqx';
        copyfile(file_name,DST_PATH_t);
        file_name = 'calibration_demo.iqx';
        copyfile(file_name,DST_PATH_t);  
        file_name = 'Instruction.iqx';
        copyfile(file_name,DST_PATH_t);
        file_name = 'MainStructure_V2.iqx';
        copyfile(file_name,DST_PATH_t);
        file_name = 'PictureAndText_V2.iqx';
        copyfile(file_name,DST_PATH_t); 
        file_name = sprintf('Group_Script_B%d_G%d.iqx',batch,group);
        copyfile(file_name,DST_PATH_t);
        for i = 3:length(fileNames)
            temp = string(fileNames(i));
            file_name = sprintf('response/%s',temp);
            copyfile(file_name,DST_PATH_t);
        end
        
        for subject = 1:15
            file_name = sprintf('BaseScript_B%d_G%d_S%d.iqx',batch,group,subject);
            copyfile(file_name,DST_PATH_t);
            file_name = sprintf('Script_B%d_G%d_S%d.iqx',batch,group,subject);
            %file_name = sprintf('Script_QL_demo.iqx');
            copyfile(file_name,DST_PATH_t);
        end
    end
end












