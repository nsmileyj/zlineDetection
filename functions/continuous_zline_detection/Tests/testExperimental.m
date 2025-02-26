% This script is for testing purposes. 
% It contains code to analyze a specific section of a previously analyzed 
% image (requiring orientation vectors and binary skeletons). 
% It also contains synthetic data to test the code. 


%% Load an orientation analysis file 

%Temporarily store the path of continuous z-line detection  
temp_path = pwd; 

%Get the parts of the path 
pathparts = strsplit(temp_path,filesep);

%Set previous path 
previous_path = pathparts{1,1}; 

%Go back one folder 
for p =2:size(pathparts,2)-1
    if ~isempty(pathparts{1,p+1})
        previous_path = fullfile(previous_path, pathparts{1,p}); 
    end 
end 

%Add a backslash to the beginning of the path in order to use if this
%is a mac, otherwise do not
if ~ispc
    previous_path = strcat(filesep,previous_path);
end 
    
% Add the previous path to use functions
addpath(previous_path); 

%%
% Prompt the user to select the images they would like to analyze. 
[ orient_file, orient_path, ~ ] = ...
    load_files( {'*OrientationAnalysis.mat'}, ...
    'Select Orientation Analysis .mat file ...', pwd,'off');

% Load the orientation data 
orient_data = load(fullfile(orient_path{1}, orient_file{1})); 
im_struct = orient_data.im_struct; 
settings = orient_data.settings; 

% Set dot product error
dot_product_error = settings.dp_threshold; 
    
%% TEST REGION OF A SPECIFIC ANALYZED IMAGE 
% Display the image 
figure; imshow(mat2gray(im_struct.im)); 

% Select a section using the following command 
r = round(getrect()); 

disp('It is recomended to add this test case to the experimental test cases using addExperimentalTestCase.m'); 
%%
% Get only the orientation vectors in the selected section. 
sec_orientim = im_struct.orientim(r(2):r(2)+r(4), r(1):r(1)+r(3)); 
orientim = sec_orientim; 
orientim(isnan(orientim)) = 0;
angles = orientim; 

% Get the binary skeleton in the region 
sec_skel_final = ...
    im_struct.skel_final_trimmed(r(2):r(2)+r(4), r(1):r(1)+r(3));
positions = sec_skel_final; 

% Get the image in that region 
BW0 = mat2gray(im_struct.im); 
BW = BW0(r(2):r(2)+r(4), r(1):r(1)+r(3));

%% Get a smaller rectangle  

figure; imshow(sec_skel_final); 
r2 = round(getrect()); 

% Get the binary skeleton and orientation vectors in that region 
sec_skel_final2 = sec_skel_final(r2(2):r2(2)+r2(4), r2(1):r2(1)+r2(3)); 
sec_orientim2 = sec_orientim(r2(2):r2(2)+r2(4), r2(1):r2(1)+r2(3)); 

% Save in format for continuous z-line detection 
positions = sec_skel_final2;
BW = positions; 
orientim = sec_orientim2; 
orientim(isnan(orientim)) = 0;
angles = orientim; 

%% Get an even smaller rectangle  
figure; imshow(sec_skel_final2); 
r3 = round(getrect()); 

% Get the binary skeleton and orientation vectors in that region 
sec_skel_final3 = sec_skel_final2(r3(2):r3(2)+r3(4), r3(1):r3(1)+r3(3)); 
sec_orientim3 = sec_orientim2(r3(2):r3(2)+r3(4), r3(1):r3(1)+r3(3)); 

% Save in format for continuous z-line detection 
positions = sec_skel_final3;
BW = positions; 
orientim = sec_orientim3; 
orientim(isnan(orientim)) = 0;
angles = orientim; 

%% RUN CZL detection and get the relevant fields 
[ CZL_results, CZL_info ] = continuous_zline_detection( angles, BW, ...
    dot_product_error ); 

% Store the intermediate stages 
candidate_rows = CZL_info.candidate_rows;
candidate_cols = CZL_info.candidate_cols;
corrected_rows = CZL_info.corrected_rows;
corrected_cols = CZL_info.corrected_cols;
dp_rows = CZL_info.dp_rows;
dp_cols = CZL_info.dp_cols;
dp2_rows = CZL_info.dp2_rows;
dp2_cols = CZL_info.dp2_cols;
recip_cols = CZL_info.recip_cols;
recip_rows = CZL_info.recip_rows;

%% Visualize corrected neighbors 

%Color options 
col=['g', 'm', 'b', 'r'];
col = repmat( col, [1 , ceil( size(corrected_cols, 1) / size(col, 2))] ); 

figure;
magnification = 1000; 
imshow(positions, 'InitialMagnification', magnification); 
hold on; 
for h = 1:size(corrected_cols, 1)
    %Get coordinates temporarily
    x = corrected_cols(h,:)'; 
    y = corrected_rows(h,:)';     
    %Remove NaN values
    x(isnan(x)) = []; 
    y(isnan(y)) = []; 
    plot(x,y,'o', 'color', col(h)); 
    k = boundary(x,y);
    plot(x(k),y(k), '-', 'color', col(h));
    
    clear x y k 
end 

title('Corrected Neighbors', 'FontSize',16, 'FontWeight','bold' );

%% The accepted neighbors based on the dot product threshold 

figure; 
magnification = 1000; 
imshow(positions, 'InitialMagnification', magnification); 
hold on; 
for h = 1:size(dp_rows, 1)
    %Get coordinates temporarily
    x = dp_cols(h,:)'; 
    y = dp_rows(h,:)'; 
    %Remove NaN values
    x(isnan(x)) = []; 
    y(isnan(y)) = []; 
    plot(x,y,'o', 'color', col(h)); 
    plot(x,y, '-', 'color', col(h));
    clear x y 
end 

title('Accepted Neighbors', 'FontSize',16, 'FontWeight','bold' );

%% The accepted secondary neighbors

figure; 
magnification = 1000; 
imshow(positions, 'InitialMagnification', magnification); 
hold on; 
for h = 1:size(dp_rows, 1)
    %Get coordinates temporarily
    x = dp2_cols(h,:)'; 
    y = dp2_rows(h,:)'; 
    %Remove NaN values
    x(isnan(x)) = []; 
    y(isnan(y)) = []; 
    plot(x,y,'o', 'color', col(h)); 
    plot(x,y, '-', 'color', col(h));
    
    clear x y 
end 
title('Accepted Secondary Neighbors', 'FontSize',16, 'FontWeight','bold' );

%% The recipricol neighbors 

figure; 
magnification = 1000; 
imshow(positions, 'InitialMagnification', magnification); 
hold on; 
for h = 1:size(recip_cols, 1)
    %Get coordinates temporarily
    x = recip_cols(h,:)'; 
    y = recip_rows(h,:)'; 
    %Remove NaN values
    x(isnan(x)) = []; 
    y(isnan(y)) = []; 
    plot(x,y,'o', 'color', col(h)); 
    plot(x,y, '-', 'color', col(h));
    disp(h); 
    disp('x'); disp(x');
    disp('y'); disp(y'); 
    pause; 
    
    clear x y 
end 
title('Accepted Reciprocal Neighbors', 'FontSize',16, 'FontWeight','bold' );


%% Visualize each stage of the clustering 

% Cluster the values in order.  
[ zline_clusters , cluster_tracker, ignored_cases ] = ...
    cluster_neighbors( dot_product_error, angles, recip_rows, recip_cols, true); 

%% Plot the z-line clusters
[ distance_storage, rmCount, zline_clusters ] = ...
    calculate_lengths( BW, zline_clusters );