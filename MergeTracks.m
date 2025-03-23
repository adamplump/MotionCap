function [markersTracks3D] = MergeTracks(markersTracks2D, calibrationParameters)

% -------------------------------------------------------------------------
%   INPUT
%   markersTracks2D - structure of 2D coordinates sorted into tracks. 
%   Fields of markersTracks2D are named Camera1, Camera2 etc. Each field is
%   a matrix of coords: Mx2xN, where M (rows) is number of markers, 2
%   columns contain x and y coords, and N is number of frames.
%
%   calibrationParameters - structure containing calibration parameters of
%   all cameras, obtained from function Calibrate
%
%   OUTPUT 
%   markersTracks3D - matrix of 3D coordinates with dimensions of Mx3xN,
%   where M (rows) is number of markers, 3 columns contain x, y and z 
%   coords, and N is number of frames.
%
%   i - frame number
%   j - marker number
%   k - camera number
% -------------------------------------------------------------------------

cameraCount = length(markersTracks2D);
frameCount = length(markersTracks2D(1).Track2D);
markerCount = length(markersTracks2D(1).Track2D(:,1,1));
markersTracks3D = zeros([markerCount, 3, frameCount]);

for i = 1 : frameCount
    for j = 1 : markerCount
        for k = 1 : cameraCount

            ProjectionMatrix = calibrationParameters(k).matrixP;
            u = markersTracks2D(k).Track2D(j, 1, i);
            v = markersTracks2D(k).Track2D(j, 2, i);

            D(2*k-1, :) = v * ProjectionMatrix(3, :)' - ProjectionMatrix(2, :)';
            D(2*k, :) = u * ProjectionMatrix(3, :)' - ProjectionMatrix(1, :)';
        end

        [~,~,V] = svd(D'*D);
        X = V(:, length(V))/V(end);

        markersTracks3D(j, :, i) = X(1:3)';
    end
end




