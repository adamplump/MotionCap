function [coordsMarkers,A] = Track(inputImage, mask, brightnessThreshold)

% -------------------------------------------------------------------------
%   This function is used to track objects in an image. First, it binarizes
%   the image with a brightness threshold and performs various 
%   morphological operations to enhance the image. Then, centroids and
%   circularity of all of the objects in the image are calculated.
%   Eventually, objects are filtered with a circularity threshold to remove
%   any non-marker detections.
% -------------------------------------------------------------------------

%%   Image binarization and morphological operations
A = rgb2gray(inputImage);               %   converting to grey scale
A = imbinarize(A, brightnessThreshold/255);       %   binarization with a threshold
A = bwareaopen(A, 10);                  %   morphological opening (removes smallest noise)
A = imfill(A,'holes');                  %   filling in holes (removes noise from markers)
A = imclose(A,strel('disk',10));        %   morphological closing (smoothes out the edges)
if nargin == 3
    A (mask == 1) = 0;                      %   deleting areas of mask from the frame
end 

%%   Finding centroids and circularity of all of the objects in the image
objects = regionprops(A,'Circularity','Centroid');      %   calculating centers and circularity of objects 
coordsAll = (round(cat(1, objects.Centroid)));          %   coordinates of all found objects
circularity = cat(1, objects.Circularity);
circularityThreshold = 0.6;        %   circularity threshold for separating markers from noise objects

%%   Creating the final matrix with coordinates of the markers
markersIndices = circularity >= circularityThreshold;
coordsMarkers = coordsAll(markersIndices, :);