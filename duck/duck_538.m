% -------------------------------------------------------------------------
% Simulation 1: The duck gets out of phase along an inner circle, then
% bolts for the shore when 180 degrees out of phase. The result is an
% animated figure, that can be screen-captured for video.
% -------------------------------------------------------------------------

dog_speed = 3.75;
duck_speed = 1;

t_interval = 0.025;
inner_radius = 0.8*duck_speed/dog_speed;    % duck still out-angles dog
outer_radius = 1;

% Initialize polar coordinates
dog_rad = [1 0];
duck_rad = [0 0];

% Initialize cartesian coordinates
dog_cart = [dog_rad(1)*cos(dog_rad(2)) dog_rad(1)*sin(dog_rad(2))];
duck_cart = [duck_rad(1)*cos(duck_rad(2)) duck_rad(1)*sin(duck_rad(2))];

% Initialize figure
figure(1);
clf;
hold on;
theta = 0:0.01:2*pi;
plot(0,0,'w.','MarkerSize',40);
plot(outer_radius*cos(theta),outer_radius*sin(theta),'w','LineWidth',5);
plot(inner_radius*cos(theta),inner_radius*sin(theta),'w','LineWidth',3);
plot(dog_cart(1),dog_cart(2),'b.','MarkerSize',80);
plot(duck_cart(1),duck_cart(2),'r.','MarkerSize',60);
axis equal;
axis off;
pause(0.5);

% Have the dug move directly toward the dog until it's on the inner circle
for k = 0:duck_speed*t_interval:inner_radius
    
    % Update the duck's position. The dog is not yet moving.
    duck_rad(1) = k;
    duck_cart(1) = duck_rad(1)*cos(duck_rad(2));
    
    % Plot current positions
    figure(1);
    clf;
    hold on;
    theta = 0:0.01:2*pi;
    plot(0,0,'w.','MarkerSize',30);
    plot(outer_radius*cos(theta),outer_radius*sin(theta),'w','LineWidth',5);
    plot(inner_radius*cos(theta),inner_radius*sin(theta),'w','LineWidth',3);
    plot(dog_cart(1),dog_cart(2),'b.','MarkerSize',80);
    plot(duck_cart(1),duck_cart(2),'r.','MarkerSize',60);
    axis equal;
    axis off;
    pause(0.01);
    
end
duck_rad(1) = inner_radius;

% The duck moves around the inner circle until it's 180 degrees out of
% phase from the dog
k = 0;
while (duck_rad(2) - dog_rad(2)) < pi
    
    % Both move around their respective circles at their respective speeds
    duck_rad(2) = duck_speed*k/inner_radius;
    dog_rad(2) = dog_speed*k/outer_radius;
    
    % Convert to cartesian coordinates
    dog_cart = [dog_rad(1)*cos(dog_rad(2)) dog_rad(1)*sin(dog_rad(2))];
    duck_cart = [duck_rad(1)*cos(duck_rad(2)) duck_rad(1)*sin(duck_rad(2))];
    
    % Plot current positions
    figure(1);
    clf;
    hold on;
    theta = 0:0.01:2*pi;
    plot(0,0,'w.','MarkerSize',30);
    plot(outer_radius*cos(theta),outer_radius*sin(theta),'w','LineWidth',5);
    plot(inner_radius*cos(theta),inner_radius*sin(theta),'w','LineWidth',3);
    plot(dog_cart(1),dog_cart(2),'b.','MarkerSize',80);
    plot(duck_cart(1),duck_cart(2),'r.','MarkerSize',60);
    axis equal;
    axis off;
    pause(0.01);
    
    k = k + t_interval;
end

% The duck bolts for the nearest shore, while the dog continues moving
% around the outer circle
k = 0;
while duck_rad(1) < 1 - t_interval*duck_speed
    
    % The duck moves radially outward, while the dog continues around outer
    % circle
    duck_rad(1) = duck_rad(1) + duck_speed*t_interval;
    dog_rad(2) = dog_rad(2) + dog_speed*t_interval/outer_radius;
    
    % Convert to cartesian coordiantes
    dog_cart = [dog_rad(1)*cos(dog_rad(2)) dog_rad(1)*sin(dog_rad(2))];
    duck_cart = [duck_rad(1)*cos(duck_rad(2)) duck_rad(1)*sin(duck_rad(2))];
    
    % Update the figure
    figure(1);
    clf;
    hold on;
    theta = 0:0.01:2*pi;
    plot(0,0,'w.','MarkerSize',30);
    plot(outer_radius*cos(theta),outer_radius*sin(theta),'w','LineWidth',5);
    plot(inner_radius*cos(theta),inner_radius*sin(theta),'w','LineWidth',3);
    plot(dog_cart(1),dog_cart(2),'b.','MarkerSize',80);
    plot(duck_cart(1),duck_cart(2),'r.','MarkerSize',60);
    axis equal;
    axis off;
    pause(0.01);
    
    k = k + t_interval;
end

% Final positioning to ensure smooth animation
duck_rad(1) = 1;
dog_rad(2) = dog_rad(2) + dog_speed*t_interval/outer_radius;
duck_cart = [duck_rad(1)*cos(duck_rad(2)) duck_rad(1)*sin(duck_rad(2))];
dog_cart = [dog_rad(1)*cos(dog_rad(2)) dog_rad(1)*sin(dog_rad(2))];

% Final update to the figure
figure(1);
clf;
hold on;
theta = 0:0.01:2*pi;
plot(0,0,'w.','MarkerSize',30);
plot(outer_radius*cos(theta),outer_radius*sin(theta),'w','LineWidth',5);
plot(inner_radius*cos(theta),inner_radius*sin(theta),'w','LineWidth',3);
plot(dog_cart(1),dog_cart(2),'b.','MarkerSize',80);
plot(duck_cart(1),duck_cart(2),'r.','MarkerSize',60);
axis equal;
axis off;



% -------------------------------------------------------------------------
% Simulation 2: The duck escapes tangentially from the angular velocity
% inner circle. The result is a GIF file, 'tangent.gif'.
% -------------------------------------------------------------------------

duck_speed = 1;
dog_speed = 4.6;

inner_radius = duck_speed/dog_speed;    % where angular velocities match
outer_radius = 1;

% Initialize polar coordinates
duck_rad = [inner_radius, 0];
dog_rad = [outer_radius, -pi];

% Initialize cartesian coordinates
duck_cart = [duck_rad(1)*cos(duck_rad(2)), duck_rad(1)*sin(duck_rad(2))];
dog_cart = [dog_rad(1)*cos(dog_rad(2)), dog_rad(1)*sin(dog_rad(2))];

% Time step
t_step = 0.001;

% Initialize the figure
figure(2);
clf;
hold on;
theta = 0:0.01:2*pi;
plot(0,0,'w.','MarkerSize',30);
plot(outer_radius*cos(theta),outer_radius*sin(theta),'w','LineWidth',5);
plot(inner_radius*cos(theta),inner_radius*sin(theta),'w','LineWidth',3);
plot(dog_cart(1),dog_cart(2),'b.','MarkerSize',60);
    plot(duck_cart(1),duck_cart(2),'r.','MarkerSize',60);
axis equal;
axis off;
pause(1);

% Filename for GIF
filename = 'tangent.gif';

gif_flag = 0;
counter = 0;

% Run the following loop while the duck is in the pond
while duck_rad(1) < 1

    % Update the dog's position around the cirucmference
    dog_rad(2) = dog_rad(2) + dog_speed*t_step/outer_radius;
    dog_cart = [dog_rad(1)*cos(dog_rad(2)), dog_rad(1)*sin(dog_rad(2))];
    
    % Update the duck's position along tangent to inner circle
    duck_cart(2) = duck_cart(2) + duck_speed*t_step;    
    duck_rad(1) = sqrt(sum(duck_cart.^2));
    duck_rad(2) = atan2(duck_cart(2),duck_cart(1));
   
    % Update the figure, plotting the new positions of the dog and the duck
    % (don't clear the figure, resulting in an apparent trail)
    figure(2);
    hold on;    
    plot(dog_cart(1),dog_cart(2),'b.','MarkerSize',20);
    plot(duck_cart(1),duck_cart(2),'r.','MarkerSize',20);
    
    pause(0.001);
    
    % Every 1/10 frames, store for the GIF
    if mod(counter,10) == 0        
        drawnow
        frame = getframe(1);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if gif_flag == 0;
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.1);
            gif_flag = 1;
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1);
        end       
    end
    counter = counter+1;
    
end