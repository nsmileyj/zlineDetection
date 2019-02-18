function [settings] = additionalUserInput(settings)
%If the user would like to do a parameter exploration of any kind, ask for
%additional information here         
                     
% Set exploration equal to true if the user is doing any kind of
% exploration 
if settings.grid_explore || settings.actinthresh_explore
    %Set exploration equal to true
    settings.exploration = true; 
    %Create a struct to store the parameters
    actin_explore = struct(); 
else 
    %Save the exploration settings to false
    settings.exploration = false; 
    %Set the struct to NaN 
    actin_explore = NaN; 
end 

% Grid exploration range  
if settings.grid_explore
    %Prompt Questions
    grid_prompt = {'Smallest Grid:','Largest Grid:',...
        'Step Size:'};
    %Title of prompt 
    grid_title = 'Grid Size Exploration';
    %Dimensions 
    grid_dims = [1,45];
    %Default inputs
    grid_definput = {'10', '30','10'}; 
    %Save answers
    grid_answer = inputdlg(grid_prompt,grid_title,...
    grid_dims,grid_definput);
    
    %Store the grid answers
    actin_explore.grid_min = round(str2double(grid_answer{1}));
    actin_explore.grid_max = round(str2double(grid_answer{2}));
    actin_explore.grid_step = round(str2double(grid_answer{3}));
end 

% Actin threshold exploration range 
if settings.actinthresh_explore
    %Prompt Questions
    thresh_prompt = {'Minimum Threshold:','Max Threshold:',...
        'Step Size:'};
    %Title of prompt
    thresh_title = 'Actin Filtering Parameter Exploration';
    %Dimensions
    thresh_dims = [1 60];
    %Default inputs
    thresh_definput = {'0.7','1','0.05'};
    %Save answers
    thresh_answer = inputdlg(thresh_prompt,thresh_title,...
        thresh_dims,thresh_definput);
    
    %Store prompt answers in the actin_explore struct 
    actin_explore.min_thresh = str2double(thresh_answer{1});
    actin_explore.max_thresh = str2double(thresh_answer{2});
    actin_explore.thresh_step = str2double(thresh_answer{3});

    %Check to make sure that the values are in range 
    actin_explore.min_thresh(actin_explore.min_thresh<0) = 0; 
    actin_explore.max_thresh(actin_explore.min_thresh>1) = 1; 
    actin_explore.thresh_step(actin_explore.thresh_step <= 0 || ...
        actin_explore.thresh_step >= 1) = 0.05;    
end 

%Save the actin_explore struct in settings
settings.actin_explore = actin_explore; 

%Get the number of conditions and names 
if settings.multi_cond
    %Prompt Questions
    num_prompt = {'Number of conditions to compare:'};
    %Title of prompt
    num_title = 'Conditions';
    %Dimensions
    num_dims = [1 40];
    %Default inputs
    num_definput = {'2'};
    %Save answers
    num_answer = inputdlg(num_prompt,num_title,...
        num_dims,num_definput);
    
    %Store the number of conditions 
    settings.num_cond = round(str2double(num_answer{1}));
    
    %Ask the user for the name of the conditions 
    type_prompt = cell(1,settings.num_cond);
    pre = 'Name of Condition';
    for k = 1:settings.num_cond
        temp_text = strcat(pre, {' '}, num2str(k), ': ');
        type_prompt{1,k} = temp_text{1,1}; 
    end 
    
    %Title of prompt
    type_title = 'Condition Names';
    %Dimensions
    type_dims = [1 45];

    %Save answer
    settings.cond_names = inputdlg(type_prompt,type_title,...
        type_dims);
end

%Get the name and location of summary file if there is more than one
%coverslip and the user wants to do any kind of analysis 
if settings.num_cs > 1 && settings.analysis
    %Display message to select path 
    disp('Select a location to save summary analysis for all Coverslips'); 
    %Ask the user for the location of the summary file 
    settings.SUMMARY_path = uigetdir(pwd,'Save Location for Summary Files'); 
    
    %Get the parts of the summary path 
    pathparts = strsplit(settings.SUMMARY_path,filesep); 
    
    %Find the location of the current folder 
    potential_end = size(pathparts,2); 
    while isempty(pathparts{1,potential_end})
        potential_end = potential_end -1; 
    end 
    
    %Get the name of folder 
    base_name = pathparts{1,potential_end}; 
    
    %Get today's date
    date_format = 'yyyymmdd';
    today_date = datestr(now,date_format);
    
    %Suggested suggested name for files  
    suggested_name = strcat(base_name, '_MultiCondSummary_',today_date);
    
    %Ask the user for the summary name 
    %Prompt Questions
    sumname_prompt = {'Name of Summary File for Multiple Coverslips (no extension):'};
    %Title of prompt
    sumname_title = 'Summary File Name';
    %Dimensions
    sumname_dims = [1 80];
    %Default inputs
    sumname_definput = {suggested_name};
    %Save answers
    settings.SUMMARY_name = inputdlg(sumname_prompt,sumname_title,...
        sumname_dims,sumname_definput);
end 

%Get the base location of the coverslips if there is more than one
%coverslip 
if settings.num_cs > 1 && ~settings.analysis
    %Display message to select path 
    disp('Select folder containg multiple coverslips'); 
    %Ask the user for the location of the summary file 
    settings.SUMMARY_path = uigetdir(pwd,...
        'Location of coverslips'); 
    
end 


end

