function X_loc_estimate = CreateTracks(film, trackingStart, trackingEnd)

%% Main variables
dt = 0.5;           %   Sampling time
u = 0.5;            %   Acceleration

Sigma_a = 1;        %  acceleration disturbance, ie deviation [meters / sec ^ 2]
Sigma_x = 0.1;      %   measurement disturbances (x axis).
Sigma_y = 0.1;      %   measurement disturbances (y axis)    
Ez = [Sigma_x 0; 0 Sigma_y];    %   Measurement noise covariance matrix
Ex = [dt^4/4 0 dt^3/2 0 ; 0 dt^4/4 0 dt^3/2 ; dt^3/2 0 dt^2 0 ; 0 dt^3/2 0 dt^2].*Sigma_a ^2; % Process noise covariance matrix
P = Ex;     %   The covariance matrix of the initial state estimation error

%% Coefficient matrices: [State transitions (position + speed)] + [input control (acceleration)]
F_t = [1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1];     %   % State matrix (transition or transition matrix)
B_t = [(dt^2/2); (dt^2/2); dt; dt];   %   Input matrix - controlling
H_t = [1 0 0 0; 0 1 0 0];     %   Output matrix - Applied to the state estimator X to get the next measurements

%% Initialization of variables to be evaluated
% Position estimate
X_loc_estimate = [];
v_estimate = [];
c_list = ['r' 'b' 'g' 'c' 'm' 'y'];
r = 20;  
theta=linspace(0,2*pi); 
frameNum = 0;
brightnessThreshold = input("Set treshold :");
filmKalmanTitle = film.Name;
filmKalmanTitle = replace(filmKalmanTitle, '.mp4', '_tracking1.mp4');
mask = [];

%% Process the frame, find markers, and create a new movie
while film.CurrentTime <= trackingEnd
    B = readFrame(film);
    frameNum = frameNum + 1;
    if frameNum == 1
        while 1
            [markers, A] = Track(B, mask, brightnessThreshold);           % finding coordinates of the markers in the image
            check_fig = figure('Name', 'Imbinarize image');
            imshow(A);
            MASK= menu("Do you want add mask?" , ["Yes" "No"]);
            if MASK == 1
                mask = MaskObjects(A);
            end
            ItsOK= menu("Whether the threshold is sufficient?" , ["Yes" "No"]);
            if ItsOK == 1 && MASK == 2
                hold on
                plot(markers(:,1),markers(:,2),'r*');
                datacursormode on
                dcm_obj = datacursormode(check_fig);
                number_markers = size(markers,1);
                markers = zeros(number_markers, 2);
                for nm=1:number_markers
                    point = menu(" Did you choose your " +nm + " marker?",["Yes" "No"]);
                    if point == 1
                    % Export cursor to workspace
                    info_struct = getCursorInfo(dcm_obj);
                    markers(nm, :) = info_struct.Position;
                    else
                        continue
                    end 
                end
                   close(check_fig);
                break
            elseif ItsOK == 1
                close(check_fig);
                continue
            else
                brightnessThreshold = input("Set treshold :");
                close(check_fig);
            end
        end
    else
        [markers,  A] = Track(B, mask, brightnessThreshold);
    end

    %% Make a Kalman filter
    if frameNum ==1
        X_estimate = zeros(4,number_markers);
        estimate_distance = zeros(number_markers);
    end
    X(:,:,frameNum)= [markers(:,1) markers(:,2) zeros(length(markers(:,1)),1) zeros(length(markers(:,2)),1)]';  
    for t = 1:number_markers
        if frameNum ==1
            X_estimate(:,t) = F_t * X(:,t)+ B_t * u;   %    Estimate the next marker move based on the last state and move
        else
            X_estimate(:,t) = F_t * X_estimate(:,t) + B_t * u;
        end
        X_pre_estimate(:,:,frameNum) = X_estimate(:,:);
        estimate_distance(t,:,frameNum) = sqrt((X(1,:,frameNum) - X_estimate(1,t)).^2 +  (X(2,:,frameNum)- X_estimate(2,t)).^2);
    end
    %% Hungarian method
    estimate_distance_temp = estimate_distance(:,:,frameNum);
    buff = zeros(size(estimate_distance_temp,1));   % Save in temporary matrix

    
    % Step 1 row reduction - draw the minimum value in each row and substract
    % from every element of that row
    for h=1:size(estimate_distance_temp,1)
        if h == 1
            for q=1:size(estimate_distance_temp,1)
                [~,assign1] = min(estimate_distance_temp(q,:));    % Min cost in row
                min_dist(:,q) = assign1;
                reduction_row(q,:) = estimate_distance_temp(q,:) - estimate_distance_temp(q, min_dist(q));
            end
        end
        
        % Step 2 column reduction - draw the minimum value in each column and substract
        % from every element of that column
        [~,assign2] = min(reduction_row(:,h));    % Min cost in col
        min_col(:,h) = assign2;
        reduction_col(:,h) = reduction_row(:,h) - reduction_row(min_col(h), h);
    end
    
    % Step 3 do assignment in the cost table
    iter = 0;
    buff = reduction_col;
    assign = [];
    while 1
        iter = 0;
        while find(~buff)
            %* Find rows with exactly one umarked 0 (there is no any
            %* zero in row, make assignment by inf) scratch other 0
            %* in the same column by make -inf
            for fw=1:size(buff,1)
                zero_in_row = find(~buff(fw,:));    % Scan rows one by one
                if numel(zero_in_row) == 1          % If there is only one zero in the scanned line,
                    zero_in_vert = find(~buff(:,zero_in_row)); % Looking for zero in column
                    buff(fw,zero_in_row) = inf;      % Marking zero in row by inf
                    iter = iter + 1;
                    if numel(zero_in_vert) > 1       % If the number of zeros in the column is greater than 1
                        zero_in_vert(zero_in_vert == fw) = [];   % Removing redundant zero in column (is the same zero which we found in row)
                        buff(zero_in_vert,zero_in_row) = -inf;   % Scratch zeros in column by make -inf
                    end
                else
                    continue
                end
            end
            %* Find columns with exactly one umarked 0 (there is no any
            %* zero in column, make assignment by inf) scratch other 0
            %* in the same row by make -inf
            for gw=1:size(buff,1)
                zero_in_col = find(~buff(:,gw));    % Scan columns one by one
                if numel(zero_in_col) == 1          % If there is only one zero in the scanned line,
                    zero_in_horiz = find(~buff(zero_in_col,:));  % Looking for zero in column
                    buff(zero_in_col,gw) = inf;      % Marking zero in column by inf
                    iter = iter + 1;
                    if numel(zero_in_horiz) > 1      % If the number of zeros in the column is greater than 1
                        zero_in_horiz(zero_in_horiz == gw) = [];     % Removing redundant zero in row (is the same zero which we found in column)
                        buff(zero_in_col, zero_in_horiz) = -inf;     % Scratch zeros in row by make -inf
                    end
                else
                    continue
                end
            end
            if numel(zero_in_col) >= 2 && numel(zero_in_row) >=2    % If a row and/or column has two or more unmarked 0 (inf) and one cannot be chosen by inspection, then choose the cell arbitrarily.
                iter = 0;
                for sw=1:size(buff,1)
                    choose_arbitrarily = find(~buff(sw,:));          % Searching in row the column where we can find 0
                    buff(sw, choose_arbitrarily) = inf;              % Instead of zero put inf
                    iter = iter + 1;
                end
            end
        end
        %* Continue inspection till all 0 in rows/column are assigned
        % or crossed

        
        % Step 4 If the number of assigned (inf)  = the number of rows, then an
        % optimal assignment is found.
        % If optimal solution is not optimal, then goto Step-5.
        if iter == size(buff,1)
            break
            
            % Step 5 Mark a set of horizontal and vertical lines to cover all the 0 by inf
        else
            for any_zero = 1:size(buff,1)
                tick_row_no_assign = all(buff(any_zero,:) == -inf | buff(any_zero,:) ~=inf); %  Looking for row with no assign
                if tick_row_no_assign == 1          %   Write down all lines where there is an unassigned zero
                    mark_row = any_zero;
                end
            end
            any_zero = mark_row;
            mark_col = [];
            any_zero_in_row = 2;
            while any_zero_in_row >= 2
                any_zero_in_row = find(buff(any_zero,:) == -inf | buff(any_zero,:) ==inf);    % If any 0 cell occurs in that row, then tick mark by inf that column.
                any_zero_in_row = setdiff(any_zero_in_row, mark_col);
                mark_col = [mark_col, any_zero_in_row];
                if size(any_zero_in_row,2) > 1
                    for z=1:size(any_zero_in_row,2)
                        zero_assign_in_col(z,:) = find(buff(:,any_zero_in_row(z)) == inf);
                        any_zero_in_row2 = find(buff(zero_assign_in_col(z),:) == -inf | buff(zero_assign_in_col(z),:) ==inf);
                        size_zero_assign(z,:) = size(any_zero_in_row2,2);
                    end
                    [~,I] = max(size_zero_assign);
                    mark_row = [mark_row, zero_assign_in_col'];
                    zero_assign_in_col = zero_assign_in_col(1,I);
                    any_zero = zero_assign_in_col;
                else
                    zero_assign_in_col = find(buff(:,any_zero_in_row) == inf); %If any assigned 0 exists in that columns, then tick mark that row.
                    mark_row = [mark_row, zero_assign_in_col];
                    any_zero = zero_assign_in_col;
                end
            end
        end

        for mw=1:size(buff,1)
            unmark_rows(1,mw) = mw;
        end
        unmark_rows = setdiff(unmark_rows,mark_row);
        buff(unmark_rows,:) = inf;
        buff(:, mark_col) = inf;
        
        % Step 6 Create the new revised opportunity cost table
        % - Select the minimum element, say min_buff, from the matrix (buff) not marked by any inf,
        % - Subtract min_buff from each element not covered by inf.
        % - Add min_buff to each intersection element of two lines of inf.
        min_buff = min(buff,[],'all');
        buff = buff - min_buff;
        cords = [];
        for pc = 1:size(buff,1)
            for pr = 1:size(buff,1)
                is_covered_by_two_lines = all(buff(:,pc) == inf) & all(buff(pr,:) == inf);
                if is_covered_by_two_lines == 1
                    cords=[cords; pr pc];

                end
            end
        end
        buff(unmark_rows,:) = reduction_col(unmark_rows,:);
        buff(:,mark_col) = reduction_col(:,mark_col);
        for o = 1:size(cords,1)
            buff(cords(o,1), cords(o,2)) = buff(cords(o,1), cords(o,2)) + min_buff;
        end
        % We got a new matrix that we have to check again by going back
        % to step 3 for checking if the number of assigned cells = the number of rows
    end
    
    % Step 7 Making the final assignment
    optimal_assign = size(find(buff==inf),1);
    ASSIGN_cost = zeros(size(buff,1),1);
    ASSIGN = zeros(1,size(buff,2));
    if optimal_assign == size(buff,1)
        for pw = 1:size(reduction_col)
            optimal_solution_in_row = find(buff(pw,:)==inf);
            ASSIGN_cost(pw,1) = estimate_distance_temp(pw,optimal_solution_in_row);
            ASSIGN(1,pw) = optimal_solution_in_row;
        end
    else
        buff_logical = buff == inf;
        while find(buff_logical)
            countZiR = sum(buff_logical,2);
            countZiR(countZiR ==0) = inf;
            [~, R] = min(countZiR);
            C = find(buff_logical(R,:),1,'first');
            buff_logical(R,:) = 0;
            buff_logical(:,C) = 0;
            ASSIGN_cost(R,1) = estimate_distance_temp(R,C);
            ASSIGN(1,R) = C;
        end
    end

    P = F_t * P * F_t' + Ex;    % Elimination of measurement covariance
    K = P * H_t' * inv(H_t * P * H_t' + Ez);    %   Kalman Gain
    % Update our variable
    for t = 1:number_markers
        X_estimate(:,t) = X_estimate(:,t) + K* (X(1:2,ASSIGN(t),frameNum) - H_t * X_estimate(:,t));
        X_estimate(1:2,t) = X(1:2,ASSIGN(t),frameNum);
    end
    P =  (eye(4)-K*H_t)*P;    % Update covariance estimate
    X_loc_estimate(:,:,frameNum) = [X_estimate(1:2,1:t)]';
    v_estimate(:,:,frameNum) = [X_estimate(3:4,1:t)];


    %% Shooting a movie
    f = figure('visible', 'off');
    imshow(B);
    hold on
    plot(markers(:,1),markers(:,2),'r*');
    for c=1:t
        plot(r*cos(theta)+X_estimate(1,c),r*sin(theta)+X_estimate(2,c),'color',c_list(c),'linewidth',3); % tracking with Kalman filter
    end
    frame = getframe;
    film_wyjsciowy(frameNum) = frame;
    close(f);
    film.CurrentTime = trackingStart + (frameNum/film.FrameRate);
end


%% Save the movie
objWrite = VideoWriter(filmKalmanTitle,'MPEG-4');   %   name of the saved movie
open(objWrite);
writeVideo(objWrite, film_wyjsciowy);
close(objWrite);
end 



