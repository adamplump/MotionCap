function [maskCombined] = MaskObjects(inputImage)

% -------------------------------------------------------------------------
%   This function is used to draw masks on certain areas of the frame that
%   should be deleted (e.g. reflections) throughout the entire length of an
%   analyzed film. User can draw, edit and remove any amount of shapes that
%   are then turned into a single mask. This output mask should later be 
%   extracted from every frame of a film with a formula 
%   "image(mask == 1) = 0".
% -------------------------------------------------------------------------

%%  Initial operations
maskCount = 0;
maskCombined = zeros(height(inputImage), width(inputImage));

%%  Displaying the input image and drawing masks
frame = figure;
imshow(inputImage);
masksNeeded = menu("Would you like to cover any parts of the frame?" , ["Yes" "No"]);

while masksNeeded == 1
    maskCount = maskCount + 1;
    polygon(maskCount) = drawpolygon;   %#ok<AGROW> 
    masksNeeded = menu("Would you like to add any more masks?" , ["Yes" "No"]);
end

%%  Creating a combined output mask
if exist('polygon', 'var') == 1
    for i = 1 : length(polygon)
        maskCombined = maskCombined + createMask(polygon(i));
    end
end
imshow(maskCombined);
close(frame);
end