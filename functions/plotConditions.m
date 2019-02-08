function [ condition_values, mean_condition, std_condition, id] =...
    plotConditions(data_points, cond_values, cond_names,...
    grid_sizes, actin_threshs, plot_names)

%Get the number of unique grid sizes and threshold values 
unique_grids = unique(grid_sizes); 
gn = length(unique_grids); 
unique_thresh = unique(actin_threshs); 
afn = length(unique_thresh); 

%Save the number of condition names 
n_cond = length(cond_names); 

%Condition_values 
condition_values = cell(n_cond*gn*afn,1); 
mean_condition = zeros(n_cond*gn*afn,1);
std_condition = zeros(n_cond*gn*afn,1); 

%Open a figure
figure; 
hold on; 

%Get middle x value 
filter_x = zeros(size(unique_thresh));
f = 1; 

%Colors
colors = {[0.3686,0.0314,0.6471], [0.8000,0.0392,0.3529], ...
    [0.0392,0.6706,0.8000],[0.0235,0.6000,0.0588]};

%Start color counts 
c = 0; 

%Start counts
k = 1; 

%Create a ID store (:,1) Condition, (:,2) grid size (:,3) actin threshold 
id = zeros(n_cond*gn*afn,3); 

for g= 1:gn
    
    % Set up the grids to exclude 
    exclude_grid = zeros(size(grid_sizes)); 
    
    %Only open suplots if there is more than one grid
    if gn > 1
        subplot(gn,1,g); 
        hold on; 
        %Set the values that are not equal to the current grid size equal to
        %NaN. Otherwise, set the grid size to 1 
        exclude_grid(grid_sizes ~= unique_grids(g)) = NaN; 
        exclude_grid(~isnan(exclude_grid)) = 1; 
    
    end 
    
    %Set position equal to 0 
    p = 0; 
    
    for a = 1:afn
        % Set up the thresholds to exclude 
         exlude_thresh = zeros(size(actin_threshs)); 
            
        if afn > 1
            %Set the values that are not equal to the current threshold
            %size equal to NaN. Otherwise, set the grid size to 1 
            exlude_thresh(actin_threshs ~= unique_thresh(a)) = NaN; 
            exlude_thresh(~isnan(exlude_thresh)) = 1; 

        end 
        
        %Add the exclusion threshold and grids
        exlude_exploration = exclude_grid+exlude_thresh; 
        
        %Loop through all of the conditions 
        for n = 1:n_cond 
            %Increase color 
            if c > length(colors) || n == 1
                c = 1; 
            else
                c = c+1; 
            end 
            
            %Get the middle value
            x0 = (2*p+1)/2;             
            %Compute the x-axis
            x = p:p+1; 
           
            %Get values not equal to current condition
            exclude_cond = zeros(size(cond_values)); 
            exclude_cond(cond_values ~= n) = NaN; 
            %Add exlusions 
            exclusions = exlude_exploration + exclude_cond; 
            %Make sure that all of values that are non NaN are 0 
            exclusions(~isnan(exclusions)) = 0; 
            
            %Add the values plus the points to exclude 
            include_vals = data_points + exclusions; 

            %Reshape and remove NaN values
            include_vals = include_vals(:);
            include_vals(isnan(include_vals)) = []; 

            %Save data and calculate the mean and standard deviation. 
            condition_values{k,1} =include_vals; 
            mean_condition(k,1) = mean(include_vals); 
            std_condition(k,1) = std(include_vals); 

            %Save the (:,1) Condition, (:,2) grid size (:,3) actin threshold 
            id(k,1) = n; 
            id(k,2) = unique_grids(g); 
            id(k,3) = unique_thresh(a); 
            
            %Plot all of the points 
            plot(x0*ones(size(condition_values{k,1})),...
                condition_values{k,1},'.',...
                'MarkerSize', 8, ...
                'MarkerEdgeColor',colors{c},...
                'MarkerFaceColor',colors{c});

            %Plot the mean 
            plot(x, mean_condition(k,1)*ones(size(x)), ...
                '-','color',colors{c},'LineWidth',2);

            %Plot range of orientation values 
            fill([p, p+1, p+1, p], ...
                [mean_condition(k,1)-std_condition(k,1),...
                mean_condition(k,1)-std_condition(k,1), ...
                mean_condition(k,1)+std_condition(k,1), ...
                mean_condition(k,1)+std_condition(k,1)], ...
                colors{c}, 'FaceAlpha', 0.3,'linestyle','none');
            
            %Increate the count 
            k = k+1; 
            %Increase start and stop 
            p = p+1.5;
            
            if g == 1 && n == floor(n_cond/2) 
                %If there is an even number of conditions, get the middle
                %position for the x axis
                if mod(n_cond,2) == 1
                    filter_x(1,f) = x0; 
                else
                    filter_x(1,f) = (x0 + (2*p+1)/2)/2; 
                end 
                f = f+1; 
            end 
            
            if n == n_cond
                p = p+1; 
            end 
    
        end
        
    end
end

disp('after loop'); 
disp(id);
%Set the axis limits for the y axis 
buffer = 0.3*min(data_points(:)); 
if buffer < 0.1
    buffer = 0.1; 
end 

%Get the minimum and max median values 
ymin = min(data_points(:)) - buffer; 
ymax = max(data_points(:)) + buffer; 

for g = 1:gn 
    %Only open suplots if there is more than one grid
    if gn > 1
        subplot(gn,1,g); 
        hold on; 
    end 
    
    %Change axis limits
    ylim([ymin ymax]); 
    xlim([-2 p+1]); 

    %Change the x axis labels
    set(gca,'XTick',filter_x) 
    set(gca,'XTickLabel',num2cell(unique_thresh))

    %Change the font size
    set(gca, 'fontsize',12,'FontWeight', 'bold');

    %Change the x and y labels 
    xlabel(plot_names.x,'FontSize', 14, 'FontWeight', 'bold');
    ylabel(plot_names.y,'FontSize',...
        14, 'FontWeight', 'bold');
    
    if gn > 1
        %Change the title
        new_title = strcat(plot_names.title, {' '}, 'Grid Size:',...
            {' '}, num2str(unique_grids(g))); 
        title(new_title,'FontSize', 14, 'FontWeight', 'bold'); 
    else
        %Change the title 
        title(plot_names.title,...
            'FontSize', 14, 'FontWeight', 'bold'); 
    end 
    
end

%Save file
saveas(gcf, fullfile(plot_names.path, plot_names.savename), 'pdf');

%Make legend
figure; 
hold on; 

%Start position tracker 
p = 0; 

% Mean points 
legend_cond = [1;2.5;3]; 
legend_mean = mean(legend_cond); 
legend_std = std(legend_cond);

%Save labels 
vals = {plot_names.type,'Mean', 'St.Dev.'}; 

%Get legend titles 
legend_caption = cell(length(vals)*length(cond_names),1); 
%Temporary titles 

%Start color counter
c = 0; 

%Counter for legend
l=1; 
for n = 1:n_cond
    %Set the color 
    %Increase color 
    if c > length(colors) || n == 1
                c = 1; 
    else
        c = c+1; 
    end 

    %Get the middle value
    x0 = (2*p+1)/2; 

    %Compute the x-axis
    x = p:p+1; 
    
    %Plot the medians 
    plot(x0*ones(size(legend_cond)),...
        legend_cond,'.',...
        'MarkerSize', 8, ...
        'MarkerEdgeColor',colors{c},...
        'MarkerFaceColor',colors{c});
    
    %Temporary legend name 
    temp_name = strcat(cond_names{n}, {' '}, vals{1}); 
    legend_caption{l,1} = temp_name{1,1}; 
    l = l+1; 
    
    %Plot the mean 
    plot(x, legend_mean*ones(size(x)), ...
        '-','color',colors{c},'LineWidth',2);
    
    %Temporary legend name 
    temp_name = strcat(cond_names{n}, {' '}, vals{2}); 
    legend_caption{l,1} = temp_name{1,1}; 
    l = l+1; 
    
    %Plot range of orientation values 
    fill([p, p+1, p+1, p], ...
        [legend_mean-legend_std,...
        legend_mean-legend_std, ...
        legend_mean+legend_std, ...
        legend_mean+legend_std], ...
        colors{c}, 'FaceAlpha', 0.3,'linestyle','none');
   
    %Temporary legend name 
    temp_name = strcat(cond_names{n}, {' '}, vals{3}); 
    legend_caption{l,1} = temp_name{1,1}; 
    l = l+1; 
    
    %Increate the count 
    k = k+1; 
    %Increase start and stop 
    p = p+1.5;
    
end 

%Change the axis limits 
xlim([0 p+1.5]); 

%Create the legend 
legend(legend_caption); 

%Change the font size
set(gca, 'fontsize',12,'FontWeight', 'bold');

%Change the x and y labels 
xlabel(plot_names.x,'FontSize', 14, 'FontWeight', 'bold');
ylabel(plot_names.y,'FontSize',...
    14, 'FontWeight', 'bold');
%Change the title 
title('Legend','FontSize', 14, 'FontWeight', 'bold'); 
    
%Save the legend 
legend_save = strcat(plot_names.savename, '_legend'); 
saveas(gcf, fullfile(plot_names.path, legend_save), 'pdf');

disp('after legend'); 
disp(id);

end 
