clc
clear
% % Create the Base of Congruent Image Presentation
% Version for NEST FOLDER
% file_path_Congruent_Patch = 'congruent patch\';
% file_path_inCongruent_Patch = 'incongruent patch\';
% file_path_N_patches = 'nishimoto patch\';
% file_path_CongruentCropped = 'squareimage\congruent cropped\';
% file_path_InCongruentCropped = 'squareimage\incongruent cropped\';
% file_path_mask = 'mask\';
% file_path_patch_mask = 'maskCrop\';

% Version For individual folder
file_path_Congruent_Patch = 'congruent patch\';
file_path_inCongruent_Patch = 'incongruent patch\';
file_path_N_patches = 'nishimoto patch\';
file_path_CongruentCropped = 'squareimage\congruent cropped\';
file_path_InCongruentCropped = 'squareimage\incongruent cropped\';
file_path_mask = 'mask\';
file_path_patch_mask = 'maskCrop\';

Total_Trial_number = 14; %% Define how many congruent images are used to presentation
Total_Trial_number_practice = 3;
Number_of_Masking = 20;
imagesc_matrix = ones(140,18);
for subject = 1:18
order_list_group = randperm(140,140);
imagesc_matrix(:,subject) = order_list_group';
for group = 1:10
    DesDir = sprintf('Subject_%d_Group_%d',subject,group);
    mkdir('WebVersion\',DesDir);
%     Copy Commom Scripts
    DST_PATH_t = ['WebVersion\',DesDir];%??????
    
% order_list = randperm(140,Total_Trial_number); %% Choose number of Congruent Pictures from Source base, then re-order the list
order_list = order_list_group(1 + Total_Trial_number*(group-1):Total_Trial_number + Total_Trial_number*(group-1));
order_list_practice = randperm(140,Total_Trial_number_practice);
order_list_Masking = randperm(140,Number_of_Masking);
filename = sprintf('BaseScript_B%d_G%d.iqx',subject,group);
fid = fopen(filename,'w');
NumberOfNpatch = 7044;

%% Create List of Presentation for Congruent Image 
%Need to mix the congruent and Incongruent images throughout the experiment
fprintf(fid,'<item image_presentation_Congruent>\n'); %Only create the congruent part
PresentArray = string(ones(1,Total_Trial_number)); %Pre-create an array to represent the order of presentation image for INCONG and CONG
if mod(Total_Trial_number,2) == 0
    ChooseINCONGorCONG = randerr(1,Total_Trial_number,Total_Trial_number/2)+1;
elseif mod(Total_Trial_number,2) == 1
    ChooseINCONGorCONG = randerr(1,Total_Trial_number,(Total_Trial_number-1)/2)+1;
end
for presentation_number = 1:Total_Trial_number
    if ChooseINCONGorCONG(presentation_number) == 1
        PresentArray(presentation_number) = 'Cong';
        string_order = num2str(order_list(presentation_number).','%03d');
        address = sprintf('"%s%s.jpg"','SquareCongruent_',string_order);
        file_name = sprintf('%s%s%s.jpg',file_path_CongruentCropped,'SquareCongruent_',string_order); 
        fprintf(fid,'/%d = ',presentation_number);
        fprintf(fid,'%s\n',address);
        copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
    elseif ChooseINCONGorCONG(presentation_number) == 2
        %Here to create part of Incongruent images
        PresentArray(presentation_number) = 'INcong';
        string_order = num2str(order_list(presentation_number).','%03d');
        address = sprintf('"%s%s.jpg"','SquareIncongruent_',string_order);
        file_name = sprintf('%s%s%s.jpg',file_path_InCongruentCropped,'SquareIncongruent_',string_order); 
        fprintf(fid,'/%d = ',presentation_number);
        fprintf(fid,'%s\n',address);
        copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
    end
end
fprintf(fid,'</item>\n\n');
       
%% Create List of Presentation for Practice 
fprintf(fid,'<item image_presentation_Congruent_practice>\n');
PresentArray_practice = string(ones(1,Total_Trial_number_practice));
if mod(Total_Trial_number_practice,2) == 0
    ChooseINCONGorCONG_practice = randerr(1,Total_Trial_number_practice,Total_Trial_number_practice/2)+1;
elseif mod(Total_Trial_number_practice,2) == 1
    ChooseINCONGorCONG_practice = randerr(1,Total_Trial_number_practice,(Total_Trial_number_practice-1)/2)+1;
end
for presentation_number = 1:Total_Trial_number_practice
    if ChooseINCONGorCONG_practice(presentation_number) == 1
        PresentArray_practice(presentation_number) = 'Cong';
        string_order = num2str(order_list_practice(presentation_number).','%03d');
        address = sprintf('"%s%s.jpg"','SquareCongruent_',string_order);
        file_name = sprintf('%s%s%s.jpg',file_path_CongruentCropped,'SquareCongruent_',string_order);
        fprintf(fid,'/%d = ',presentation_number);
        fprintf(fid,'%s\n',address);
        copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
    elseif ChooseINCONGorCONG_practice(presentation_number) == 2
        %Here to create part of Incongruent images
        PresentArray_practice(presentation_number) = 'INcong';
        string_order = num2str(order_list_practice(presentation_number).','%03d');
        address = sprintf('"%s%s.jpg"','SquareIncongruent_',string_order);
        file_name = sprintf('%s%s%s.jpg',file_path_InCongruentCropped,'SquareIncongruent_',string_order);
        fprintf(fid,'/%d = ',presentation_number);
        fprintf(fid,'%s\n',address);
        copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
    end
end
fprintf(fid,'</item>\n\n');

%% Create List of Masking and the masking for patches
for Masking_group = 1:5
    string_title_number = num2str(Masking_group.','%01d');
    fprintf(fid,'<item Masking_item_%s>\n',string_title_number);
    for content = 1:(Number_of_Masking/5)
        string_order = num2str(order_list_Masking(content+(Number_of_Masking/5)*(Masking_group-1)).','%03d');
        fprintf(fid,'/%d = "mask_%s.jpg"\n',content,string_order);
        file_name = sprintf('%smask_%s.jpg',file_path_mask,string_order);
        copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
    end
    fprintf(fid,'</item>\n\n');
end

for Masking_group_patch = 1:5
    string_title_number = num2str(Masking_group_patch.','%01d');
    fprintf(fid,'<item Masking_patch_item_%s>\n',string_title_number);
    for content = 1:(Number_of_Masking/5)
        string_order = num2str(order_list_Masking(content+(Number_of_Masking/5)*(Masking_group_patch-1)).','%03d');
        fprintf(fid,'/%d = "maskCrop_%s.jpg"\n',content,string_order);
        file_name = sprintf('%smaskCrop_%s.jpg',file_path_patch_mask,string_order);
        copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
    end
    fprintf(fid,'</item>\n\n');
end

%% Here used to specify where the CP located 
IP_position = ones(1,length(order_list));
for presentation_order = 1:length(order_list)
    Presentation_image_patch_name = sprintf('cong_%d_*.jpg',order_list(presentation_order));
    img_path_list = dir(strcat(file_path_Congruent_Patch,Presentation_image_patch_name));
    num_img = length(img_path_list);  
    temp_array = ones(1,num_img);
    for kk = 1:num_img
        temp_array(kk) = img_path_list(kk).name(length(img_path_list(kk).name)-4);
    end
    IP_position(presentation_order) = find(temp_array == 'p'); %%Find the CP position of the image
end

P_positon_EvenOrOdd = mod(IP_position,2); % 1 => P is 1,3,5,7,9; 0 => 2,4,6,8

% Practice Part
IP_position_practice = ones(1,length(order_list_practice));
for presentation_order = 1:length(order_list_practice)
    Presentation_image_patch_name = sprintf('cong_%d_*.jpg',order_list_practice(presentation_order));
    img_path_list = dir(strcat(file_path_Congruent_Patch,Presentation_image_patch_name));
    num_img = length(img_path_list);  
    temp_array = ones(1,num_img);
    for kk = 1:num_img
        temp_array(kk) = img_path_list(kk).name(length(img_path_list(kk).name)-4);
    end
    IP_position_practice(presentation_order) = find(temp_array == 'p'); %%Find the CP position of the image
end

P_positon_EvenOrOdd_practice = mod(IP_position_practice,2); % 1 => P is 1,3,5,7,9; 0 => 2,4,6,8


%% Create CP position group
%Practice Part
fprintf(fid,'<item CP_patch_practice>\n');
for presentation_number = 1:Total_Trial_number_practice
    if PresentArray_practice(presentation_number) == "Cong"
       item_content = sprintf('incong_%d_%d_p.jpg',order_list_practice(presentation_number),IP_position_practice(presentation_number));
       fprintf(fid,'/%d = "%s"\n',presentation_number,item_content);
       file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
       copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
    elseif PresentArray_practice(presentation_number) == "INcong"
       item_content = sprintf('cong_%d_%d_p.jpg',order_list_practice(presentation_number),IP_position_practice(presentation_number));
       fprintf(fid,'/%d = "%s"\n',presentation_number,item_content);
       file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
       copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
    end
end
fprintf(fid,'</item>\n\n');

% Formal Part
fprintf(fid,'<item CP_patch>\n');
for presentation_number = 1:Total_Trial_number
    if PresentArray(presentation_number) == "Cong"
       item_content = sprintf('incong_%d_%d_p.jpg',order_list(presentation_number),IP_position(presentation_number));
       fprintf(fid,'/%d = "%s"\n',presentation_number,item_content);
       file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
       copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
    elseif PresentArray(presentation_number) == "INcong"
       item_content = sprintf('cong_%d_%d_p.jpg',order_list(presentation_number),IP_position(presentation_number));
       fprintf(fid,'/%d = "%s"\n',presentation_number,item_content);
       file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
       copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
    end
end
fprintf(fid,'</item>\n\n');



%% Create coordinates for CP position group
%Practice Part
CP_x_coordinates_practice = string(ones(1,Total_Trial_number_practice));
CP_y_coordinates_practice = string(ones(1,Total_Trial_number_practice));
for presentation_number = 1:Total_Trial_number_practice
    if IP_position_practice(presentation_number) == 1 || IP_position_practice(presentation_number) == 4 || IP_position_practice(presentation_number) == 7
        CP_x_coordinates_practice(presentation_number) = "38.7";
    elseif IP_position_practice(presentation_number) == 2 || IP_position_practice(presentation_number) == 5 || IP_position_practice(presentation_number) == 8
        CP_x_coordinates_practice(presentation_number) = "50";
    elseif IP_position_practice(presentation_number) == 3 || IP_position_practice(presentation_number) == 6 || IP_position_practice(presentation_number) == 9
        CP_x_coordinates_practice(presentation_number) = "61.3";
    end    
end

for presentation_number = 1:Total_Trial_number_practice
    if IP_position_practice(presentation_number) == 1 || IP_position_practice(presentation_number) == 2 || IP_position_practice(presentation_number) == 3
        CP_y_coordinates_practice(presentation_number) = "30";
    elseif IP_position_practice(presentation_number) == 4 || IP_position_practice(presentation_number) == 5 || IP_position_practice(presentation_number) == 6
        CP_y_coordinates_practice(presentation_number) = "50";
    elseif IP_position_practice(presentation_number) == 7 || IP_position_practice(presentation_number) == 8 || IP_position_practice(presentation_number) == 9
        CP_y_coordinates_practice(presentation_number) = "70";
    end    
end

fprintf(fid,'<item CP_x_coordinates_practice>\n');
for presentation_number = 1:Total_Trial_number_practice
    fprintf(fid,'/%d = "%s%%"\n',presentation_number,CP_x_coordinates_practice(presentation_number));
end
fprintf(fid,'</item>\n\n');

fprintf(fid,'<item CP_y_coordinates_practice>\n');
for presentation_number = 1:Total_Trial_number_practice
    fprintf(fid,'/%d = "%s%%"\n',presentation_number,CP_y_coordinates_practice(presentation_number));
end
fprintf(fid,'</item>\n\n');


%Formal Part
CP_x_coordinates = string(ones(1,Total_Trial_number));
CP_y_coordinates = string(ones(1,Total_Trial_number));
for presentation_number = 1:Total_Trial_number
    if IP_position(presentation_number) == 1 || IP_position(presentation_number) == 4 || IP_position(presentation_number) == 7
        CP_x_coordinates(presentation_number) = "38.7";
    elseif IP_position(presentation_number) == 2 || IP_position(presentation_number) == 5 || IP_position(presentation_number) == 8
        CP_x_coordinates(presentation_number) = "50";
    elseif IP_position(presentation_number) == 3 || IP_position(presentation_number) == 6 || IP_position(presentation_number) == 9
        CP_x_coordinates(presentation_number) = "61.3";
    end    
end

for presentation_number = 1:Total_Trial_number
    if IP_position(presentation_number) == 1 || IP_position(presentation_number) == 2 || IP_position(presentation_number) == 3
        CP_y_coordinates(presentation_number) = "30";
    elseif IP_position(presentation_number) == 4 || IP_position(presentation_number) == 5 || IP_position(presentation_number) == 6
        CP_y_coordinates(presentation_number) = "50";
    elseif IP_position(presentation_number) == 7 || IP_position(presentation_number) == 8 || IP_position(presentation_number) == 9
        CP_y_coordinates(presentation_number) = "70";
    end    
end

fprintf(fid,'<item CP_x_coordinates>\n');
for presentation_number = 1:Total_Trial_number
    fprintf(fid,'/%d = "%s%%"\n',presentation_number,CP_x_coordinates(presentation_number));
end
fprintf(fid,'</item>\n\n');

fprintf(fid,'<item CP_y_coordinates>\n');
for presentation_number = 1:Total_Trial_number
    fprintf(fid,'/%d = "%s%%"\n',presentation_number,CP_y_coordinates(presentation_number));
end
fprintf(fid,'</item>\n\n');







%% Create Picture Stimuli
%% Create Groups when IP in odd position
%Create Group of Position 1
%Practice
fprintf(fid,'<picture Patch_locate_1_practice>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (38.7%%,30%%)\n');
fprintf(fid,'  /items = ()\n');
fprintf(fid,'  /select = sequence\n');
fprintf(fid,'</picture>\n');
fprintf(fid,'<picture Patch_locate_1_practice_item>\n');
temp_1 = 0;
for presentation_order = 1:length(order_list_practice)
    if PresentArray_practice(presentation_order) == "Cong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 1
            if IP_position_practice(presentation_order) == 1
               item_content = sprintf('cong_%d_1_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('cong_%d_1_a.jpg',order_list_practice(presentation_order));
            end
            temp_1 = temp_1 + 1;
            fprintf(fid,'/%d = "%s"\n',temp_1,item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray_practice(presentation_order) == "INcong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 1
            if IP_position_practice(presentation_order) == 1
               item_content = sprintf('incong_%d_1_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('incong_%d_1_a.jpg',order_list_practice(presentation_order));
            end
            temp_1 = temp_1 + 1;
            fprintf(fid,'/%d = "%s"\n',temp_1,item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,'</picture>\n\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Formal
fprintf(fid,'<picture Patch_locate_1>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (38.7%%,30%%)\n');
fprintf(fid,'  /items = (');
for presentation_order = 1:length(order_list)
    if PresentArray(presentation_order) == "Cong"
        if P_positon_EvenOrOdd(presentation_order) == 1
            if IP_position(presentation_order) == 1
               item_content = sprintf('cong_%d_1_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('cong_%d_1_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray(presentation_order) == "INcong"
        if P_positon_EvenOrOdd(presentation_order) == 1
            if IP_position(presentation_order) == 1
               item_content = sprintf('incong_%d_1_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('incong_%d_1_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Practice
%Create Group of Position 3
fprintf(fid,'<picture Patch_locate_3_practice>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (61.3%%,30%%)\n');
fprintf(fid,'  /items = ()\n');
fprintf(fid,'  /select = sequence\n');
fprintf(fid,'</picture>\n');
fprintf(fid,'<picture Patch_locate_3_practice_item>\n');
temp_3 = 0;
for presentation_order = 1:length(order_list_practice)
    if PresentArray_practice(presentation_order) == "Cong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 1
            if IP_position_practice(presentation_order) == 3
               item_content = sprintf('cong_%d_3_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('cong_%d_3_a.jpg',order_list_practice(presentation_order));
            end
            temp_3 = temp_3 + 1;
            fprintf(fid,'/%d = "%s"\n',temp_3,item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray_practice(presentation_order) == "INcong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 1
            if IP_position_practice(presentation_order) == 3
               item_content = sprintf('incong_%d_3_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('incong_%d_3_a.jpg',order_list_practice(presentation_order));
            end
            temp_3 = temp_3 + 1;
            fprintf(fid,'/%d = "%s"\n',temp_3,item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Formal
%Create Group of Position 3
fprintf(fid,'<picture Patch_locate_3>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (61.3%%,30%%)\n');
fprintf(fid,'  /items = (');
for presentation_order = 1:length(order_list)
    if PresentArray(presentation_order) == "Cong"
        if P_positon_EvenOrOdd(presentation_order) == 1
            if IP_position(presentation_order) == 3
               item_content = sprintf('cong_%d_3_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('cong_%d_3_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray(presentation_order) == "INcong"
        if P_positon_EvenOrOdd(presentation_order) == 1
            if IP_position(presentation_order) == 3
               item_content = sprintf('incong_%d_3_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('incong_%d_3_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Practice
%Create Group of Position 5
fprintf(fid,'<picture Patch_locate_5_practice>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (50%%,50%%)\n');
fprintf(fid,'  /items = ()\n');
fprintf(fid,'  /select = sequence\n');
fprintf(fid,'</picture>\n');
fprintf(fid,'<picture Patch_locate_5_practice_item>\n');
temp_5 = 0;
for presentation_order = 1:length(order_list_practice)
    if PresentArray_practice(presentation_order) == "Cong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 1
            if IP_position_practice(presentation_order) == 5
               item_content = sprintf('cong_%d_5_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('cong_%d_5_a.jpg',order_list_practice(presentation_order));
            end
            temp_5 = temp_5 + 1;
            fprintf(fid,'/%d = "%s"\n',temp_5,item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray_practice(presentation_order) == "INcong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 1
            if IP_position_practice(presentation_order) == 5
               item_content = sprintf('incong_%d_5_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('incong_%d_5_a.jpg',order_list_practice(presentation_order));
            end
            temp_5 = temp_5 + 1;
            fprintf(fid,'/%d = "%s"\n',temp_5,item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,'</picture>\n\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Formal
%Create Group of Position 5
fprintf(fid,'<picture Patch_locate_5>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (50%%,50%%)\n');
fprintf(fid,'  /items = (');
for presentation_order = 1:length(order_list)
    if PresentArray(presentation_order) == "Cong"
        if P_positon_EvenOrOdd(presentation_order) == 1
            if IP_position(presentation_order) == 5
               item_content = sprintf('cong_%d_5_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('cong_%d_5_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray(presentation_order) == "INcong"
        if P_positon_EvenOrOdd(presentation_order) == 1
            if IP_position(presentation_order) == 5
               item_content = sprintf('incong_%d_5_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('incong_%d_5_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Practice
%Create Group of Position 7
fprintf(fid,'<picture Patch_locate_7_practice>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (38.7%%,70%%)\n');
fprintf(fid,'  /items = ()\n');
fprintf(fid,'  /select = sequence\n');
fprintf(fid,'</picture>\n');
fprintf(fid,'<picture Patch_locate_7_practice_item>\n');
temp_7 = 0;
for presentation_order = 1:length(order_list_practice)
    if PresentArray_practice(presentation_order) == "Cong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 1
            if IP_position_practice(presentation_order) == 7
               item_content = sprintf('cong_%d_7_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('cong_%d_7_a.jpg',order_list_practice(presentation_order));
            end
            temp_7 = temp_7 + 1;
            fprintf(fid,'/%d = "%s"\n',temp_7,item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray_practice(presentation_order) == "INcong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 1
            if IP_position_practice(presentation_order) == 7
               item_content = sprintf('incong_%d_7_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('incong_%d_7_a.jpg',order_list_practice(presentation_order));
            end
            temp_7 = temp_7 + 1;
            fprintf(fid,'/%d = "%s"\n',temp_7,item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Formal
%Create Group of Position 7
fprintf(fid,'<picture Patch_locate_7>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (38.7%%,70%%)\n');
fprintf(fid,'  /items = (');
for presentation_order = 1:length(order_list)
    if PresentArray(presentation_order) == "Cong"
        if P_positon_EvenOrOdd(presentation_order) == 1
            if IP_position(presentation_order) == 7
               item_content = sprintf('cong_%d_7_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('cong_%d_7_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray(presentation_order) == "INcong"
        if P_positon_EvenOrOdd(presentation_order) == 1
            if IP_position(presentation_order) == 7
               item_content = sprintf('incong_%d_7_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('incong_%d_7_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Practice
fprintf(fid,'<picture Patch_locate_9_practice>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (61.3%%,70%%)\n');
fprintf(fid,'  /items = ()\n');
fprintf(fid,'  /select = sequence\n');
fprintf(fid,'</picture>\n');
fprintf(fid,'<picture Patch_locate_9_practice_item>\n');
temp_9 = 0;
for presentation_order = 1:length(order_list_practice)
    if PresentArray_practice(presentation_order) == "Cong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 1
            if IP_position_practice(presentation_order) == 9
               item_content = sprintf('cong_%d_9_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('cong_%d_9_a.jpg',order_list_practice(presentation_order));
            end
            temp_9 = temp_9 + 1;
            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray_practice(presentation_order) == "INcong"    
        if P_positon_EvenOrOdd_practice(presentation_order) == 1
            if IP_position_practice(presentation_order) == 9
               item_content = sprintf('incong_%d_9_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('incong_%d_9_a.jpg',order_list_practice(presentation_order));
            end
            temp_9 = temp_9 + 1;
            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Formal
%Create Group of Position 9
fprintf(fid,'<picture Patch_locate_9>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (61.3%%,70%%)\n');
fprintf(fid,'  /items = (');
for presentation_order = 1:length(order_list)
    if PresentArray(presentation_order) == "Cong"
        if P_positon_EvenOrOdd(presentation_order) == 1
            if IP_position(presentation_order) == 9
               item_content = sprintf('cong_%d_9_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('cong_%d_9_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray(presentation_order) == "INcong"    
        if P_positon_EvenOrOdd(presentation_order) == 1
            if IP_position(presentation_order) == 9
               item_content = sprintf('incong_%d_9_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('incong_%d_9_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');




%% Create Groups when IP in even position
%Practice
%Create Group of Position 2
fprintf(fid,'<picture Patch_locate_2_practice>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (50%%,30%%)\n');
fprintf(fid,'  /items = (');
temp_2 = 0;
for presentation_order = 1:length(order_list_practice)
    if PresentArray_practice(presentation_order) == "Cong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 0
            if IP_position_practice(presentation_order) == 2
               item_content = sprintf('cong_%d_2_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('cong_%d_2_a.jpg',order_list_practice(presentation_order));
            end
            temp_2 = temp_2 + 1;
            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray_practice(presentation_order) == "INcong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 0
            if IP_position_practice(presentation_order) == 2
               item_content = sprintf('incong_%d_2_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('incong_%d_2_a.jpg',order_list_practice(presentation_order));
            end
            temp_2 = temp_2 + 1;
            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Formal
%Create Group of Position 2
fprintf(fid,'<picture Patch_locate_2>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (50%%,30%%)\n');
fprintf(fid,'  /items = (');
for presentation_order = 1:length(order_list)
    if PresentArray(presentation_order) == "Cong"
        if P_positon_EvenOrOdd(presentation_order) == 0
            if IP_position(presentation_order) == 2
               item_content = sprintf('cong_%d_2_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('cong_%d_2_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray(presentation_order) == "INcong"
        if P_positon_EvenOrOdd(presentation_order) == 0
            if IP_position(presentation_order) == 2
               item_content = sprintf('incong_%d_2_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('incong_%d_2_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Practice
%Create Group of Position 4
fprintf(fid,'<picture Patch_locate_4_practice>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (38.7%%,50%%)\n');
fprintf(fid,'  /items = (');
temp_4 = 0;
for presentation_order = 1:length(order_list_practice)
    if PresentArray_practice(presentation_order) == "Cong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 0
            if IP_position_practice(presentation_order) == 4
               item_content = sprintf('cong_%d_4_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('cong_%d_4_a.jpg',order_list_practice(presentation_order));
            end
            temp_4 = temp_4 + 1;
            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray_practice(presentation_order) == "INcong"  
        if P_positon_EvenOrOdd_practice(presentation_order) == 0
            if IP_position_practice(presentation_order) == 4
               item_content = sprintf('incong_%d_4_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('incong_%d_4_a.jpg',order_list_practice(presentation_order));
            end
            temp_4 = temp_4 + 1;
            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Formal
%Create Group of Position 4
fprintf(fid,'<picture Patch_locate_4>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (38.7%%,50%%)\n');
fprintf(fid,'  /items = (');
for presentation_order = 1:length(order_list)
    if PresentArray(presentation_order) == "Cong"
        if P_positon_EvenOrOdd(presentation_order) == 0
            if IP_position(presentation_order) == 4
               item_content = sprintf('cong_%d_4_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('cong_%d_4_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray(presentation_order) == "INcong"  
        if P_positon_EvenOrOdd(presentation_order) == 0
            if IP_position(presentation_order) == 4
               item_content = sprintf('incong_%d_4_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('incong_%d_4_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Practice
%Create Group of Position 6
fprintf(fid,'<picture Patch_locate_6_practice>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (61.3%%,50%%)\n');
fprintf(fid,'  /items = (');
temp_6 = 0;
for presentation_order = 1:length(order_list_practice)
    if PresentArray_practice(presentation_order) == "Cong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 0
            if IP_position_practice(presentation_order) == 6
               item_content = sprintf('cong_%d_6_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('cong_%d_6_a.jpg',order_list_practice(presentation_order));
            end
            temp_6 = temp_6 + 1;
            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray_practice(presentation_order) == "INcong"   
        if P_positon_EvenOrOdd_practice(presentation_order) == 0
            if IP_position_practice(presentation_order) == 6
               item_content = sprintf('incong_%d_6_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('incong_%d_6_a.jpg',order_list_practice(presentation_order));
            end
            temp_6 = temp_6 + 1;
            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Formal
%Create Group of Position 6
fprintf(fid,'<picture Patch_locate_6>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (61.3%%,50%%)\n');
fprintf(fid,'  /items = (');
for presentation_order = 1:length(order_list)
    if PresentArray(presentation_order) == "Cong"
        if P_positon_EvenOrOdd(presentation_order) == 0
            if IP_position(presentation_order) == 6
               item_content = sprintf('cong_%d_6_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('cong_%d_6_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray(presentation_order) == "INcong"   
        if P_positon_EvenOrOdd(presentation_order) == 0
            if IP_position(presentation_order) == 6
               item_content = sprintf('incong_%d_6_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('incong_%d_6_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Practice
%Create Group of Position 8
fprintf(fid,'<picture Patch_locate_8_practice>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (50%%,70%%)\n');
fprintf(fid,'  /items = (');
temp_8 = 0;
for presentation_order = 1:length(order_list_practice)
    if PresentArray_practice(presentation_order) == "Cong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 0
            if IP_position_practice(presentation_order) == 8
               item_content = sprintf('cong_%d_8_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('cong_%d_8_a.jpg',order_list_practice(presentation_order));
            end
            temp_8 = temp_8 + 1;
            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray_practice(presentation_order) == "INcong"
        if P_positon_EvenOrOdd_practice(presentation_order) == 0
            if IP_position_practice(presentation_order) == 8
               item_content = sprintf('incong_%d_8_p.jpg',order_list_practice(presentation_order));
            else
               item_content = sprintf('incong_%d_8_a.jpg',order_list_practice(presentation_order));
            end
            temp_8 = temp_8 + 1;
            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Formal
%Create Group of Position 8
fprintf(fid,'<picture Patch_locate_8>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / position = (50%%,70%%)\n');
fprintf(fid,'  /items = (');
for presentation_order = 1:length(order_list)
    if PresentArray(presentation_order) == "Cong"
        if P_positon_EvenOrOdd(presentation_order) == 0
            if IP_position(presentation_order) == 8
               item_content = sprintf('cong_%d_8_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('cong_%d_8_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_Congruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    elseif PresentArray(presentation_order) == "INcong"
        if P_positon_EvenOrOdd(presentation_order) == 0
            if IP_position(presentation_order) == 8
               item_content = sprintf('incong_%d_8_p.jpg',order_list(presentation_order));
            else
               item_content = sprintf('incong_%d_8_a.jpg',order_list(presentation_order));
            end

            fprintf(fid,'"%s",\n',item_content);
            file_name = sprintf('%s%s',file_path_inCongruent_Patch,item_content);
            copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
        end
    end
end
fprintf(fid,')\n');
fprintf(fid,'/select = sequence\n');
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Practice
% Create Patch Random (N patch frame)
fprintf(fid,'<picture Patch_random_practice>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / hposition = values.x_coordinate\n');
fprintf(fid,'  / vposition = values.y_coordinate\n');
fprintf(fid,'  / items = (');
num_N_patch_practice = 0;
for numberOfTrial = 1:length(P_positon_EvenOrOdd_practice)
    if P_positon_EvenOrOdd_practice(numberOfTrial) == 0
        num_N_patch_practice = num_N_patch_practice + 16;
    elseif P_positon_EvenOrOdd_practice(numberOfTrial) == 1
        num_N_patch_practice = num_N_patch_practice + 15;
    end
end

n_patch_order_practice = randperm(7044,num_N_patch_practice);
for num_n_patches = 1:num_N_patch_practice
    string_order = num2str(n_patch_order_practice(num_n_patches).','%07d');
    fprintf(fid,'"patch%s.jpg",\n',string_order); 
    file_name = sprintf('%spatch%s.jpg',file_path_N_patches,string_order);
    copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
end
fprintf(fid,')\n');
fprintf(fid,'  / select = noreplace\n');
fprintf(fid,'</picture>\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Formal
% Create Patch Random (N patch frame)
fprintf(fid,'<picture Patch_random>\n');
fprintf(fid,'  / size = (20%%,20%%)\n');
fprintf(fid,'  / hposition = values.x_coordinate\n');
fprintf(fid,'  / vposition = values.y_coordinate\n');
fprintf(fid,'  / items = (');
num_N_patch = 0;
for numberOfTrial = 1:length(P_positon_EvenOrOdd)
    if P_positon_EvenOrOdd(numberOfTrial) == 0
        num_N_patch = num_N_patch + 16;
    elseif P_positon_EvenOrOdd(numberOfTrial) == 1
        num_N_patch = num_N_patch + 15;
    end
end

n_patch_order = randperm(7044,num_N_patch);
for num_n_patches = 1:num_N_patch
    string_order = num2str(n_patch_order(num_n_patches).','%07d');
    fprintf(fid,'"patch%s.jpg",\n',string_order); 
    file_name = sprintf('%spatch%s.jpg',file_path_N_patches,string_order);
    copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
end
fprintf(fid,')\n');
fprintf(fid,'  / select = noreplace\n');
fprintf(fid,'</picture>\n\n');


%% Create presentation list for defining ODD or EVEN (Practice Part)
fprintf(fid,'<item PresentationOrder_practice>\n');
EvenPosition = 'Even';
OddPosition = 'Odd';
for presentation_order = 1:length(order_list_practice)
    if P_positon_EvenOrOdd_practice(presentation_order) == 1
        fprintf(fid,'/%d = "%s" \n',presentation_order,OddPosition);
    elseif P_positon_EvenOrOdd_practice(presentation_order) == 0
        fprintf(fid,'/%d = "%s" \n',presentation_order,EvenPosition);
    end
end
fprintf(fid,'</item>\n\n');

%% Create presentation list for defining ODD or EVEN
fprintf(fid,'<item PresentationOrder>\n');
EvenPosition = 'Even';
OddPosition = 'Odd';
for presentation_order = 1:length(order_list)
    if P_positon_EvenOrOdd(presentation_order) == 1
        fprintf(fid,'/%d = "%s" \n',presentation_order,OddPosition);
    elseif P_positon_EvenOrOdd(presentation_order) == 0
        fprintf(fid,'/%d = "%s" \n',presentation_order,EvenPosition);
    end
end
fprintf(fid,'</item>\n\n');

%% List to define the image whether a Cong or Incong
fprintf(fid,'<item CongOrIncong>\n');
for presentation_order = 1:length(order_list)
    if PresentArray(presentation_order) == "Cong"
        fprintf(fid,'/%d = "Cong" \n',presentation_order);
    elseif PresentArray(presentation_order) == "INcong"
        fprintf(fid,'/%d = "Incong" \n',presentation_order);
    end
end
fprintf(fid,'</item>\n\n');

%% List to define whether an object in that patch(The list of location of the object patch)
fprintf(fid,'<item Object_Patch>\n');
for presentation_order = 1:length(order_list)
    fprintf(fid,'/%d = "%d"\n',presentation_order,IP_position(presentation_order));
end
fprintf(fid,'</item>\n\n');

%% List of Image ID
fprintf(fid,'<item Image_ID>\n');
for presentation_order = 1:length(order_list)
    fprintf(fid,'/%d = "%d"\n',presentation_order,order_list(presentation_order));
end
fprintf(fid,'</item>\n\n');


%% Instruction page
fprintf(fid,'<page intro>\n');
fprintf(fid,'^^Welcome to our experiment!\n');
% fprintf(fid,'^^In each trial of this experiment, you are asked to fixate on the cross located at the centre of the screen.\n');
% fprintf(fid,'^^Then, you will see an image flashed briefly on the screen, which will be quickly masked. \n');
% fprintf(fid,'^^After masking, you are asked to fixate on the centre cross again. And then, a small image patch will be flashed on the screen for a short time, after which the patch will be masked.\n');
% fprintf(fid,'^^You are asked to decide whether the small patch is a part of the presented image, and indicate how confident you are about your decision.\n');
% fprintf(fid,'^^Use a scale of 1-4 to describe your confidence(1 => Not confident at all; 4 => Highly confident).\n');
% fprintf(fid,'^^For each presented image, you will see 20 or 21 small patches(It means you need choose the answer and confidence 20 or 21 times for each presentated image)\n');
% fprintf(fid,'^^The session will take approximately 60 mins to complete\n');
% fprintf(fid,'^^\n^^\n');
% fprintf(fid,'^^If you are ready, please press ''Blank Button'' to begin the practice trials.\n');
fprintf(fid,'</page>\n');


fprintf(fid,'<page end>\n');
fprintf(fid,'^^This is the end of the experiment !\n');
fprintf(fid,'^^Thank you for your coorperation !\n');
fprintf(fid,'</page>\n');


fprintf(fid,'<instruct>\n');
fprintf(fid,'/ nextkey = (57)\n');
fprintf(fid,'/ fontstyle = ("Arial", 10%%, true)\n');
fprintf(fid,'/ screencolor = (127,127,127)\n');
fprintf(fid,'</instruct>\n');



fprintf(fid,'<expt Throughout>\n');
fprintf(fid,'/ preinstructions = (intro)\n');
fprintf(fid,'/ postinstructions = (end)\n');
fprintf(fid,'/ blocks = [');
fprintf(fid,'1 = consent;\n');
fprintf(fid,'2 = instruction_step;\n');
even_block = 'test_even';
even_block_practice = 'test_even_practice';
odd_block = 'test_odd';
odd_block_practice = 'test_odd_practice';
for presentation_order = 1:length(order_list_practice)
    if P_positon_EvenOrOdd_practice(presentation_order) == 0
        fprintf(fid,'%d = %s;\n',presentation_order+2,even_block_practice);
    elseif P_positon_EvenOrOdd_practice(presentation_order) == 1
        fprintf(fid,'%d = %s;\n',presentation_order+2,odd_block_practice);
    end
end

fprintf(fid,'%d = %s;\n',Total_Trial_number_practice+3,'start_test');
fprintf(fid,'%d = %s;\n',Total_Trial_number_practice+4,'start_attention');

for presentation_order = 1 : Total_Trial_number 
    if P_positon_EvenOrOdd(presentation_order) == 0
        fprintf(fid,'%d = %s;\n',presentation_order + Total_Trial_number_practice +4,even_block);
    elseif P_positon_EvenOrOdd(presentation_order) == 1
        fprintf(fid,'%d = %s;\n',presentation_order + Total_Trial_number_practice +4,odd_block);
    end
end
fprintf(fid,']\n');
fprintf(fid,'</expt>\n\n');
fclose(fid);


%     DesDir = sprintf('Subject_%d_Group_%d',subject,group);
%     mkdir('WebVersion\',DesDir);
%     Copy Commom Scripts
%     DST_PATH_t = ['WebVersion\',DesDir];%??????
    
end
end








