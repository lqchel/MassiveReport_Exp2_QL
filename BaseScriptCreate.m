clc
clear
% % Create the Base of Congruent Image Presentation
% Version for NEST FOLDER
file_path_Congruent_Patch = 'congruent patch\';
file_path_inCongruent_Patch = 'incongruent patch\';
file_path_N_patches = 'nishimoto patch\';
file_path_CongruentCropped = 'squareimage\congruent cropped\';
file_path_InCongruentCropped = 'squareimage\incongruent cropped\';
file_path_mask = 'mask\';
file_path_patch_mask = 'maskCrop\';


% Version For individual folder
% file_path_Congruent_Patch = 'congruent patch\';
% file_path_inCongruent_Patch = 'incongruent patch\';
% file_path_N_patches = 'nishimoto patch\';
% file_path_CongruentCropped = 'squareimage\congruent cropped\';
% file_path_InCongruentCropped = 'squareimage\incongruent cropped\';
% file_path_mask = 'mask\';
% file_path_patch_mask = 'maskCrop\';

Total_Trial = 34; %% Define how many images are used to presentation
Total_Trial_practice = 3;
Total_Trial_number = Total_Trial + Total_Trial_practice;
Number_of_Masking = 20;
Number_of_Null = 117; % number of null patches per group
Null_per_trial = 3; % number of null patches each trial
Number_of_Batch = 4;
Number_of_Group = 4;
Number_of_Subjects = 15; % number of subjects per group
Total_Null_Number = Number_of_Null*Number_of_Batch*Number_of_Group;

%% Prepare Null Patch Stimuli for All Batches 
all_n_patch = 1:7044;
all_n_patch(mod(all_n_patch,4) == 0) = []; % null patch locations go from 1-12, here we exclude null patches position 4, 8 and 12
n_patch_order = all_n_patch(1:Total_Null_Number);

%%
for batch = 1:Number_of_Batch
    %%Allocate the square images in each batch: same 3 images for practice,
    %%then different batches of images for experiment trials
    order_list_group = 1:1:140;
    order_list = [137 138 139 order_list_group(1 + Total_Trial*(batch-1):Total_Trial + Total_Trial*(batch-1))];
    
    % combination: sequences of image-patch combination for each image;    
    % for each image pair, cong img-cong object patch(1), cong img-incong (2), 
    % incong-cong(3), incong-incong(4). Here, for image n, if in combination
    % 1, it's cong-incong, then in combination 2, it's image-patch can
    % be cong-cong, incong-cong, or incong-incong. here,generate 4 groups, 
    % each with unique image-patch combination for each image pair
    combination_sequence = zeros(Total_Trial_Number,4);
    combination_sequence(1:3,:) = [1 2 4 3; 2 3 1 4; 3 4 1 2];
    for t = 1:Total_Trial
        combination_sequence(t+3,:) = randperm(4,4); 
    end
    

%% Select stimuli common for participants allocated to the same group 
    for group = 1:Number_of_Group
    DesDir = sprintf('Batch_%d_Group_%d_',batch,group); % save all materials for experiments of the same batch and combination in one folder
    %DesDir = sprintf('QL_Exp2_demo');
    mkdir('WebVersion\',DesDir);
    DST_PATH_t = ['WebVersion\',DesDir];
    order_list_Masking = randperm(140,Number_of_Masking);
        
%% Specify where the CP located 
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
%% Specify CP Patch Location Coordinates

    CP_x_coordinates = string(ones(1,Total_Trial_number));
    CP_y_coordinates = string(ones(1,Total_Trial_number));
    for presentation_number = 1:Total_Trial_number
        if IP_position(presentation_number) == 1 || IP_position(presentation_number) == 4 || IP_position(presentation_number) == 7
            CP_x_coordinates(presentation_number) = "33.3";
        elseif IP_position(presentation_number) == 2 || IP_position(presentation_number) == 5 || IP_position(presentation_number) == 8
            CP_x_coordinates(presentation_number) = "50";
        elseif IP_position(presentation_number) == 3 || IP_position(presentation_number) == 6 || IP_position(presentation_number) == 9
            CP_x_coordinates(presentation_number) = "66.7";
        end    
    end

    for presentation_number = 1:Total_Trial_number
        if IP_position(presentation_number) == 1 || IP_position(presentation_number) == 2 || IP_position(presentation_number) == 3
            CP_y_coordinates(presentation_number) = "25";
        elseif IP_position(presentation_number) == 4 || IP_position(presentation_number) == 5 || IP_position(presentation_number) == 6
            CP_y_coordinates(presentation_number) = "50";
        elseif IP_position(presentation_number) == 7 || IP_position(presentation_number) == 8 || IP_position(presentation_number) == 9
            CP_y_coordinates(presentation_number) = "75";
        end    
    end           
            
%% Select Null Patches for current group
    % select unique set of null patches for each group 
    Current_group_across_batch = (batch-1).*4 + group;
    group_null_patch = n_patch_order(1+(Current_group_across_batch-1) * Number_of_Null:Current_group_across_batch * Number_of_Null);
    temp = randperm(length(group_null_patch),length(group_null_patch));
    for i = 1:length(group_null_patch)
    group_null_patch(i) = group_null_patch(temp(i)); % randomize null patch sequence
    end    

    for group_null_list = 1:length(group_null_patch)
        string_order = num2str(group_null_patch(group_null_list).','%07d');
        fprintf(fid,'"patch%s.jpg",\n',string_order);
        file_name = sprintf('%spatch%s.jpg',file_path_N_patches,string_order);
        copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
    end
    
%% Select Stimuli Unique to Each Participant, and Write Stimuli Info on Separate Base-script for Each Participant           
        for subject = 1:Number_of_Subjects
            filename = sprintf('BaseScript_B%d_C%d_S%d.iqx',batch,group,subject); 
            fid = fopen(filename,'w');
            NumberOfNpatch = 7044;
            
%% Create and Write List of Images in Base Script 
%Need to mix the congruent and Incongruent images throughout the experiment
            fprintf(fid,'<item image_presentation>\n'); %Only create the congruent part
            PresentArray = string(ones(1,Total_Trial_number)); %Pre-create an array to represent the order of presentation image for INCONG and CONG        
            % copy file names
            for presentation_number = 1:Total_Trial_number
                if combination_sequence(presentation_number,group) == 1 || combination_sequence(presentation_number,group) == 2
                    PresentArray(presentation_number) = 'Cong';
                    string_order = num2str(order_list(presentation_number).','%03d');
                    address = sprintf('"%s%s.jpg"','SquareCongruent_',string_order);
                    file_name = sprintf('%s%s%s.jpg',file_path_CongruentCropped,'SquareCongruent_',string_order); 
                    fprintf(fid,'/%d = ',presentation_number);
                    fprintf(fid,'%s\n',address);
                    copyfile(file_name,DST_PATH_t);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COPY
                elseif combination_sequence(presentation_number,group) == 3 || combination_sequence(presentation_number,group) == 4
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

%% Create and Write list of image-patch combination
            fprintf(fid,'<item image_patch_combination>\n');     
                for presentation_number = 1:Total_Trial_number
                    fprintf(fid,'/%d = "%s%%"\n',presentation_number,num2str(combination_sequence(presentation_number,group)));
                end
            fprintf(fid,'</item>\n\n');

%% Create and Write List of Masking and the masking for patches
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

            
%% Write CP patch
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

%% Write coordinates for CP positions

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

%% Create group of position 1
            fprintf(fid,'<picture Patch_locate_1_present>\n');
            fprintf(fid,'  / size = (values.present_image_size,values.present_image_size)\n');
            fprintf(fid,'  / position = (50%%,50%%)\n');
            fprintf(fid,'  /items = ("location1.png")\n');
            fprintf(fid,'  /select = sequence\n');
            fprintf(fid,'</picture>\n\n');
            
%% Create group of position 2
            fprintf(fid,'<picture Patch_locate_2_present>\n');
            fprintf(fid,'  / size = (values.present_image_size,values.present_image_size)\n');
            fprintf(fid,'  / position = (50%%,50%%)\n');
            fprintf(fid,'  /items = ("location2.png")\n');
            fprintf(fid,'  /select = sequence\n');
            fprintf(fid,'</picture>\n\n');
            
%% Create group of position 3
            %Create Group of Position 3
            fprintf(fid,'<picture Patch_locate_3_present>\n');
            fprintf(fid,'  / size = (values.present_image_size,values.present_image_size)\n');
            fprintf(fid,'  / position = (50%%,50%%)\n');
            fprintf(fid,'  /items = ("location3.png")\n');
            fprintf(fid,'  /select = sequence\n');
            fprintf(fid,'</picture>\n\n');
            
            
%% Create group of position 4
            fprintf(fid,'<picture Patch_locate_4_present>\n');
            fprintf(fid,'  / size = (values.present_image_size,values.present_image_size)\n');
            fprintf(fid,'  / position = (50%%,50%%)\n');
            fprintf(fid,'  /items = ("location4.png")\n');
            fprintf(fid,'  /select = sequence\n');
            fprintf(fid,'</picture>\n\n');
            
%% Create group of position 5
            %Create Group of Position 5
            fprintf(fid,'<picture Patch_locate_5_present>\n');
            fprintf(fid,'  / size = (values.present_image_size,values.present_image_size)\n');
            fprintf(fid,'  / position = (50%%,50%%)\n');
            fprintf(fid,'  /items = ("location5.png")\n');
            fprintf(fid,'  /select = sequence\n');
            fprintf(fid,'</picture>\n\n'); 
            
%% Create group of position 6
            fprintf(fid,'<picture Patch_locate_6_present>\n');
            fprintf(fid,'  / size = (values.present_image_size,values.present_image_size)\n');
            fprintf(fid,'  / position = (50%%,50%%)\n');
            fprintf(fid,'  /items = ("location6.png")\n');
            fprintf(fid,'  /select = sequence\n');
            fprintf(fid,'</picture>\n\n');
            
            
%% Create group of position 7
%Create Group of Position 7
            fprintf(fid,'<picture Patch_locate_7_present>\n');
            fprintf(fid,'  / size = (values.present_image_size,values.present_image_size)\n');
            fprintf(fid,'  / position = (50%%,50%%)\n');
            fprintf(fid,'  /items = ("location7.png")\n');
            fprintf(fid,'  /select = sequence\n');
            fprintf(fid,'</picture>\n\n');
            
        
%% Create group of position 8
            fprintf(fid,'<picture Patch_locate_8_present>\n');
            fprintf(fid,'  / size = (values.present_image_size,values.present_image_size)\n');
            fprintf(fid,'  / position = (50%%,50%%)\n');
            fprintf(fid,'  /items = ("location8.png")\n');
            fprintf(fid,'  /select = sequence\n');
            fprintf(fid,'</picture>\n\n');
            
            
%% Create group of position 9
%Create Group of Position 9
            fprintf(fid,'<picture Patch_locate_9_present>\n');
            fprintf(fid,'  / size = (values.present_image_size,values.present_image_size)\n');
            fprintf(fid,'  / position = (50%%,50%%)\n');
            fprintf(fid,'  /items = ("location9.png")\n');
            fprintf(fid,'  /select = sequence\n');
            fprintf(fid,'</picture>\n\n');

%% Create and Write Null Patch List for Each Participant
%%% Null patches are selected to make sure each participant have a unique
%%% image - null patches combination for each image pair. For example,
%%% participant 1 views null patch 1-3 for image 1, 4-6 for image 2, 109 -
%%% 111 for image 37 
%%% participant 2 views null patch 4-6 for image 1, 7-9 for image 2, etc...
%%% participant 15 views null patch 43 - 45 for image 1, ... null patch 34
%%% - 36 for image 37
            sequence_start_point = 1+(subject-1)*Null_per_trial; % shifts for every subject
            sequence_end_point = sequence_start_point + Total_Trial_Number*Null_per_trial;           
            if sequence_end_point <= Number_of_Null
                subject_null_sequence = group_null_patch(sequence_start_point:sequence_end_point);
            else
                end_point_from_beginning = sequence_end_point-sequence_start_point;
                subject_null_sequence = [group_null_patch(sequence_start_point:end) group_null_patch(1:end_point_from_beginning)];
            end
            
            % print select null patch file nemaes
            fprintf(fid,'<picture nPatch_resource>\n');
            fprintf(fid,'  / size = (values.present_image_size/3,values.present_image_size/3)\n');
            fprintf(fid,'  /items = (');
            
            for n_patch_list = 1:length(subject_null_sequence)
                string_order = num2str(subject_null_sequence(n_patch_list).','%07d');
                fprintf(fid,'"patch%s.jpg",\n',string_order);
            end
            fprintf(fid,')\n');
            fprintf(fid,'  / select = sequence\n');
            fprintf(fid,'</picture>\n\n');
            
            % print null patch locations
            n_patch_location = mod(subject_null_sequence,12); % record location of null patches
            Null_x_coordinates = string(ones(1,Total_Trial_number));
            Null_y_coordinates = string(ones(1,Total_Trial_number));
            for n_patch_list = 1:length(subject_null_sequence)
                if n_patch_location(n_patch_list) == 1 || n_patch_location(n_patch_list) == 5 || n_patch_location(n_patch_list) == 9
                    Null_x_coordinates(n_patch_list) = "33.3";
                elseif IP_position(n_patch_list) == 2 || n_patch_location(n_patch_list) == 6 || n_patch_location(n_patch_list) == 10
                    Null_x_coordinates(n_patch_list) = "50";
                elseif n_patch_location(n_patch_list) == 3 || n_patch_location(n_patch_list) == 7 || n_patch_location(n_patch_list) == 11
                    Null_x_coordinates(n_patch_list) = "66.7";
                end    
            end

            for n_patch_list = 1:length(subject_null_sequence)
                if n_patch_location(n_patch_list) == 1 || n_patch_location(n_patch_list) == 2 || n_patch_location(n_patch_list) == 3
                    Null_y_coordinates(n_patch_list) = "25";
                elseif n_patch_location(n_patch_list) == 5 || n_patch_location(n_patch_list) == 6 || n_patch_location(n_patch_list) == 7
                    Null_y_coordinates(n_patch_list) = "50";
                elseif n_patch_location(n_patch_list) == 9 || n_patch_location(n_patch_list) == 10 || n_patch_location(n_patch_list) == 11
                    Null_y_coordinates(n_patch_list) = "75";
                end    
            end    
            
            fprintf(fid,'<item Null_x_coordinates>\n');
            for n_patch_list = 1:length(subject_null_sequence)
                fprintf(fid,'/%d = "%s%%"\n',n_patch_list,Null_x_coordinates(n_patch_list));
            end
            fprintf(fid,'</item>\n\n');

            fprintf(fid,'<item Null_y_coordinates>\n');
            for n_patch_list = 1:length(subject_null_sequence)
                fprintf(fid,'/%d = "%s%%"\n',n_patch_list,Null_y_coordinates(n_patch_list));
            end
            fprintf(fid,'</item>\n\n');            
            
%% List to define the image and object patch whether a Cong or Incong
            fprintf(fid,'<item Image_CongOrIncong>\n');
            for presentation_order = 1:length(order_list)
                if PresentArray(presentation_order) == "Cong"
                    fprintf(fid,'/%d = "Cong" \n',presentation_order);
                elseif PresentArray(presentation_order) == "INcong"
                    fprintf(fid,'/%d = "Incong" \n',presentation_order);
                end
            end
            fprintf(fid,'</item>\n\n');
            
            fprintf(fid,'<item Patch_CongOrIncong>\n');
            for presentation_order = 1:length(order_list)
                if combination_sequence(presentation_number,group) == 1 || combination_sequence(presentation_number,group) == 3
                    fprintf(fid,'/%d = "Cong" \n',presentation_order);
                elseif combination_sequence(presentation_number,group) == 1 || combination_sequence(presentation_number,group) == 3
                    fprintf(fid,'/%d = "Incong" \n',presentation_order);
                end
            end
            fprintf(fid,'</item>\n\n');

%% The list of location of the object patches
            fprintf(fid,'<item Object_Patch>\n');
            for presentation_order = 1:length(order_list)
                fprintf(fid,'/%d = "%d"\n',presentation_order,IP_position(presentation_order));
            end
            fprintf(fid,'</item>\n\n');
            
%% Here used to specify where positions of the other two present patches (formal experiment)

            Present_patch_1 = ones(1,length(order_list));
            Present_patch_2 = ones(1,length(order_list));
            Odd_position = [1 3 5 7 9];
            Even_position = [2 4 6 8];

            for presentation_order = 1:length(order_list)

                if mod(IP_position(presentation_order),2) == 0
                    selection_index = randperm(3,2);
                    remaining_positions = Even_position(Even_position ~= IP_position(presentation_order));
                else
                    selection_index = randperm(4,2);
                    remaining_positions = Odd_position(Odd_position ~= IP_position(presentation_order));
                end

                Present_patch_1(presentation_order) = remaining_positions(selection_index(1));
                Present_patch_2(presentation_order) = remaining_positions(selection_index(2));

                clear object_absent_patches
            end

%% Create list of present patch positions

            fprintf(fid,'<item Present_1_position>\n'); % present patch 1
            for presentation_order = 1:length(order_list)
                    fprintf(fid,'/%d = "%s" \n',presentation_order,num2str(Present_patch_1(presentation_order)));
            end
            fprintf(fid,'</item>\n\n');

            fprintf(fid,'<item Present_2_position>\n'); % present patch 2
            for presentation_order = 1:length(order_list)
                    fprintf(fid,'/%d = "%s" \n',presentation_order,num2str(Present_patch_2(presentation_order)));
            end
            fprintf(fid,'</item>\n\n');

%% List of Image ID
            fprintf(fid,'<item Image_ID>\n');
            for presentation_order = 1:length(order_list)
                fprintf(fid,'/%d = "%d"\n',presentation_order,order_list(presentation_order));
            end
            fprintf(fid,'</item>\n\n');

        end

    end
 
end














