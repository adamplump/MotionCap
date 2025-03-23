function [markersCoord2D] = AssignCoordSys(markersCoord2Drandom, inputImage)

% -------------------------------------------------------------------------
%   This function is used to assign found markers to a coordinate system.
%   It takes coordinates of the markers in random order and assigns them to
%   specific axes according to the user input.
%   X - axis on left side
%   Y - axis up
%   Z - axis towards to camera
% -------------------------------------------------------------------------

%%   Initial operations
markersCoord2D = zeros(6,2);
axes = ["X" "Y" "Z"];
markerNum = ["1" "2" "3" "4" "5" "6"];

%%   Plotting markers on the image
figure('Name', 'Markers found in the image')
imshow(inputImage)
hold on
for i = 1:length(markersCoord2Drandom)
    plot(markersCoord2Drandom(i,1),markersCoord2Drandom(i,2),'r*');
    text((markersCoord2Drandom(i,1)+10),(markersCoord2Drandom(i,2)-2), ...
        ['\leftarrow', num2str(i)],'Color','white','FontSize',12);
end

%%   Assigning markers to their axis
for i = 1:numel(axes)
    chosenAxis = menu(" Choose the axis that you want to assign " , axes); 
    chosenMarkerCloser = menu(" Choose the marker closer to the origin " + axes(chosenAxis), markerNum);
    markersCoord2D(2*(chosenAxis)-1,:) = markersCoord2Drandom(str2double(markerNum(chosenMarkerCloser)),:); 
    markerNum(chosenMarkerCloser) = [];         %   erasing chosen marker from options in the next steps
    chosenMarkerFurther = menu(" Choose the marker further from the origin " + axes(chosenAxis), markerNum);
    markersCoord2D(2*(chosenAxis),:) = markersCoord2Drandom(str2double(markerNum(chosenMarkerFurther)),:);
    markerNum(chosenMarkerFurther) = [];        %   erasing chosen marker from options in the next steps
end 
close();