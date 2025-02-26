% calculate_OOP - calculate the orientational order parameter of a matrix
% of orientation angles in radians 
%
% Usage:   
%   [ OOP, directionAngle, direction_error, director ] = ...
%       calculate_OOP( angles_matrix )
%
% Arguments:
%   angles_matrix       - orientation angles in radians with no NaN values
%                           Class Support: numeric 
% 
% Returns:
%   OOP                 - orientational order parameters
%                           Class Support: double 
%	directionAngle      - principle direction angle in degrees 
%                           Class Support: double 
%   direction_error     - difference between principle direction (in 
%                               degrees) average direction (in degrees)
%                           Class Support: double 
%   director            - principle direction vector
%                           Class Support: 2x1 double 
%
% Dependencies: 
%   MATLAB Version >= 9.5 
%
%
% Written by: Tessa Morris
%   Advisor: Anna (Anya) Grosberg, Department of Biomedical Engineering 
%   Cardiovascular Modeling Laboratory 
%   University of California, Irvine 
% Algorithm and Implementation by: Anya Grosberg
%   Disease Biophysics Group
%   School of Engineering and Applied Sciences
%   Havard University, Cambridge, MA 02138

function [ OOP, directionAngle, direction_error, director ] = ...
    calculate_OOP( angles_matrix )

%Reshape the matrix and remove all zero values. 
reshaped_matrix = angles_matrix(:); 
reshaped_matrix(reshaped_matrix == 0) = []; 
%Remove any NaN values 
reshaped_matrix(isnan(reshaped_matrix)) = []; 

%Check to make sure the angles matrix contains any values
if isempty(reshaped_matrix)
    OOP = NaN; 
    directionAngle = NaN; 
    direction_error = NaN; 
    director = NaN; 
    disp('No orientation angles in matrix'); 
    
else 
    %Initialize a matrix to store the x and y components of each 
    %orientation angle
    r = zeros(2, length(reshaped_matrix));

    %Calculate x and y components of each vector r
    r(1,:) = cos(reshaped_matrix);
    r(2,:) = sin(reshaped_matrix);

    %Calculate the Orientational Order Tensor for each r and 
    %the average Orientational Order Tensor (OOT_Mean)
    for i=1:2
        for j=1:2
            OOT_All(i,j,:)=r(i,:).*r(j,:);
            OOT_Mean(i,j) = mean(OOT_All(i,j,:));
        end
    end

    %Normalize the orientational Order Tensor (OOT), this is 
    %necessary to get the order paramter in the range from 0 to 1
    OOT = 2.*OOT_Mean - eye(2);

    %Find the eigenvalues (orientational parameters) and 
    %eigenvectors (directions) of the Orientational Order Tensor
    [directions,orient_parameters]=eig(OOT);

    %Orientational order parameters is the maximal eigenvalue, while the
    %direcotor is the corresponding eigenvector.
    [OOP,I] = max(max(orient_parameters));
    director = directions(:,I);

    %Calculate the angle corresponding to the director, by taking the 
    %inverse tangent of the y component of the director divided by the x 
    %component. 
    directionAngle = atand(director(2)/director(1)); 

    % Because these are pseduo vectors if the angle is less than 0 degrees
    % add 180 and if it is more than 180, subtract 0 
    if directionAngle < 0
        directionAngle = directionAngle + 180;
    elseif directionAngle > 180
        directionAngle = directionAngle - 180;
    end

    %Calculate the difference between the director and the mean of the
    %angles. Note, that these are not necessarily the same thing because we
    %have a finite number of vectors, so there is some inacuracy introduced
    %in both methods. We can expect the difference to be very large for
    %isotropic and small for well aligned structures. The output of this is
    %suppressed unless someone needs it for something.
    direction_error = directionAngle-(180/pi())*mean(reshaped_matrix);
end 

end
