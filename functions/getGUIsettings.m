% getGUIsettings - For usage with zlineDetection.m ONLY. Collects all of 
% the options selected by the user and output them in a structural array
%
% Usage:
%  settings = getGUIsettings(handles,conversionOnly); 
%
% Arguments:
%   handles         - an object that indirectly references its data, which 
%                       is zlineDetection parameters from the GUI
%                       Class Support: OBJECT
% 	conversionOnly  - [optional] when true do not ask for additional
%                   	input, only convert parameters 
%                       Class Support: LOGICAL 
% Returns:
% 	settings        - structural array that contains the following
%                       parameters from the GUI:
%                       Class Support: STRUCT
% 
% Dependencies: 
%   MATLAB Version >= 9.5 
%   Functions: additionalUserInput.m
%
% Tessa Morris
% Advisor: Anna Grosberg
% Cardiovascular Modeling Laboratory 
% University of California, Irvine 
function settings = getGUIsettings(handles, conversionOnly)

% If there is only one arugment, set conversionOnly equal to false. 
if nargin == 1
    conversionOnly = false;
end 

%%%%%%%%%%%%%%%%%%%%%%% Hold over Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter that should be set because they should eventually be removed 
if ~conversionOnly
    % Reliability threshold 
    settings.reliability_thresh = 0; 
    % Use imbinarize to remove the background
    settings.rm_background = false; 
    % Display thresholding 
    settings.disp_bw = false; 
end

%%%%%%%%%%%%%%%%%%%%%%% Physical Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save the pixel to micron conversion 
settings.pix2um = str2double(get(handles.pix2um,'String'));

%Save pix2um as a local variable for simplicity 
pix2um = settings.pix2um; 
%%%%%%%%%%%%%%%%%%% Coherence Filter Parameteres %%%%%%%%%%%%%%%%%%%%%%%%%%
% Build the Coherence Filter structure array called Options. This will be
% used by "coherencefilter_version5b" Copyright (c) 2009, Dirk-Jan Kroon

% Create structures array to store the settings values 
Options = struct();

% Set the sigma of gaussian smoothing before calculation of the image 
% Hessian. The user input a value in microns, which should be converted
% into pixels before using
% Store biological user input 
settings.bio_sigma = str2double(get(handles.bio_sigma,'String'));
% Convert user input into pixels and then save in the structure array
Options.sigma = settings.bio_sigma.*pix2um; 

% Rho gives the sigma of the Gaussian smoothing of the Hessian.
% Store biological user input 
settings.bio_rho = str2double(get(handles.bio_rho,'String'));
% Convert user input into pixels and then save in the structure array
Options.rho = settings.bio_rho.*pix2um;

% Get the total diffusion time from the GUI
Options.T = str2double(get(handles.diffusion_time,'String'));

% PRESET VALUE. Set the diffusion time stepsize 
Options.dt = 0.15;

% PRESET VALUE. Set the numerical diffusion scheme that the program should 
% use. This will be set to 'I', Implicit Discretization (only works in 2D)
Options.Scheme = 'I';

% PRESET VALUE. Use Weickerts equation (plane like kernel) to make the 
% diffusion tensor. 
Options.eigenmode = 0;

% PRESET VALUE. Constant that determines the amplitude of the diffusion  in 
% smoothing Weickert equation
Options.C = 1E-10;

% PRESET VALUE. Show information about the filtering. This should be turned
% off. Options are 'none', 'iter' (default) , 'full'
Options.verbose = 'n'; 

% Save the Options in the settings struct. 
settings.Options = Options;

% Determine if the user wants to do a parameter exploration for the
% diffusion filter parameters
settings.diffusion_explore = get(handles.diffusion_explore,'Value');

%%%%%%%%%%%%%%%%%%%%%% Top Hat Filter Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%
% Radius of the flat disk-shaped structuring element used for the top hat
% filter

% Store biological user input 
settings.bio_tophat_size = str2double(get(handles.bio_tophat_size,'String'));
% Convert user input into pixels and then save in the structure array
settings.tophat_size = round( settings.bio_tophat_size.*pix2um ); 

%%%%%%%%%%%%%%%%%%% Background Removal Parameters %%%%%%%%%%%%%%%%%%%%%%%%

% Standard deviation of gaussian smoothing to perform on image 
settings.back_sigma = str2double(get(handles.back_sigma,'String'));
% Size of blocks to break image into 
settings.back_blksze = ...
    round(str2double(get(handles.back_blksze,'String')));
% Size of blocks considered "noise" in the condensed image
settings.back_noisesze = ...
    round(str2double(get(handles.back_noisesze,'String')));

%%%%%%%%%%%%%%%%%%% Threshold and Clean Parameters %%%%%%%%%%%%%%%%%%%%%%%%

% Size of small objects to be removed using bwareopen
settings.noise_area= round(str2double(get(handles.noise_area, 'String'))); 

%%%%%%%%%%%%%%%%%%%% Skeletonization Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save the minimum branch size to be included in analysis 
settings.bio_branch_size = str2double(get(handles.bio_branch_size, 'String'));
% Convert user input into pixels and then save in the structure array 
settings.branch_size = round( settings.bio_branch_size.*pix2um ); 

%%%%%%%%%%%%%%%%%%%%%%%%% Display Options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Display diffusion filter 
settings.disp_df = get(handles.disp_df,'Value');

% Display top hat filter
settings.disp_tophat = get(handles.disp_tophat, 'Value'); 

% % Display thresholding 
% settings.disp_bw = get(handles.disp_bw, 'Value'); 

% Display background  
settings.disp_back = get(handles.disp_back, 'Value'); 

% Display Noise Removal 
settings.disp_nonoise = get(handles.disp_nonoise, 'Value'); 

% Display Skeletonization 
settings.disp_skel = get(handles.disp_skel, 'Value'); 

%%%%%%%%%%%%%%%%%%%%%%% Actin Filtering Options %%%%%%%%%%%%%%%%%%%%%%%%%%%

% Option to filter with actin
settings.actin_filt = get(handles.actin_filt, 'Value');

% Display actin filtering
settings.disp_actin = get(handles.disp_actin, 'Value');

% Save the grid sizes for the rows and columns in an array 
grid_size(1) = round( str2double(get(handles.grid1, 'String')) );
grid_size(2) = round( str2double(get(handles.grid2, 'String')) );

% Store the grid sizes
settings.grid_size = grid_size; 

% Store the threshold for actin filtering
settings.actin_thresh = str2double(get(handles.actin_thresh, 'String')); 

% Store settings for actin threshold exploration 
settings.grid_explore = get(handles.grid_explore, 'Value'); 
% Store settings for actin grid size exploration 
settings.actinthresh_explore = get(handles.actinthresh_explore, 'Value'); 

%%%%%%%%%%%%%%%%%%%% Actin Detection Settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sigma of the derivative of Gaussian used to compute image gradients.
settings.actin_gradientsigma = (1/6.22)*pix2um; 
% Sigma of the Gaussian weighting used to sum the gradient moments.
settings.actin_blocksigma = (3/6.22)*pix2um;  
% Sigma of the Gaussian used to smooth the final orientation vector field.
settings.actin_orientsmoothsigma = (3/6.22)*pix2um;  

%%%%%%%%%%%%%%%%%%%%%%%%% Analysis Options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get option to calculate continuous z-line length 
settings.tf_CZL = get(handles.tf_CZL, 'Value'); 

% Save continuous z-line length dot product threshold 
settings.dp_threshold = str2double(get(handles.dp_threshold, 'String')); 

% Get option to calculate OOP 
settings.tf_OOP = get(handles.tf_OOP, 'Value');

% Number of coverslips
settings.num_cs = str2double(get(handles.num_cs, 'String'));

% Save type of image (single cell vs. tissue)
settings.cardio_type = get(handles.cardio_type, 'Value'); 

% Settings
settings.multi_cond = get(handles.multi_cond, 'Value'); 

%%%%%%%%%%%%%%%%%% Check if the User Wants Any Analysis %%%%%%%%%%%%%%%%%%%

%If the user doesn't want to filter with actin, calcualte continuous 
%z-line length, calculate OOP there is nothing to compare between
%conditions. Therefore do not create summary files 
settings.analysis = true; 
if ~settings.tf_CZL && ~settings.tf_OOP && ~settings.actin_filt
    settings.analysis = false; 
end 

%%%%%%%%%%%%%%%%%%%%% Additional User Inputs  %%%%%%%%%%%%%%%%%%%
% Only get additional user input if this is more than just a conversion 
if ~conversionOnly
    settings = additionalUserInput(settings);
end 
end