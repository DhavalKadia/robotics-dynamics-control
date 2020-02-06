%% Dhaval Kadia: 101622808

%   Random generation of 100 trajectories 
for i = 1:100
    
    % The domain of initial state set (random generation as per the requirement)
    x0 = 1.15 + rand()*0.2;
    y0 = 2.35 + rand()*0.1;
    
    %   Time horizon [0,10]
    time = [0 10];
    
    %   Solution using MATLAB ode45 function
    [T xy] = ode45(@dynamics, time, [x0 y0]);
    
    %   The solution x and y are xy(:,1) and xy(:,2)
    plot(xy(:,1), xy(:,2), 'color', 'b', 'linewidth', 1);
    hold on;
end

xlabel('x') 
ylabel('y') 

%%
%   Given ODE
%   xy(1) represents x
%   xy(2) represents y    
%   dxdy(1) represents x_dot
%   dxdy(2) represents y_dot
    
function dxdy = dynamics(t, xy)

    dxdy = zeros(2,1);
    
    dxdy(1) = xy(2);
    dxdy(2) = (1 - xy(1) * xy(1)) * xy(2) - xy(1);

end