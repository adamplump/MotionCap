function [film] = Visualize4coords(coordinates3D, filmTitle)

% -------------------------------------------------------------------------
%   filmTitle - title of the film created by this function
%   coordinates1, 2, 3 - matrices of 3D coordinates of 3 different markers,
%   sized Nx3, where N (rows) is number of frames, and 3 columns correspond
%   to axes x, y and z.
% -----------------------------------------------------------------------
% Add to coordinates matrix
az = 190;
el = 11;
j = length(coordinates3D(:,:,1));


for i = 1:length(coordinates3D)
    figure(1) %(Visible="off");
    scatter3(coordinates3D(1,1,i), coordinates3D(1,3,i), coordinates3D(1, 2,i),'filled','o','MarkerFaceColor','#EDB120' );
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    view(az,el); %(-169,20);
    ax = gca;
    ax.XLim = [-1200 800];
    ax.YLim = [-1000 1000];
    ax.ZLim = [-500 1500];
    xlabel('[mm]');
    ylabel('[mm]');
    zlabel('[mm]');
    hold on
    hold off
    outputFilm(i) = getframe;
    dcm = datacursormode;
    if dcm.Enable == 1
        [az,el] = view;
    end 
end

film = VideoWriter(filmTitle, 'MPEG-4');   %   nazwa zapisywanego filmu
open(film);
writeVideo(film, outputFilm);
close(film);

end