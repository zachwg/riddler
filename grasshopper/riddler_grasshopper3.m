filename = 'grasshopper.gif';
gif_flag = 0;

% -------------------------------------------------------------------------
% parameters --------------------------------------------------------------
% -------------------------------------------------------------------------

% pixels
pixel_length = 0.01;

% yard
yard_area = 1;
yard_length = round(sqrt(yard_area) / pixel_length);
yard_pixels = round(yard_area/pixel_length^2);

% space (from which yard is sampled)
space_length = 2;
length_pixels = round(space_length/pixel_length);
space_pixels = length_pixels^2;

% grasshopper
grasshopper_distance = 0.3;
grasshopper_pixels = round(grasshopper_distance/pixel_length);

% -------------------------------------------------------------------------
% calculation matrices ----------------------------------------------------
% -------------------------------------------------------------------------

% yard_matrix (1 if yard, 0 if not yard);
yard_matrix = zeros(space_length/pixel_length);

% neighbor_matrix (number of yard_matrix 1's that are grasshopper_distance
% away
neighbor_matrix = zeros(space_length/pixel_length);

% grasshopper_matrix (matrix containing 1's that are grasshopper_distance
% from center)
grasshopper_checker = zeros(0,2);
for i = -grasshopper_pixels:grasshopper_pixels
    for j = -grasshopper_pixels:grasshopper_pixels
        distance_from_center = sqrt(i^2 + j^2);
        if round(distance_from_center) == grasshopper_pixels
            grasshopper_checker = [grasshopper_checker; i, j];
        end
    end
end

% select a number (yard_pixels) of random points in the space
offset = round((length_pixels - yard_length) / 2);
for i = 1:yard_length
    for j = 1:yard_length
        yard_matrix(i + offset, j + offset) = 1;
    end
end     

% calculate initial neighbor_matrix
for i = 1:length_pixels
    for j = 1:length_pixels
        for k = 1:size(grasshopper_checker, 1)
            delta_x = grasshopper_checker(k, 1);
            delta_y = grasshopper_checker(k, 2);
            if (i + delta_x) >= 1 && (i + delta_x) <= length_pixels ...
                    && (j + delta_y) >= 1 && (j + delta_y) <= length_pixels
                if yard_matrix(i + delta_x, j + delta_y) == 1
                    neighbor_matrix(i, j) = neighbor_matrix(i, j) + 1;
                end
            end
        end
    end
end

% -------------------------------------------------------------------------
% iterate (until stable):
%   1. remove yard pixel with lowest neighbor_matrix value
%   2. update neighbor matrix
%   3. add non-garden pixel highest neighbor_matrix value
%   4. update neighbor matrix
%   5. plot yard_matrix .* neighbor_matrix
% -------------------------------------------------------------------------

% 5. plot yard_matrix .* neighbor_matrix
figure(1);
clf;
axes('position', [0, 0, 1, 1]);
axis equal;
axis off;
set(gcf, 'position', [100, 100, 400, 400]);

colormap('parula');
temp_colormap = colormap;
colormap([0, 0, 0; temp_colormap]);
imagesc(yard_matrix .* (neighbor_matrix + 1));

drawnow;
    
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','Loopcount',inf,'DelayTime',0.5);

old_yard_matrix = zeros(size(yard_matrix));
counter = 0;
graph_counter = 0;

while ~isequal(old_yard_matrix, yard_matrix)
    
    old_yard_matrix = yard_matrix;

    % 1. remove yard pixel with lowest neighbor_matrix value
    [p, q] = find(yard_matrix == 1);
    yard_table = [p, q];
    neighbor_value = zeros(yard_pixels, 1);
    for i = 1:size(yard_table, 1)
        neighbor_value(i) = neighbor_matrix(yard_table(i,1), yard_table(i,2));
    end
    p = min(neighbor_value);
    min_array = find(neighbor_value == p);
    q = min_array(randperm(size(min_array, 1), 1));

    yard_to_remove = yard_table(q,:);
    yard_matrix(yard_to_remove(1), yard_to_remove(2)) = 0;

    % 2. update neighbor matrix
    for k = 1:size(grasshopper_checker, 1)
        delta_x = grasshopper_checker(k, 1);
        delta_y = grasshopper_checker(k, 2);
        if (yard_to_remove(1) + delta_x) >= 1 && (yard_to_remove(1) + delta_x) <= length_pixels ...
                && (yard_to_remove(2) + delta_y) >= 1 && (yard_to_remove(2) + delta_y) <= length_pixels
            neighbor_matrix(yard_to_remove(1) + delta_x, yard_to_remove(2) + delta_y) = ...
                neighbor_matrix(yard_to_remove(1) + delta_x, yard_to_remove(2) + delta_y) - 1;
        end
    end

    % 3. add non-garden pixel highest neighbor_matrix value
    [p, q] = find(yard_matrix == 0);
    yard_table = [p, q];
    neighbor_value = zeros(yard_pixels, 1);
    for i = 1:size(yard_table, 1)
        neighbor_value(i) = neighbor_matrix(yard_table(i,1), yard_table(i,2));
    end
    p = max(neighbor_value);
    max_array = find(neighbor_value == p);
    q = max_array(randperm(size(max_array, 1), 1));

    yard_to_add = yard_table(q,:);
    yard_matrix(yard_to_add(1), yard_to_add(2)) = 1;

    % 4. update neighbor matrix
    for k = 1:size(grasshopper_checker, 1)
        delta_x = grasshopper_checker(k, 1);
        delta_y = grasshopper_checker(k, 2);
        if (yard_to_add(1) + delta_x) >= 1 && (yard_to_add(1) + delta_x) <= length_pixels ...
                && (yard_to_add(2) + delta_y) >= 1 && (yard_to_add(2) + delta_y) <= length_pixels
            neighbor_matrix(yard_to_add(1) + delta_x, yard_to_add(2) + delta_y) = ...
                neighbor_matrix(yard_to_add(1) + delta_x, yard_to_add(2) + delta_y) + 1;
        end
    end

    % 5. plot yard_matrix .* neighbor_matrix
    figure(1);
    clf;
    axes('position', [0, 0, 1, 1]);
    axis equal;
    axis off;
    set(gcf, 'position', [100, 100, 400, 400]);

    colormap('parula');
    temp_colormap = colormap;
    colormap([0, 0, 0; temp_colormap]);
    imagesc(yard_matrix .* (neighbor_matrix + 1));
    
    % display probability of staying inside the yard
    prob = sum(sum(neighbor_matrix .* yard_matrix))/yard_pixels/size(grasshopper_checker,1)
    
    if mod(counter, 20) == 0
        drawnow;
        
        frame = getframe(1);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.02);
    end
    
    counter = counter + 1;
    
end

drawnow;
        
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',1);