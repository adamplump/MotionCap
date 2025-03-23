
% -------------------------------------------------------------------------
%   This is the main function of our program. It utilizes all of the other
%   functions to obtain 3D space data of the markers' positions from the
%   input films. 
%   Used functions:
%   1 - Main
%   2 - Synchronize
%   3 - Calibrate
%   4 - Track
%   5 - MaskObjects
%   6 - AssignCoordSys
%   7 - CreateTracks
%   8 - MergeTracks
%   9 - Visualize4coords
% -------------------------------------------------------------------------

%clear

%%  Getting filenames of the films
cameraCount = input("How many films do you want to use? :");
for i = 1:cameraCount
    filmsUnsyncAll(i) = convertCharsToStrings(uigetfile('*.mp4', "Select the film from camera " + i))
end

%%  Synchronizing start point and framerate if needed
syncNeeded = menu("Would you like to synchronize the films?" , ["Yes" "No"]);

if syncNeeded == 1
    targetFPS = input("How many frames per second should the films have? :");
    for i = 1:length(filmsUnsyncAll)
        filmsSyncAll(i) = Synchronize(filmsUnsyncAll(i), targetFPS);
    end
else
    filmsSyncAll = filmsUnsyncAll;
end

%%  Calibrating cameras
syncNeeded = menu("Would you like to calibrate the cameras?" , ["Yes" "No"]);
if syncNeeded == 1
    for i = 1:cameraCount
        film = VideoReader(filmsSyncAll(i));
        film.CurrentTime = 0;
        firstFrame = readFrame(film);
        calibrationParameters(i)= Calibrate(firstFrame);
    end
    close();
end 

%%  Creating Tracks (Kallman filter etc.) NOT DONE
syncNeeded = menu("Would you like to create 2D motion tracks?" , ["Yes" "No"]);
if syncNeeded == 1
    trackingStart = input("Set starting second :"); 
    trackingEnd = input("Set ending second :");
    for numCamera = 1:cameraCount
        film = VideoReader(filmsSyncAll(numCamera));
        film.CurrentTime = trackingStart;
        Track2D = CreateTracks(film, trackingStart, trackingEnd);
        CoordinateTrack(numCamera) = struct('Track2D',Track2D);
    end
end 

%%  Triangulation
[coordinates3D] = MergeTracks(CoordinateTrack, calibrationParameters);


%% Visualize in 3D
req = 'How do you want to name the movie? : ';
filmTitle = input(req,'s');
[film] = Visualize4coords(coordinates3D, filmTitle);

%% Reprojection error
ReprojectionError(coordinates3D,CoordinateTrack, calibrationParameters)

