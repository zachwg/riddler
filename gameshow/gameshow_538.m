% Define arrays for the ranges of p and q. p is the cutoff for Player 1,
% while q is the cutoff for Player 2 (and Player 3).
p_array = 0:0.001:1;
q_array = 0:0.001:1;

% 'chances_2' is a matrix that stores Player 1's chances of winning over all
% values of p and q, for a two player game. 'chances_3' is for a three
% player game.
chances_2 = zeros(length(p_array),length(q_array));
chances_3 = zeros(length(p_array),length(q_array));

% 'fair_tracker' is an Nx2 matrix that stores the values of p and q for
% which all players have an approximately equal chance of winning the
% game. It will help to identify the location of the Nash equilibrium,
% should one exist.
fair_tracker_2 = zeros(0,2);
fair_tracker_3 = zeros(0,2);

% Calculate each value of the 'chances' matrix by iterating through all
% values of p and q
for i = 1:size(chances_2,1)
    for j = 1:size(chances_2,2)
        
        p = p_array(i);
        q = q_array(j);
        
        % If p >= q, use the first formula for determining Player 1's
        % chances. If p < q, use the second formula.
        if p >= q
            chances_2(i,j) = 1/2*p*q + 1/2*(1-p^2)*q + 1/2*p*(1-q)^2 + 1/2*(1-p)*(1+p-2*q);
            chances_3(i,j) = p*q^2 * 1/3 + ...
                (1-p)*q^2 * (p^2+p*(1-p)+1/3*(1-p)^2) + ...
                2 * p*q*(1-q) * (1/2*q*(1-q)+1/3*(1-q)^2) + ...
                2 * (1-p)*q*(1-q) * (p*(p-q)/(1-q) + 1/2*p*(1-p)/(1-q) + 1/2*(1-p)*(p-q)/(1-q) + 1/3*(1-p)*(1-p)/(1-q)) + ...
                p*(1-q)^2 * 1/3*(1-q) + ...
                (1-p)*(1-q)^2 * (((p-q)/(1-q))^2 + (p-q)/(1-q)*(1-p)/(1-q) + 1/3*((1-p)/(1-q))^2);
        else
            chances_2(i,j) = 1/2*p*q + 1/2*(1-p^2)*q + 1/2*p*(1-q)^2 + 1/2*(1-q)^2;
            chances_3(i,j) = p*q^2 * 1/3 + ...
                (1-p)*q^2 * (p^2+p*(1-p)+1/3*(1-p)^2) + ...
                2 * p*q*(1-q) * (1/2*q*(1-q)+1/3*(1-q)^2) + ...
                2 * (1-p)*q*(1-q) * (1/2*q*(1-q)/(1-p) + 1/3*(1-q)*(1-q)/(1-p)) + ...
                p*(1-q)^2 * 1/3*(1-q) + ...
                (1-p)*(1-q)^2 * 1/3*(1-q)/(1-p);
        end
        
        % If 'chances' matrix crosses over a value of 1/2 (or 1/3 for 3
        % players), store those specific values of p and q as a new row in
        % 'fair_tracker'.
        if j > 1
            if (chances_2(i,j) >= 1/2 && chances_2(i,j-1) < 1/2) || (chances_2(i,j) <= 1/2 && chances_2(i,j-1) > 1/2)
                fair_tracker_2 = [fair_tracker_2; p_array(i) q_array(j)];
            end
            if (chances_3(i,j) >= 1/3 && chances_3(i,j-1) < 1/3) || (chances_3(i,j) <= 1/3 && chances_3(i,j-1) > 1/3)
                fair_tracker_3 = [fair_tracker_3; p_array(i) q_array(j)];
            end
        end
       
    end
end

% Plot a square image of 'chances_2' as a function of p and q. Also plot
% coordinates for which each player's chances are 1/2 in red.
figure(1);
clf;
hold on;
imagesc(p_array,q_array,chances_2');
plot(fair_tracker_2(:,1),fair_tracker_2(:,2),'r.','MarkerSize',5);
axis([0 1 0 1]);
axis equal;
axis off;

% Plot a square image of 'chances_3' as a function of p and q. Also plot
% coordinates for which each player's chances are 1/3 in red.
figure(2);
clf;
hold on;
imagesc(p_array,q_array,chances_3');
plot(fair_tracker_3(:,1),fair_tracker_3(:,2),'r.','MarkerSize',5);
axis([0 1 0 1]);
axis equal;
axis off;