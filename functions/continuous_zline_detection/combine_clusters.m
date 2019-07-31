function [ cluster_tracker, zline_clusters, clusterCount, ...
    ignored_cases ] = ...
    combine_clusters( cluster_tracker, zline_clusters, clusterCount, ...
    cluster_value, temp_cluster, ignored_cases, current_dprows, current_dpcols )
%This function will combine two clusters into one

%Store the first cluster and get the size
d1_cval = cluster_value(1); 
dir1_clusterA = zline_clusters{ d1_cval, 1 };

%Store the second cluster and get the size 
d2_cval = cluster_value(end); 
dir2_clusterB = zline_clusters{ d2_cval, 1 };

% For each value in the current dp_rows / columns, (1)determine which 
% cluster they're in (2) its position in that cluster and (3) whether 
% that's the top == 1 or bottom == 0
relative_loc = zeros(3,length(current_dprows)); 
for h = 1:length(current_dprows)
    % Get the current cluster value
    if cluster_value(h) == d1_cval
        relative_loc(1,h) = 1; 
        % Find the index 
        relative_loc(2,h) = coordinatePosition( current_dprows(h),...
            current_dpcols(h), dir1_clusterA(:,1), dir1_clusterA(:,2) ); 
        % Determine if index is at top or bottom 
        if relative_loc(2,h) == 1
            relative_loc(3,h) = 1; 
        elseif relative_loc(2,h) == size(dir1_clusterA,1) 
            relative_loc(3,h) = 0; 
        else
            relative_loc(3,h) = NaN; 
        end 
    
    elseif cluster_value(h) == d2_cval
        % Set the current clusters 
        relative_loc(1,h) = 2; 
        % Find the index 
        relative_loc(2,h) = coordinatePosition(current_dprows(h),...
            current_dpcols(h), dir2_clusterB(:,1), dir2_clusterB(:,2) );
        % Determine if index is at top or bottom 
        if relative_loc(2,h) == 1
            relative_loc(3,h) = 1; 
        elseif relative_loc(2,h) == size(dir2_clusterB,1) 
            relative_loc(3,h) = 0; 
        else
            relative_loc(3,h) = NaN; 
        end 
        
    else
        % Set all to NaN 
        relative_loc(1,h) = NaN; 
        relative_loc(2,h) = NaN; 
        relative_loc(3,h) = NaN; 
    end 
    
end 

% Determine if either cluster A or cluster B only consists of their dir and
% dir0 
onlyA = relative_loc(1,2) == 1 && size(dir1_clusterA,1) == 2; 
onlyB = relative_loc(1,2) == 2 && size(dir2_clusterB,1) == 2;  


% disp('Rows'); 
% disp(current_dprows); 
% disp('Cols'); 
% disp(current_dpcols);
% disp('Cluster 1'); 
% disp(dir1_clusterA); 
% disp('Cluster 2'); 
% disp(dir2_clusterB); 
% disp('Relative Locations'); 
% disp(relative_loc); 

% Create logical to keep going if everything is okay
dontIgnore = true; 

% If dir0 is assigned to a cluster and it is not at the end, set don't
% ignore equal to true
if cluster_value(2) ~= 0 && isnan(relative_loc(3,2))
    dontIgnore = false; 
end

% The second cluster will only be on top in the following five cases: 
%(1) dir1: middle, dir0: top in A, dir2: bottom 
bTop1 = ( isnan(relative_loc(3,1)) && ...
        relative_loc(3,2) == 1 && relative_loc(1,2) == 1 &&...
        relative_loc(3,3) == 0 ); 
%(2) dir1: top, dir0: bottom in B, dir2: middle 
bTop2 = ( relative_loc(3,1) == 1 && ...
        relative_loc(3,2) == 0 && relative_loc(1,2) == 2 &&...
        isnan(relative_loc(3,3)) ); 
%(3) dir1: top, dir0: U, dir2: bottom
bTop3 = ( relative_loc(3,1) == 1 && ...
        cluster_value(2) == 0 &&...
        relative_loc(3,3) == 0 ); 
%(4) dir1: bottom, dir0: top in A , dir2: bottom, A is only 2 
bTop4 = ( relative_loc(3,1) == 0 && ...
        relative_loc(3,2) == 1 && ...
        relative_loc(3,3) == 0 &&...
        onlyA ); 
%(5) dir1: top, dir0: bottom in B , dir2: top, B is only 2 
bTop5 = ( relative_loc(3,1) == 1 && ...
        relative_loc(3,2) == 0 && ...
        relative_loc(3,3) == 1 &&...
        onlyB ); 
    
% Set bTop to be true if it was true for any of the other cases 
bTop = bTop1 || bTop2 || bTop3 || bTop4 || bTop5; 
    
% Set the top cluster and the bottom cluster
if bTop
    top_cluster = dir2_clusterB; 
    bottom_cluster = dir1_clusterA; 
else
    top_cluster = dir1_clusterA; 
    bottom_cluster = dir2_clusterB; 
end  

% Save the logical statement about location in an array 
temp_tb = relative_loc(3,:);  

% The first cluster should be flipped only if two directions are on top 
if sum(temp_tb(:) == 1) == 2 && ~bTop
    % One exception to this rule is if dir0 is bottom in A and A only
    % consisists of dir1 and dir0 
    dontFlip = relative_loc(3,2) == 0 && onlyA; 
    if ~dontFlip  
        top_cluster = flipud(top_cluster); 
    end 
end 
% The second cluster should be flipped only if two directions are on bottom
if sum(temp_tb(:) == 0) == 2 && ~bTop
    % One exception to this rule is if dir0 is top in B and B only
    % consisists of dir2 and dir0 
    dontFlip = relative_loc(3,2) == 1 && onlyB; 
    if ~dontFlip  
        bottom_cluster = flipud(bottom_cluster); 
    end
end 

% If there is an issue increase the number of ignored cases
if ~dontIgnore
    ignored_cases = ignored_cases + 1; 
else
    %Increase clusterCount
    clusterCount = clusterCount + 1; 


    %Create a new row in the cell array zline_clusters 
    %and order the new cluster based on the order of  
    %the cluster values
    zline_clusters{clusterCount, 1} = ...
        [top_cluster; ...
        temp_cluster; ...
        bottom_cluster]; 

    %Set the previous clusters to NaN 
    zline_clusters{ cluster_value(1), 1 } = NaN; 
    zline_clusters{ cluster_value(end), 1 } = NaN; 

    %Update the tracker 
    cluster_tracker = ...
        update_tracker( zline_clusters, ...
        cluster_tracker, clusterCount );  
    %Update the tracker 
    cluster_tracker = ...
        update_tracker( zline_clusters, ...
        cluster_tracker, cluster_value(1) );  
    %Update the tracker 
    cluster_tracker = ...
        update_tracker( zline_clusters, ...
        cluster_tracker, cluster_value(end) );  

    

    
end

end

