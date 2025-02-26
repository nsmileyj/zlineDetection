
% data_vals     - N x 1 data
% data_labels - set to conidtion names
% 

function [ cond_des, mean_condition, std_condition ] =...
    plotConditions(data_vals, data_labels, plot_settings, plot_names, doHold, dontSave)

if nargin < 5
    doHold = false;
end
if ~doHold
    % Open a figure
    fig_handle=figure; 
else
    fig_handle = get(groot,'CurrentFigure');
end

if nargin < 6
    dontSave = false; 
end 

% Change the xtick labels 
plot_settings.xtick = 1:length(unique(data_labels)); 

% Set the color scheme 
plot_settings.colors = {[0.3686,0.0314,0.6471],[0.0745,0.9686,0.6863],...
    [0.8000,0.0392,0.3529],[0.0392,0.6706,0.8000],...
    [0.9569,0.6784,0.2588],[0.0235,0.6000,0.0588],...
    [0.6275,0.6275,0.6275],[1,0.6,1],[0.2789,0.4479,0.6535],...
    [0.9569,0.9059,0.3529],[0.0824,0.4000,0.9490],...
    [0.9882,0.2980,0.2353]};

% Set the x-tick rotation 
plot_settings.xtickrotation = -30; 

% Change line width 
plot_settings.linewidth = 2; 
% Set the type of box plot equal to mean
plot_settings.typeMean = true; 

% Plot the mean and standard deviation 
[ cond_des, mean_condition, meanpmstd_condition ] = ...
    boxPlot( data_vals, plot_settings, data_labels );

% Change the marker size
plot_settings.markersize = 5; 
% Change the edge of the marker to have a black border 
plot_settings.markercoloredge = {'k'}; 
plot_settings.linewidth = 0.25;

% Plot the mean and standard deviation 
makeDotPlot(data_vals, plot_settings, data_labels );



%Gather Statistics

%Create a vector of condition names
condName_temp = plot_settings.xticklabel; %load condition names
%CondID_temp = data_labels; %load the condition IDs temproaraly
Vec_CondID = data_labels;%cell2mat(CondID_temp); %make a vector out of the condition IDs
condName_Matrix = repmat(condName_temp,[1,length(Vec_CondID)]); %create a matrix of condition names
condName_Vector = condName_Matrix(Vec_CondID); %use the IDs to simply look up the condition name to creall a cell array

[~,~,stats] = anova1(data_vals,condName_Vector,'off'); %Do one way anova
[results,~,~,gnames] = multcompare(stats,'Display','off'); %Run multicompare

colNam = {'GroupA','GroupB','LowerLimit','Difference','UpperLimit','PValue'}; %define table column names
T = array2table(results,'VariableNames',colNam);
T.('GroupA') = gnames(T.('GroupA'));
T.('GroupB') = gnames(T.('GroupB'));

% Get the current plot dimensions
current_position = get(gca,'position');
% Lower left corner x position
llcx = current_position(1);
% Lower left corner y position
llcy = current_position(2);
% Axis width
axiswidth = 0.6;
% Axis height
axisheight = current_position(4);
% Set the image dimensions
set(gca,'position',[llcx,llcy,axiswidth,axisheight]) %original code

%set one star and two star significance
one_star_p = 0.05;
two_star_p = 0.001;

%Draw significance bars%%%%%%%%%%%
if ~doHold %don't draw if this is a complex figure that is held over from previous
    %How many pairwise comparisons need to have a significance bar
    Num_bars=sum((results(:,6)<one_star_p));
    
    
    xt = get(gca, 'XTick'); %get the location of the x-ticks
    %yt = get(gca, 'YTick'); %in case y ticks are needed
    yl_v = ylim;
    yl=yl_v(2);    
    axis([xlim    yl_v(1) (1+0.04*Num_bars)*yl]); %raise the top limit by 0.04 for each line
    count_sig_line = 0; %initilize the sig_line count
    hold on
    %Number of pairwise comparisons
    [n_pair,~] = size(results);
    for st_i = 1:n_pair %cycle through the comparisons
        if(results(st_i,6)<one_star_p)   
            raise_factor_line = (1+0.01+0.04*count_sig_line); %the factor by which to raise the significance line
            plot(xt([results(st_i,1) results(st_i,2)]), [1 1].*yl*raise_factor_line, '-k','LineWidth',2) %draw line
            if(results(st_i,6)<two_star_p)
                plot([mean(xt([results(st_i,1) results(st_i,2)]))-0.04,mean(xt([results(st_i,1) results(st_i,2)]))+0.04], [1 1].*yl*(raise_factor_line+0.015), '*k') %draw two stars
            else
                plot(mean(xt([results(st_i,1) results(st_i,2)])), yl*(raise_factor_line+0.015), '*k') %draw one star
            end
            count_sig_line = count_sig_line+1; %increase the significance line count by 1
        end
    end
    hold off
end




% Save the figure as long as the user didn't request not to 
if ~dontSave
    %Save file
    new_filename = appendFilename( plot_names.path, ...
        strcat(plot_names.savename,'.pdf')); 
    saveas(gcf, fullfile(plot_names.path, new_filename), 'pdf');
    
    
    %Write the statistics table to memory as an xlsx file
    stats_filename = 'OneWayAnova_forPlots.xlsx';   
    writetable(T,fullfile(plot_names.path, stats_filename),'Sheet',plot_names.savename,'Range','A1');
end 

% Get the standard deviation values 
std_condition = mean_condition - meanpmstd_condition(:,1); 



% % Get the number of unique grid values 
% unique_grids = unique(grid_sizes); 
% gn = length(unique_grids); 
% % Get the number of unique threshold values 
% unique_thresh = unique(actin_threshs); 
% afn = length(unique_thresh); 
% 
% % Determine if the user wants a plot of the value at the 25,50,and 75
% % percentile 
% if nargin > 6
%     v = size(extra_medians,2)+1; 
% else 
%     v = 1; 
% end 
% 
% %Save the number of condition names 
% n_cond = length(cond_names); 
% 
% %Condition_values 
% condition_values = cell(n_cond*gn*afn,v);
% mean_condition = zeros(n_cond*gn*afn,v);
% std_condition = zeros(n_cond*gn*afn,v); 
% 
% %Open a figure
% figure; 
% hold on; 
% 
% %Get middle x value 
% if afn > 1 
%     filter_x = zeros(size(unique_thresh));
% else
%     %Save the CS number 
%     filter_x = zeros(1,n_cond);
% end 
% f = 1; 
% 
% %Colors
% colors = {[0.3686,0.0314,0.6471],[0.0745,0.9686,0.6863],...
%     [0.8000,0.0392,0.3529],[0.0392,0.6706,0.8000],...
%     [0.9569,0.6784,0.2588],[0.0235,0.6000,0.0588],...
%     [0.6275,0.6275,0.6275],[1,0.6,1],[0.2789,0.4479,0.6535],...
%     [0.9569,0.9059,0.3529],[0.0824,0.4000,0.9490],...
%     [0.9882,0.2980,0.2353]};
% 
% %Start color counts 
% c = 0; 
% 
% %Start counts
% k = 1; 
% 
% %Create a ID store (:,1) Condition, (:,2) grid size (:,3) actin threshold 
% id = zeros(n_cond*gn*afn,3); 
% 
% %Get bounds for the ymin and ymax
% ymin = 0; 
% ymax = 0; 
% 
% for g= 1:gn
%     
%     % Set up the grids to exclude 
%     exclude_grid = zeros(size(grid_sizes)); 
%     
%     %Only open suplots if there is more than one grid
%     if gn > 1
%         subplot(gn,1,g); 
%         hold on; 
%         %Set the values that are not equal to the current grid size equal to
%         %NaN. Otherwise, set the grid size to 1 
%         exclude_grid(grid_sizes ~= unique_grids(g)) = NaN; 
%         exclude_grid(~isnan(exclude_grid)) = 1; 
%     
%     end 
%     
%     %Set position equal to 0 
%     p = 0; 
%     
%     for a = 1:afn
%         % Set up the thresholds to exclude 
%          exlude_thresh = zeros(size(actin_threshs)); 
%             
%         if afn > 1
%             %Set the values that are not equal to the current threshold
%             %size equal to NaN. Otherwise, set the grid size to 1 
%             exlude_thresh(actin_threshs ~= unique_thresh(a)) = NaN; 
%             exlude_thresh(~isnan(exlude_thresh)) = 1; 
% 
%         end 
%         
%         %Add the exclusion threshold and grids
%         exlude_exploration = exclude_grid+exlude_thresh; 
%         
%         %Loop through all of the conditions 
%         for n = 1:n_cond 
%             %Increase color 
%             if c > length(colors)-1 || n == 1
%                 c = 1; 
%             else
%                 c = c+1; 
%             end 
%             
%             %Get the middle value
%             x0 = (2*p+1)/2;             
%             %Compute the x-axis
%             x = p:p+1; 
%             
%             %Save the (:,1) Condition, (:,2) grid size (:,3) actin threshold 
%             id(k,1) = n; 
%             id(k,2) = unique_grids(g); 
%             id(k,3) = unique_thresh(a); 
%             
%             %Get values not equal to current condition
%             exclude_cond = zeros(size(cond_values)); 
%             exclude_cond(cond_values ~= n) = NaN; 
%             %Add exlusions 
%             exclusions = exlude_exploration + exclude_cond; 
%             %Make sure that all of values that are non NaN are 0 
%             exclusions(~isnan(exclusions)) = 0; 
%             
%             %Add the values plus the points to exclude 
%             include_vals = data_points + exclusions; 
% 
%             %Reshape and remove NaN values
%             include_vals = include_vals(:);
%             include_vals(isnan(include_vals)) = []; 
%             
%             %Loop through all of the top and bottom medians 
%             for h = 1:v
%                 
%                 %Calculate the differences between the top / bottom
%                 %percentages if applicable 
%                 if v > 1                     
%                     %Plot true median 
%                     if h > size(extra_medians,2)
%                         %Take the difference 
%                         condition_values{k,h} = include_vals; 
%                         mean_condition(k,h) = mean(condition_values{k,h}); 
%                         std_condition(k,h) = std(condition_values{k,h}); 
%                     else 
%                         %Get the additional median values to includes. 
%                         additional_vals = extra_medians(:,h)' + exclusions; 
% 
%                         %Reshape and remove NaN values
%                         additional_vals = additional_vals(:);
%                         additional_vals(isnan(additional_vals)) = []; 
% 
%                         %Take the difference 
%                         condition_values{k,h} = additional_vals; 
%                         mean_condition(k,h) = mean(condition_values{k,h}); 
%                         std_condition(k,h) = std(condition_values{k,h}); 
% 
%                         %Check the bounds of the plot 
%                         if mean_condition(k,h) + std_condition(k,h) > ymax
%                             ymax = mean_condition(k,h) + std_condition(k,h); 
%                         end 
%                         if mean_condition(k,h) - std_condition(k,h) < ymin
%                             ymin = mean_condition(k,h) - std_condition(k,h); 
%                         end 
%                     end 
%                     
%                 else
%                     %Save data and calculate the mean and standard
%                     %deviation. 
%                     condition_values{k,1} =include_vals; 
%                     mean_condition(k,1) = mean(include_vals); 
%                     std_condition(k,1) = std(include_vals);
%                 end 
% 
%                 %Plot all of the points 
%                 plot(x0*ones(size(condition_values{k,h})),...
%                     condition_values{k,h},'.',...
%                     'MarkerSize', 8, ...
%                     'MarkerEdgeColor',colors{c},...
%                     'MarkerFaceColor',colors{c});
%                 
%                 %Plot the mean 
%                 plot(x, mean_condition(k,h)*ones(size(x)), ...
%                     '-','color',colors{c},'LineWidth',2);
% 
%                 %Plot range of orientation values 
%                 fill([p, p+1, p+1, p], ...
%                     [mean_condition(k,h)-std_condition(k,h),...
%                     mean_condition(k,h)-std_condition(k,h), ...
%                     mean_condition(k,h)+std_condition(k,h), ...
%                     mean_condition(k,h)+std_condition(k,h)], ...
%                     colors{c}, 'FaceAlpha', 0.3,'linestyle','none');
%             end 
%             
%             %Increate the count 
%             k = k+1; 
%             %Increase start and stop 
%             p = p+1.5;
%             
%             %Save the axis if there is only one filter
%             if afn == 1
%                 filter_x(1,f) = x0; 
%                 f = f+1; 
%             else 
%             
%                 if g == 1 && n == floor(n_cond/2) 
%                     %If there is an even number of conditions, get the middle
%                     %position for the x axis
%                     if mod(n_cond,2) == 1
%                         filter_x(1,f) = x0; 
%                     else
%                         filter_x(1,f) = (x0 + (2*p+1)/2)/2; 
%                     end 
%                     f = f+1; 
%                 end 
%             end 
%             if n == n_cond
%                 p = p+1; 
%             end 
%     
%         end
%         
%     end
% end
% 
% %Change the bounds if the condition is OOP 
% if ~strcmp(plot_names.type,'OOP')
%     %Set the axis limits for the y axis 
%     buffer = 0.3*min(data_points(:)); 
%     if buffer < 0.1
%         buffer = 0.1; 
%     end 
% 
%     if v ==1 
%         %Get the minimum and max median values 
%         ymin = min(data_points(:)); 
%         ymax = max(data_points(:)); 
%     end
% 
%     ymin = ymin - buffer; 
%     ymax = ymax + buffer; 
% else
%     ymin = 0; 
%     ymax = 1; 
% end 
% 
% for g = 1:gn 
%     %Only open suplots if there is more than one grid
%     if gn > 1
%         subplot(gn,1,g); 
%         hold on; 
%     end 
%     
%     %Change axis limits
%     ylim([ymin ymax]); 
%     xlim([-2 p+1]); 
% 
%     %Change the x axis labels
%     set(gca,'XTick',filter_x)
%     %Change the font size
%     set(gca, 'fontsize',12,'FontWeight', 'bold');
%     if afn > 1
%         set(gca,'XTickLabel',num2cell(unique_thresh),'fontsize',12,...
%             'FontWeight', 'bold'); 
%     else
%         set(gca,'XTickLabel',cond_names,'fontsize',10,...
%             'FontWeight', 'bold'); 
%         set(gca,'XTickLabelRotation',90); 
%     end 
%     
% 
%     %Change the x and y labels 
%     xlabel(plot_names.x,'FontSize', 14, 'FontWeight', 'bold');
%     ylabel(plot_names.y,'FontSize',...
%         14, 'FontWeight', 'bold');
%     
%     if gn > 1
%         %Change the title
%         new_title = strcat(plot_names.title, {' '}, 'Grid Size:',...
%             {' '}, num2str(unique_grids(g))); 
%         title(new_title,'FontSize', 14, 'FontWeight', 'bold'); 
%     else
%         %Change the title 
%         title(plot_names.title,...
%             'FontSize', 14, 'FontWeight', 'bold'); 
%     end 
%     
% end
% 

% 
% %Make legend
% figure; 
% hold on; 
% 
% %Start position tracker 
% p = 0; 
% 
% % Mean points 
% legend_cond = [1;2.5;3]; 
% legend_mean = mean(legend_cond); 
% legend_std = std(legend_cond);
% 
% %Save labels 
% vals = {plot_names.type,'Mean', 'St.Dev.'}; 
% 
% %Get legend titles 
% legend_caption = cell(length(vals)*length(cond_names),1); 
% %Temporary titles 
% 
% %Start color counter
% c = 0; 
% 
% %Counter for legend
% l=1; 
% for n = 1:n_cond
%     %Set the color 
%     %Increase color 
%     if c > length(colors)-1 || n == 1
%         c = 1; 
%     else
%         c = c+1; 
%     end 
% 
%     %Get the middle value
%     x0 = (2*p+1)/2; 
% 
%     %Compute the x-axis
%     x = p:p+1; 
%     
%     %Plot the medians 
%     plot(x0*ones(size(legend_cond)),...
%         legend_cond,'.',...
%         'MarkerSize', 8, ...
%         'MarkerEdgeColor',colors{c},...
%         'MarkerFaceColor',colors{c});
%     
%     %Temporary legend name 
%     temp_name = strcat(cond_names{n}, {' '}, vals{1}); 
%     legend_caption{l,1} = temp_name{1,1}; 
%     l = l+1; 
%     
%     %Plot the mean 
%     plot(x, legend_mean*ones(size(x)), ...
%         '-','color',colors{c},'LineWidth',2);
%     
%     %Temporary legend name 
%     temp_name = strcat(cond_names{n}, {' '}, vals{2}); 
%     legend_caption{l,1} = temp_name{1,1}; 
%     l = l+1; 
%     
%     %Plot range of orientation values 
%     fill([p, p+1, p+1, p], ...
%         [legend_mean-legend_std,...
%         legend_mean-legend_std, ...
%         legend_mean+legend_std, ...
%         legend_mean+legend_std], ...
%         colors{c}, 'FaceAlpha', 0.3,'linestyle','none');
%    
%     %Temporary legend name 
%     temp_name = strcat(cond_names{n}, {' '}, vals{3}); 
%     legend_caption{l,1} = temp_name{1,1}; 
%     l = l+1; 
%     
%     %Increate the count 
%     k = k+1; 
%     %Increase start and stop 
%     p = p+1.5;
%     
% end 
% 
% %Change the axis limits 
% xlim([0 p+1.5]); 
% 
% %Create the legend 
% legend(legend_caption); 
% 
% %Change the font size
% set(gca, 'fontsize',12,'FontWeight', 'bold');
% 
% %Change the x and y labels 
% xlabel(plot_names.x,'FontSize', 14, 'FontWeight', 'bold');
% ylabel(plot_names.y,'FontSize',...
%     14, 'FontWeight', 'bold');
% %Change the title 
% title('Legend','FontSize', 14, 'FontWeight', 'bold'); 
%     
% %Save the legend 
% legend_save = strcat(plot_names.savename, '_legend'); 
% new_filename = appendFilename( plot_names.path, ...
%     strcat(legend_save,'.pdf')); 
% saveas(gcf, fullfile(plot_names.path, new_filename), 'pdf');

end 
