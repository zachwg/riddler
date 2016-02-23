% Dimensions of the plane
num_rows = 20;
num_cols = 5;
num_seats = num_rows * num_cols;

% If nearest_flag equals 0, bumped passengers pick a RANDOM seat. If
% nearest_flag equals 1, bumped passengers pick the NEAREST seat. If
% multiple seats are equally near, then the passenger will pick one of
% them at random.
nearest_flag = 1;

% Calculate x/y-coordinates for each seat
seat_xy = zeros(num_seats,2);
for i = 1:num_seats
    seat_xy(i,1) = floor((i-1)/num_rows);
    seat_xy(i,2) = mod(i-1,num_rows);
end

% Number of iterations. For a plane with 100 seats, 10^7 is sufficient
% to generate smooth graphs, but can take a few minutes to run.
num_iter = 100000;

% Array of outcomes for whether YOU get YOUR seat, by iteration
outcome_array = zeros(num_iter,1);

% Second array of outcomes: Each row corresponds to a different seat. The
% first column is how many times you successfully sat in that seat when it
% was assigned to you, while the second column is how many times that seat
% was assigned to you. So the success rate for a given seat (row) is the
% number in the first column divided by the number in the second column.
outcome_by_seat = zeros(num_seats,2);

% Initialize waitbar
h = waitbar(0,'Please wait...');

for z = 1:num_iter
    
    % Update waitbar in 1% increments
    if mod(z,num_iter/100)==0
        waitbar(z/num_iter,h);
    end
    
    % Randomly assign seats
    seats_assigned = randperm(num_seats);
    
    % Arrays of which seats are taken and available. Available seats are
    % assigned a 1, while occupied seats are assigned a 0.
    seats_available = ones(1,num_seats);
    
    % A history of the ordering in which seats are occupied.
    seats_taken = zeros(1,num_seats);
    
    % The first passenger picks a random seat.
    seat_picked = randi(num_seats,1);
    seats_available(seat_picked) = 0;
    seats_taken(1) = seat_picked;
    
    % The remaining passengers take their seats.
    for i = 2:num_seats
        
        % If assigned seat is available, sit in it
        if seats_available(seats_assigned(i))==1
            seats_available(seats_assigned(i)) = 0;
            seats_taken(i) = seats_assigned(i);
        
        % If assigned seat is not available, find another seat
        else
            
            % Find all unoccupied seats
            seats_open = find(seats_available==1);
            
            % If nearest_flag equals zero, bumped passengers pick a
            % RANDOM seat. If nearest_flag equals 1, bumped passengers
            % pick the NEAREST seat. If multiple seats are equally near,
            % then the passenger will pick one of them at random.
            if nearest_flag == 0
                seats_open = find(seats_available==1);
                seat_picked = seats_open(randi(length(seats_open),1));
            else
                % Calculate distances to all seats
                seats_distance = sqrt(sum((repmat(seat_xy(seats_assigned(i),:),size(seats_open,2),1) - seat_xy(seats_open,:)).^2,2));
                
                % identify closest seats
                seats_closest = find(seats_distance==min(seats_distance));
                seat_picked = seats_open(seats_closest(randi(length(seats_closest),1)));
            end
            
            % The seat is now occupied and recorded in seats_taken.
            seats_available(seat_picked) = 0;
            seats_taken(i) = seat_picked;
        end
    end
    
    % Record whether YOUR seat matches your ASSIGNED seat. Also update the
    % corresponding row in outcome_by_seat.
    outcome_array(z) = seats_assigned(num_seats)==seats_taken(num_seats);
    outcome_by_seat(seats_assigned(num_seats),:) = outcome_by_seat(seats_assigned(num_seats),:) + ...
        [outcome_array(z) 1];
    
end
close(h);

% -------------------------------------------------------------------------
% Calculate the main result for bumped passengers who pick a RANDOM seat,
% i.e., how often YOU keep YOUR seat.
% -------------------------------------------------------------------------
mean(outcome_array)

% -------------------------------------------------------------------------
% Plot the graphical result for bumped passengers who pick the NEAREST
% seat, showing how often YOU keep YOUR seat depending on WHERE your seat
% is on the plane.
% -------------------------------------------------------------------------

if nearest_flag == 1
    
    % Calculate the mean outcome for each seat
    outcome_mean = outcome_by_seat(:,1)./outcome_by_seat(:,2);
    
    % Plot each seat's x/y coordinates and color based on how often you keep
    % your seat. Red = 0%, Yellow = 50%, Green = 100%.
    figure(1);
    clf;
    hold on;
    for i = 1:num_seats
        % Calculate the corresponding RGB color array for the seat.
        color_array = [min(2-2*outcome_mean(i),1) min(2*outcome_mean(i),1) 0];
        % Plot the seat as a large dot.
        plot(seat_xy(i,1),seat_xy(i,2),'.','MarkerSize',100,'Color',color_array);
    end
    axis equal
    axis off;
    
end