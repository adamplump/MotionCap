function [calibrationParameters] = Calibrate(inputImage)

% -------------------------------------------------------------------------
%   This function is used to calibrate the cameras. In order to do that, it
%   takes an image containing 6 markers with known coordinates, finds their
%   2D coordinates in the image and calculates the pojection matrix P of
%   the camera. Furthermore, it calculates the 3 specific matrices that
%   make up the matrix P: K (camera matrix), R (rotation matrix), 
%   T (translation matrix), and also C (Camera centroid). 
% -------------------------------------------------------------------------

%%   Initial operations
markersCoord3D = [50 0 0; 140 0 0; 0 50 0; 0 140 0; 0 0 50; 0 0 140];
maskCombined = [];
brightnessThreshold = input("Set treshold :");

%%   Finding 2D coordinates of the markers in the image
while 1
[markersCoord2Drandom, A] = Track(inputImage,maskCombined,brightnessThreshold);           %   finding coordinates of the markers in the image
check_fig = figure('Name', 'Imbinarize image');
imshow(A);
MASK= menu("Do you want add mask?" , ["Yes" "No"]);
    if MASK == 1
        maskCombined = MaskObjects(A);
    end
imshow(A);
ItsOK= menu("Whether the threshold is sufficient?" , ["Yes" "No"]);
    if ItsOK == 1 && MASK == 2
       break
    elseif ItsOK == 1
        close(check_fig);
        continue
    else
       brightnessThreshold = input("Set treshold :"); 
       close(check_fig);
    end
end
close(check_fig);
markersCoord2D = AssignCoordSys(markersCoord2Drandom, ...   %   assigning them to a coordynate system
    inputImage);
 
%%   Calculating projection matrix P
X = markersCoord3D(:, 1);       %   assigning all 3D and 2D coords to their 
Y = markersCoord3D(:, 2);       %   matrices (e.g. matrix X contains X 
Z = markersCoord3D(:, 3);       %   coordinates of all 6 markers)
x = markersCoord2D(:, 1);
y = markersCoord2D(:, 2);

matrixA = zeros(12, 12);
for i = 1:6                             %   arranging 3D and 2D coords into matrix A
    matrixA(2*i-1,:) = [-X(i) -Y(i) -Z(i) -1 0 0 0 0 x(i)*X(i) x(i)*Y(i) x(i)*Z(i) x(i)] ;
    matrixA(2*i,:) = [0 0 0 0 -X(i) -Y(i) -Z(i) -1 y(i)*X(i) y(i)*Y(i) y(i)*Z(i) y(i)] ;
end

[~,~,V] = svd(matrixA'*matrixA);            %   singular value decomposition of A'*A (V is a matrix of right
vectorP = V(:,end);             %   singular vectors) and choosing the smallest eigenvector
matrixP = (reshape(vectorP, [4,3]))';       %   reshaping vector P into projection matrix P



%%   QR decomposition of the projection matrix P into K, R, t and C
[matrixRtrans, matrixKinverted] = qr(inv(matrixP(:, 1:3)));
matrixK = inv(matrixKinverted);
matrixR = matrixRtrans';
matrixC = -inv(matrixP(:, 1:3)) * matrixP(:, end);
matrixT = -matrixR * matrixC;

%%   Combining all the calibration parameters into 1 structure
calibrationParameters = struct('matrixA', matrixA,'matrixP', matrixP,'matrixK', ...
    matrixK,'matrixR', matrixR, 'matrixT', matrixT,'matrixC', matrixC);

% Function for testing the result! 
total_3d_points = length(markersCoord2D); % ground truth 2D image plane points
tmp = ones(total_3d_points,1);
projected_points = zeros(total_3d_points, 3,1); % 300 x 3 x 1 matrix
homogenous_points = [markersCoord3D, tmp]; % world 3D points converted homogenous points
for i=1:1:total_3d_points
        projected_points(i,:) =  calibrationParameters.matrixP * homogenous_points(i,:)'; 
end   

    figure(1)
    ax = gca;
    scatter(markersCoord2D(:,1),markersCoord2D(:,2),'filled');
    ax.XLim = [0 1920];
    ax.YLim = [-200 1080];
    set(gca, 'YDir','reverse');
    hold on
%     ax = gca;
    Proj_X = projected_points(:,1) ./ projected_points(:,3);
    Proj_Y = projected_points(:,2) ./ projected_points(:,3);
    scatter(Proj_X,Proj_Y);
%     ax.XLim = [0 1920];
%     ax.YLim = [-200 1080];
%     set(gca, 'YDir','reverse');
end 