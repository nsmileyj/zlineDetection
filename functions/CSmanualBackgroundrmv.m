% This function will be used to eliminate portions of the background that
% should be eliminated from analysis 

%% Select coverslip summary file
% Select the coverslip summary file
[ CS_name, CS_path,~ ] = load_files( {'*CS_Summary*.mat'}, ...
    'Select CS summary file for coverslip you would like to manually review...', pwd);

% Load the current coverslip
CS_data = load(fullfile(CS_path{1},CS_name{1,1})); 

% Get z-line image names 
zline_images = CS_data.CS_results.zline_images; 

%% Select orientation analysis files 
n = length(zline_images); 
FOV_names = cell(n,1); 
FOV_paths = cell(n,1); 
% Select the orientation analysis files 
for k = 1:n
    clc; 
    [p,f,e] = fileparts(fullfile(CS_path{1},zline_images{n})); 
    likelypath = fullfile(p,f); 
    [ temp_name, temp_path,~ ] = load_files( {'*OrientationAnalysis*.mat'}, ...
        'Select the orientation analysis file...', likelypath);
    FOV_names{k,1} = temp_name{1}; 
    FOV_paths{k,1} = temp_path{1}; 
end

%% Curate FOVs 
% For each FOV display the image and ask if the user would like to
% eliminate part of the background 

% Save modified number and their ID 
modn = 0; 
modbin = zeros(n,1); 
newFOV_names = cell(n,1); 

% Save today's date
date_format = 'yyyymmdd';
today_date = datestr(now,date_format);

% Select the orientation analysis files 
% for k = 1:n
for k = 1:1
    % Load the labeled image
    currentFOV = load(fullfile(FOV_paths{k,1},FOV_names{k,1}));
    % Load settings
    settings = currentFOV.settings; 
    % Load image struct  
    im_struct = currentFOV.im_struct; 
    % If exists, load the CZL struct and oop struct - maybe ???
    
    % Label the skeleton 
    [ labeled_im ] = ...
        labelSkeleton( mat2gray(im_struct.im), ...
        im_struct.skel_final_trimmed ); 
    %Display the iamge 
    figure; 
    imshow(labeled_im); 
    hold on; 
    
    % Add a colored purple mask 
    color_mask = zeros(size(labeled_im,1), size(labeled_im,2), 3);
    color = [219, 3, 252]./255;
    for h = 1:3
        color_mask(:,:,h) = color(h).*~im_struct.background;
    end 
    himage = imshow(color_mask);
    himage.AlphaData = 0.2;
    title('Z-lines are yellow; Background is shaded purple'); 
     
    % Ask the user if they'd like to remove parts of the background  
    answer = questdlg('Would you like to manually remove parts of the background?', ...
	'Modify Image', ...
	'Yes','No','Yes');

    % Close image 
    close; 
    % Handle response
    switch answer
        case 'Yes'
            % Increase the number modified
            modn = modn + 1; 
            modbin(k,1) = 1; 
            
            % Mask regions of the image 
            mask = modifyROI( mat2gray(im_struct.im), ...
                im_struct.skel_final_trimmed, false,im_struct.background);
            
            % Create and save an elimination struct
            manual_background_removal = struct(); 
            manual_background_removal.manual_mask = mask; 
            manual_background_removal.orientim_pre = im_struct.orientim; 
            manual_background_removal.background_pre = im_struct.background; 
            manual_background_removal.skeletonfinal_pre = im_struct.skel_final_trimmed; 
            manual_background_removal.skeletoninitial_pre = im_struct.skel_initial;
            
            % Store old z-line fraction and non z-line f raction 
            if isfield(im_struct, 'nonzlinefrac')
                manual_background_removal.nonzlinefrac_pre = ...
                    im_struct.nonzlinefrac; 
                im_struct.nonzlinefrac = NaN; 
            end  
            if isfield(im_struct, 'zlinefrac')
                manual_background_removal.zlinefrac_pre = ...
                    im_struct.zlinefrac; 
                im_struct.zlinefrac = NaN; 
            end  
          
            % Create new background 
            new_background = manual_background_removal.background_pre; 
            new_background(mask == 0) = 0; 
            manual_background_removal.background_new = new_background; 
            
            % Create new initial skeleton 
            new_skel = im_struct.skel_trim; 
            new_skel(new_background == 0) = 0; 
            manual_background_removal.skeletoninitial_new = new_skel; 
            
            % Save a new name 
            [p,f,e] = fileparts(fullfile(FOV_paths{k,1},FOV_names{k,1}));
            new_name = strcat(f,'_backRMV_',today_date,'.mat'); 
            new_name = appendFilename( FOV_paths{k,1}, new_name ); 
             newFOV_names{k,1} = new_name; 
             
            % Save the name in the struct 
            manual_background_removal.savefullname = ...
                fullfile(FOV_paths{k,1}, new_name); 
            % Save the data
            save(fullfile(FOV_paths{k,1}, new_name),...
                'manual_background_removal','im_struct','settings'); 
            
        otherwise
            newFOV_names{k,1} = FOV_names{k,1}; 
    end    
    
    clear currentFOV
    
end

%% Initialize matrices for re-creating of coverslip summary 

% Add path 
addpath('actin_filtering'); 
% Store the settings for the entire coverslip
settings = CS_data.settings; 


%%%%%%%%%%%%%%%%%%%%%%%% Initialize Matrices  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%>>> Actin Filtering analysis 
FOV_nonzlinefrac = cell(1,n);
FOV_zlinefrac = cell(1,n);
FOV_prefiltered = cell(1,n); 
FOV_postfiltered = cell(1,n); 
%>>> Continuous Z-line Analysis
FOV_lengths = cell(1,n); 
FOV_medians = cell(1,n); 
FOV_means = cell(1,n); 
FOV_sums = cell(1,n);  
%>>> Z-line Angle analysis
FOV_angles = cell(1,n);  
FOV_OOPs = cell(1,n); 
FOV_directors = cell(1,n); 
FOV_anglecount = cell(1,n); 
%>>> EXPLORATION Parameters
FOV_thresholds = cell(1,n); 
FOV_grid_sizes = cell(1,n); 
%>>> Actin angle analysis
ACTINFOV_angles = cell(1,n);  
ACTINFOV_OOPs = cell(1,n); 
ACTINFOV_directors = cell(1,n); 
ACTINFOV_anglecount = cell(1,n); 


%% Reanalyze the images, and compile 

% Loop through the number modified 
for k = 1:1
    % Load the labeled image
    currentFOV = load(fullfile(FOV_paths{k,1},FOV_names{k,1})); 
    
    % Store the image struct
    im_struct = currentFOV.im_struct; 
    
    % Recreate the orientation analysis 
    if modbin(k,1) == 1
        % Recreate the image struct 
        [im_struct] = ...
            reanalyzeManualMask(currentFOV.im_struct,currentFOV.settings,...
            currentFOV.manual_background_removal); 
        
        %>>>> CALCULATE OOP 
        %Create an OOP struct if the user requested. 
        if settings.tf_OOP && ~settings.exploration 
            %Create OOP_struct to save data 
            oop_struct = struct(); 
        end 
        
        %>>>> CONTINUOUS Z-LINE LENGTH 
        % If the user wants to calculate continuous z-line length 
        if settings.tf_CZL && ~settings.exploration 

            %Close all other figures so there isn't a chance of plotting
            %over anything
            close all; 

            %Calculate the continuous z-line length 
            FOV_lengths{1,k} = zlineCZL(im_struct, settings); 
            
            %Compute the median
            FOV_medians{1,k} = median( FOV_lengths{1,k} ); 

            % Compute the mean 
            FOV_means{1,k} = mean( FOV_lengths{1,k} ); 

            %Compute the sum 
            FOV_sums{1,k} = sum( FOV_lengths{1,k} ); 

            %Create a histogram of the distances
            figure; histogram(FOV_lengths{1,k});
            set(gca,'fontsize',16)
            hist_name = strcat('Median: ', num2str(FOV_medians{1,k}),' \mu m');
            title(hist_name,'FontSize',18,'FontWeight','bold');
            xlabel('Continuous Z-line Lengths (\mu m)','FontSize',18,...
                'FontWeight','bold');
            ylabel('Count','FontSize',18,'FontWeight','bold');

            %Save histogram as a tiff 
            fig_name = strcat( im_struct.im_name, '_CZLhistogram');
            saveas(gcf, fullfile(im_struct.save_path, fig_name), 'tiffn');

            %Close all of the images 
            close all;    
        end 
        
        
        
    else
        % >>>> Store OOP struct 
        if settings.tf_OOP && ~settings.exploration
            oop_struct = currentFOV.oop_struct; 
        end 
    end 
    
    %>>>> Store actin filter 
    %If the user is filtering with actin, save the actin orientation
    %vectors and calculate FOV if requested 
    if settings.actin_filt
        %Fraction for each FOV 
        FOV_nonzlinefrac{1,k} = im_struct.nonzlinefrac; 
        FOV_zlinefrac{1,k} = im_struct.zlinefrac; 

        %Get the post-filtered skeleton - used for CS calculation 
        temp_post = im_struct.skel_final;
        temp_post = temp_post(:);
        temp_post(temp_post == 0) = []; 

        %Get the pre filtering skeleton - used for CS calculation 
        temp_pre = im_struct.skel_trim; 
        temp_pre = temp_pre(:); 
        temp_pre(temp_pre == 0) = []; 

        %Store values for the CS calculation 
        FOV_prefiltered{1,k} = length(temp_pre); 
        FOV_postfiltered{1,k} = length(temp_post); 
            
        % Store the actin orientation vectors 
        ACTINFOV_angles{1,k} = im_struct.actin_struct.actin_orientim;

        %Save the orientation vectors as a new vairable
        temp_angles = ACTINFOV_angles{1,k}; 

        %Remove any NaN values or zero values 
        temp_angles(isnan(temp_angles)) = [];
        temp_angles(temp_angles == 0) = []; 

        %Save length
        ACTINFOV_anglecount{1,k} = length(temp_angles); 

        % >>>> Store actin OOP 
        if settings.tf_OOP && ~settings.exploration
            
            % Calculate OOP if need be, otherwise, store the OOP struct 
            if modbin(k,1) == 1
                [ oop_struct.ACTINoop, oop_struct.ACTINdirectionAngle, ~, ...
                    oop_struct.ACTINdirector ] = calculate_OOP( temp_angles ); 
            end 
            
            %Save the values in the the FOV matrix 
            ACTINFOV_OOPs{1,k} = oop_struct.ACTINoop;
            ACTINFOV_directors{1,k} = oop_struct.ACTINdirectionAngle; 
        end 
    end 
    
    %>>> STORE ORIENTATION VECTORS
    FOV_angles{1,k} = im_struct.orientim; 

    % get number of nonzero orientation vectors 
    %Save the orientation vectors as a new vairable
    temp_angles = FOV_angles{1,k}; 

    %If there are any NaN values in the angles matrix, set them to 0.
    temp_angles(isnan(temp_angles)) = [];
    temp_angles(temp_angles == 0) = []; 

    %Get the number of nonzero orientation angles 
    FOV_anglecount{1,k} = length(temp_angles); 

    %>>> EXPLORATION PARAMETERS
    FOV_thresholds{1,k} = settings.actin_thresh; 
    FOV_grid_sizes{1,k} = settings.grid_size(1);
            
        
end


    
    