function ReprojectionError(coordinates3D,CoordinateTrack, calibrationParameters)

cameraCount = length(CoordinateTrack);
frameCount = length(coordinates3D);
markerCount = size(coordinates3D(:,:,1),1);
count_3d_points = size(coordinates3D(:,:,1),1);
tmp = ones(count_3d_points ,1, frameCount);
Points_homo = [coordinates3D, tmp];
projected_points1 = zeros(count_3d_points, 3, frameCount);
Projected1 = zeros(count_3d_points, 2, frameCount);

c_list1 = ['r' 'b' 'g' 'c' 'm' 'y'];
c_list2 = ["#a2142f" "#0072BD" "#77ac30" "#4DBEEE"];

for k = 1 : cameraCount
    for i = 1 : frameCount
        for j = 1 : count_3d_points
            
                ProjectionMatrix = calibrationParameters(k).matrixP;
                projected_points1(j,:,i) = ProjectionMatrix * Points_homo(j,:,i)';
                Projected1(j,1,i) = projected_points1(j,1,i) ./ projected_points1(j,3,i);
                Projected1(j,2,i) = projected_points1(j,2,i) ./ projected_points1(j,3,i);
        end
    end
    ReprojectionTrack(k) = struct('Reprojection',Projected1);
end 
reprojection_error = zeros(count_3d_points,2,frameCount);

for k = 1:cameraCount
    for i = 1:frameCount
        reprojection_error(:,1,i) = CoordinateTrack(k).Track2D(:,1,i) - ReprojectionTrack(k).Reprojection(:,1,i);
        reprojection_error(:,2,i) = CoordinateTrack(k).Track2D(:,2,i) - ReprojectionTrack(k).Reprojection(:,2,i);
       
    end
    RepError_camera(k) = struct('Error',reprojection_error);
end 
for k = 1:cameraCount
    for j = 1:markerCount
        f = 1:1:frameCount;
        x = squeeze(RepError_camera(k).Error(j,1,:));
        y = squeeze(RepError_camera(k).Error(j,2,:));
        figure(2*k-1)
        chr = int2str(k);
        chartitleX = ['Error X of camera ' chr];
        title(chartitleX);
        xlabel('Frame');
        ylabel('X_error [px]');
        plot(f,x,'Color', char(c_list2(j)))
        legend('First marker','Second marker', 'Third marker', 'Fourth marker', 'Location', 'bestoutside');
        hold on
        figure(2*k)
        chartitleY = ['Error Y of camera ' chr];
        title(chartitleY);
        xlabel('Frame');
        ylabel('Y_error [px]');
        plot(f,y,'Color', c_list1(j))
        legend('First marker','Second marker', 'Third marker', 'Fourth marker', 'Location', 'bestoutside');
        hold on
    end
    
end
        


for k = 1:cameraCount
    for i = 1:frameCount
        f = figure(k+7);
        f.Position = [100 50 1280 720];
        ax = gca;
        ax.XLim = [0 1920];
        ax.YLim = [-200 1080];
        chr = int2str(k);
        chartitle = ['Reprojection error camera ' chr];
        title(chartitle);
        xlabel('width [px]');
        ylabel('height [px]');
        set(gca, 'YDir','reverse');
        for j = 1:markerCount
            X_track = CoordinateTrack(k).Track2D(j,1,i);
            Y_track = CoordinateTrack(k).Track2D(j,2,i);
            X_track_er = ReprojectionTrack(k).Reprojection(j,1,i);
            Y_track_er = ReprojectionTrack(k).Reprojection(j,2,i);
            scatter(X_track, Y_track, 10, c_list1(j),'filled');
            hold on
            scatter(X_track_er, Y_track_er, 10,'filled','o','MarkerFaceColor',char(c_list2(j)));
            plot([X_track X_track_er], [Y_track Y_track_er], c_list1(j));
        end
        legend('First marker','First marker - reprojection','reprojection error of First marker','Second marker', 'Second marker - reprojection','reprojection error of Second marker', 'Third marker', 'Third marker - reprojection', 'reprojection error of Third marker', 'Fourth marker', 'Fourth marker - reprojection','reprojection error of Fourth marker', 'Location', 'bestoutside');
    end
end

