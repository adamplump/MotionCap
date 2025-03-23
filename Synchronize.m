function [filmSyncTitle] = Synchronize(filmUnsyncTitle, outputFramerate)

% -------------------------------------------------------------------------
%   This function is used to synchronize films from different cameras.
%   It detects the moment of peak volume (e.g. clap of hands) and cuts out
%   the part of the film before the clap. Furthermore, it converts
%   framerate of the source film to any specified value. 
% -------------------------------------------------------------------------

%%   Initial operations
secondsSearched = input("How many initial seconds to search in " + filmUnsyncTitle + "?: ");        %   number of seconds to search for a clap
filmSyncTitle = replace(filmUnsyncTitle, '.mp4', '_sync30.mp4');              %   filmsSync - synchronized films titles ('.mp4' -> 'sync.mp4')
[sampledData, sampleRate] = audioread(filmUnsyncTitle);                     %   reading film's audio track
searchedSamples = secondsSearched * sampleRate;                             %   converting secondsSearched to number of samples
if searchedSamples > length(sampledData)
    searchedSamples = length(sampledData);          %   making sure program won't look through more samples than the file has
end

%%   Finding peak volume
[~, leftPosition] = max(abs(sampledData(1:searchedSamples,1)));         %   finding left channels's peak volume
[~, rightPosition] = max(abs(sampledData(1:searchedSamples,2)));        %   finding right channels's peak volume
timeStart = ((leftPosition + rightPosition)/2)/length(sampledData);     %   starting point of the output film (e.g. 0,27 = 27% of the source film)

%%   Creating new, synchronized film with specified framerate
filmUnsyncFile = VideoReader(filmUnsyncTitle);                                                  %   reading the film     
filmUnsyncFile.CurrentTime = timeStart * filmUnsyncFile.Duration;                               %   setting starting time for the time of clap
filmSyncFile = VideoWriter(filmSyncTitle, 'MPEG-4');                                            %   starting the VideoWriter with MPEG-4 profile 
filmSyncFile.FrameRate = outputFramerate;                                                       %   setting fps to the specified value
outputNoF = floor(outputFramerate * (filmUnsyncFile.Duration - filmUnsyncFile.CurrentTime));    %   number of frames of the output film
startingCurrentTime = filmUnsyncFile.CurrentTime;                           %   saving the initial CurrentTime for the counter inside the loop

open(filmSyncFile);
for i = 1 : outputNoF
    writeVideo(filmSyncFile, readFrame(filmUnsyncFile));                            %   saving frames to the new, synchronized file
    filmUnsyncFile.CurrentTime = startingCurrentTime + (i / outputFramerate);       %   counter that increases the CurrentTime
end
close(filmSyncFile);