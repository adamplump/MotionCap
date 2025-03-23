function [film] = Visualize3coords(coordinates3D, filmTitle)

% -------------------------------------------------------------------------
%   filmTitle - title of the film created by this function
%   coordinates1, 2, 3 - matrices of 3D coordinates of 3 different markers,
%   sized Nx3, where N (rows) is number of frames, and 3 columns correspond
%   to axes x, y and z. 
% -----------------------------------------------------------------------

coordinates1 = coordinates3D(:,1,:);
coordinates2 = coordinates3D(:,2,:);
coordinates3 = coordinates3D(:,3,:);
fig = figure(Visible="off");

for i = 1:length(coordinates1)

    clf;
    fig.Position = [0 0 1280 720];
    hold on
    grid on
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    view(-210,40);
    ax = gca;
    ax.XLim = [-360 280];
    ax.YLim = [260 560];
    ax.ZLim = [180 380];

    marker1 = i;
    marker2 = i-1;
    if marker2 < 1
        marker2 = 1;
    end
    marker3 = i-2;
    if marker3 < 1
        marker3 = 1;
    end
    marker4 = i-3;
    if marker4 < 1
        marker4 = 1;
    end
    marker5 = i-4;
    if marker5 < 1
        marker5 = 1;
    end
    scatter3(coordinates1(marker5, 1), coordinates1(marker5, 2), coordinates1(marker5, 3), 10, 'filled','o','MarkerFaceColor','#19fcea' );
    scatter3(coordinates2(marker5, 1), coordinates2(marker5, 2), coordinates2(marker5, 3), 10, 'filled','o','MarkerFaceColor','#fcb419' );
    scatter3(coordinates3(marker5, 1), coordinates3(marker5, 2), coordinates3(marker5, 3), 10, 'filled','o','MarkerFaceColor','#23faab' );
    scatter3(coordinates1(marker4, 1), coordinates1(marker4, 2), coordinates1(marker4, 3), 25, 'filled','o','MarkerFaceColor','#19e2fc' );
    scatter3(coordinates2(marker4, 1), coordinates2(marker4, 2), coordinates2(marker4, 3), 25, 'filled','o','MarkerFaceColor','#fc8e19' );
    scatter3(coordinates3(marker4, 1), coordinates3(marker4, 2), coordinates3(marker4, 3), 25, 'filled','o','MarkerFaceColor','#23fa8b' );
    scatter3(coordinates1(marker3, 1), coordinates1(marker3, 2), coordinates1(marker3, 3), 40, 'filled','o','MarkerFaceColor','#19b1fc' );
    scatter3(coordinates2(marker3, 1), coordinates2(marker3, 2), coordinates2(marker3, 3), 40, 'filled','o','MarkerFaceColor','#fc7019' );
    scatter3(coordinates3(marker3, 1), coordinates3(marker3, 2), coordinates3(marker3, 3), 40, 'filled','o','MarkerFaceColor','#23fa6b' );
    scatter3(coordinates1(marker2, 1), coordinates1(marker2, 2), coordinates1(marker2, 3), 55, 'filled','o','MarkerFaceColor','#196dfc' );
    scatter3(coordinates2(marker2, 1), coordinates2(marker2, 2), coordinates2(marker2, 3), 55, 'filled','o','MarkerFaceColor','#fc4619' );
    scatter3(coordinates3(marker2, 1), coordinates3(marker2, 2), coordinates3(marker2, 3), 55, 'filled','o','MarkerFaceColor','#30fc4f' );
    scatter3(coordinates1(marker1, 1), coordinates1(marker1, 2), coordinates1(marker1, 3), 70, 'filled','o','MarkerFaceColor','#2119fc' );
    scatter3(coordinates2(marker1, 1), coordinates2(marker1, 2), coordinates2(marker1, 3), 70, 'filled','o','MarkerFaceColor','#fc1919' );
    scatter3(coordinates3(marker1, 1), coordinates3(marker1, 2), coordinates3(marker1, 3), 70, 'filled','o','MarkerFaceColor','#2efc1c' );
    outputFilm(i) = getframe;
end

clf;
fig.Position = [0 0 1280 720];
hold on
grid on
xlabel('X');
ylabel('Y');
zlabel('Z');
view(-210,40);
ax = gca;
ax.XLim = [-360 280];
ax.YLim = [260 560];
ax.ZLim = [180 380];
scatter3(coordinates1(marker4, 1), coordinates1(marker4, 2), coordinates1(marker4, 3), 25, 'filled','o','MarkerFaceColor','#19e2fc' );
scatter3(coordinates2(marker4, 1), coordinates2(marker4, 2), coordinates2(marker4, 3), 25, 'filled','o','MarkerFaceColor','#fc8e19' );
scatter3(coordinates3(marker4, 1), coordinates3(marker4, 2), coordinates3(marker4, 3), 25, 'filled','o','MarkerFaceColor','#23fa8b' );
scatter3(coordinates1(marker3, 1), coordinates1(marker3, 2), coordinates1(marker3, 3), 40, 'filled','o','MarkerFaceColor','#19b1fc' );
scatter3(coordinates2(marker3, 1), coordinates2(marker3, 2), coordinates2(marker3, 3), 40, 'filled','o','MarkerFaceColor','#fc7019' );
scatter3(coordinates3(marker3, 1), coordinates3(marker3, 2), coordinates3(marker3, 3), 40, 'filled','o','MarkerFaceColor','#23fa6b' );
scatter3(coordinates1(marker2, 1), coordinates1(marker2, 2), coordinates1(marker2, 3), 55, 'filled','o','MarkerFaceColor','#196dfc' );
scatter3(coordinates2(marker2, 1), coordinates2(marker2, 2), coordinates2(marker2, 3), 55, 'filled','o','MarkerFaceColor','#fc4619' );
scatter3(coordinates3(marker2, 1), coordinates3(marker2, 2), coordinates3(marker2, 3), 55, 'filled','o','MarkerFaceColor','#30fc4f' );
scatter3(coordinates1(marker1, 1), coordinates1(marker1, 2), coordinates1(marker1, 3), 70, 'filled','o','MarkerFaceColor','#2119fc' );
scatter3(coordinates2(marker1, 1), coordinates2(marker1, 2), coordinates2(marker1, 3), 70, 'filled','o','MarkerFaceColor','#fc1919' );
scatter3(coordinates3(marker1, 1), coordinates3(marker1, 2), coordinates3(marker1, 3), 70, 'filled','o','MarkerFaceColor','#2efc1c' );
outputFilm(length(coordinates1)+1) = getframe;

clf;
fig.Position = [0 0 1280 720];
hold on
grid on
xlabel('X');
ylabel('Y');
zlabel('Z');
view(-210,40);
ax = gca;
ax.XLim = [-360 280];
ax.YLim = [260 560];
ax.ZLim = [180 380];
scatter3(coordinates1(marker3, 1), coordinates1(marker3, 2), coordinates1(marker3, 3), 40, 'filled','o','MarkerFaceColor','#19b1fc' );
scatter3(coordinates2(marker3, 1), coordinates2(marker3, 2), coordinates2(marker3, 3), 40, 'filled','o','MarkerFaceColor','#fc7019' );
scatter3(coordinates3(marker3, 1), coordinates3(marker3, 2), coordinates3(marker3, 3), 40, 'filled','o','MarkerFaceColor','#23fa6b' );
scatter3(coordinates1(marker2, 1), coordinates1(marker2, 2), coordinates1(marker2, 3), 55, 'filled','o','MarkerFaceColor','#196dfc' );
scatter3(coordinates2(marker2, 1), coordinates2(marker2, 2), coordinates2(marker2, 3), 55, 'filled','o','MarkerFaceColor','#fc4619' );
scatter3(coordinates3(marker2, 1), coordinates3(marker2, 2), coordinates3(marker2, 3), 55, 'filled','o','MarkerFaceColor','#30fc4f' );
scatter3(coordinates1(marker1, 1), coordinates1(marker1, 2), coordinates1(marker1, 3), 70, 'filled','o','MarkerFaceColor','#2119fc' );
scatter3(coordinates2(marker1, 1), coordinates2(marker1, 2), coordinates2(marker1, 3), 70, 'filled','o','MarkerFaceColor','#fc1919' );
scatter3(coordinates3(marker1, 1), coordinates3(marker1, 2), coordinates3(marker1, 3), 70, 'filled','o','MarkerFaceColor','#2efc1c' );
outputFilm(length(coordinates1)+2) = getframe;

clf;
fig.Position = [0 0 1280 720];
hold on
grid on
xlabel('X');
ylabel('Y');
zlabel('Z');
view(-210,40);
ax = gca;
ax.XLim = [-360 280];
ax.YLim = [260 560];
ax.ZLim = [180 380];
scatter3(coordinates1(marker2, 1), coordinates1(marker2, 2), coordinates1(marker2, 3), 55, 'filled','o','MarkerFaceColor','#196dfc' );
scatter3(coordinates2(marker2, 1), coordinates2(marker2, 2), coordinates2(marker2, 3), 55, 'filled','o','MarkerFaceColor','#fc4619' );
scatter3(coordinates3(marker2, 1), coordinates3(marker2, 2), coordinates3(marker2, 3), 55, 'filled','o','MarkerFaceColor','#30fc4f' );
scatter3(coordinates1(marker1, 1), coordinates1(marker1, 2), coordinates1(marker1, 3), 70, 'filled','o','MarkerFaceColor','#2119fc' );
scatter3(coordinates2(marker1, 1), coordinates2(marker1, 2), coordinates2(marker1, 3), 70, 'filled','o','MarkerFaceColor','#fc1919' );
scatter3(coordinates3(marker1, 1), coordinates3(marker1, 2), coordinates3(marker1, 3), 70, 'filled','o','MarkerFaceColor','#2efc1c' );
outputFilm(length(coordinates1)+3) = getframe;

clf;
fig.Position = [0 0 1280 720];
hold on
grid on
xlabel('X');
ylabel('Y');
zlabel('Z');
view(-210,40);
ax = gca;
ax.XLim = [-360 280];
ax.YLim = [260 560];
ax.ZLim = [180 380];
scatter3(coordinates1(marker1, 1), coordinates1(marker1, 2), coordinates1(marker1, 3), 70, 'filled','o','MarkerFaceColor','#2119fc' );
scatter3(coordinates2(marker1, 1), coordinates2(marker1, 2), coordinates2(marker1, 3), 70, 'filled','o','MarkerFaceColor','#fc1919' );
scatter3(coordinates3(marker1, 1), coordinates3(marker1, 2), coordinates3(marker1, 3), 70, 'filled','o','MarkerFaceColor','#2efc1c' );
outputFilm(length(coordinates1)+4) = getframe;
close(fig);

film = VideoWriter(filmTitle, 'MPEG-4');   %   nazwa zapisywanego filmu
film.FrameRate = 15;
open(film);
writeVideo(film, outputFilm);
close(film);

end