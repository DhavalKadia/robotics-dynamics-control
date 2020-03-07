%   Dhaval Kadia (101622808): Robotics - Dynamics and Control: Assignment 2

clear;
close;

%%  Please select the test case: Enter 1 or 2
test_case = 1;

if test_case == 1
    x0      = 5;
    y0      = 5;
    v0      = 1;
    theta0	= pi / 3;
    xn      = 5.5;
    yn      = 4.9;
    N = 4;
elseif test_case == 2
    x0      = 1;
    y0      = 1;
    v0      = 1;
    theta0	= pi / 4;
    xn      = 2;
    yn      = 1;
    N = 8;
end

initial_State   = [x0, y0, v0, theta0];
target_State    = [xn, yn];
tol             = 0.1;
delta   = 0.1;

%% Find Control Inputs
ci = findControlInputs(initial_State, target_State, tol, N);

%%  Simulate the result using the equation and the control inputs
if ci ~= -1
    graph = zeros(2, N + 1);

    eq =  [1    0   0   -delta ;
           0    1   0   delta  ; 
           0    0   1   0      ;
           0    0   0   1      ];

    vals = [x0; y0; v0; theta0];
    
    add = [delta; 0; 0; 0];

    graph(1:2, 1) = [x0; y0];

    %   Stepwise matrix multiplication of the equation and the control inputs
    for i = 1:N
        add(4) = delta * ci(i);
        vals = eq * vals + add;
        graph(1:2, 1 + i) = vals(1:2);
    end
    
    xlabel('x') 
    ylabel('y') 
    
    plot(graph(1,:), graph(2,:));
    hold on
    plot(x0, y0,'o', 'MarkerSize',10, 'MarkerEdgeColor','black', 'MarkerFaceColor',[0 0 0])
    plot(graph(1, 1 + N), graph(2, 1 + N),'p', 'MarkerSize',10, 'MarkerEdgeColor','black', 'MarkerFaceColor',[0 0 0])
else
    disp("The solution is not possible using " + string(N) + " steps");
end

%%  Required function
function ci = findControlInputs(initialState, targetState, tol, N)

    x0 = initialState(1);
    y0 = initialState(2);
    v0 = initialState(3);
    theta0 = initialState(4);
    
    xn = targetState(1);
    yn = targetState(2);
    
    ci_min  = -10;
    ci_max  = 10;
    delta   = 0.1;
    
    %   Initialize Aeq
    Aeq = zeros((N + 1) * 4, (N + 1) * 4 + N);
    
    %   Define Aeq
    Aeq(1:(N + 1) * 4, 1:(N + 1) * 4) = eye((N + 1) * 4);

    Aeq(5: (N + 1) * 4, 1:N * 4) = Aeq(5: (N + 1) * 4, 1:N * 4) + eye(N * 4) * -1;

    for i = 1:N
        Aeq(i * 4 + 1:i * 4 + 2, i * 4) = [delta; delta];
        Aeq(i * 4 + 4, (N + 1) * 4 + i) = -delta;
    end

    %   Define beq
    beq = [ x0; 
            y0; 
            v0; 
            theta0];

    for i = 1:N
        beq = [beq; delta; 0; 0; 0];
    end

    %   Initialize A
    A = zeros(8, (N + 1) * 4 + N);
    
    %   Define A
    A(1:2, N * 4 + 1) = [-1; 1];
    A(3:4, N * 4 + 2) = [-1; 1];

    for i = 1:N
        A(4 + i * 2 - 1:4 + i * 2, (N + 1) * 4 + i) = [-1; 1];
    end
    
    %   Define b
    b = [ -(xn - tol); 
          xn + tol; 

          -(yn - tol); 
          yn + tol]; 

    for i = 1:N
        b = [b; -ci_min; ci_max];
    end

    f = zeros((N + 1) * 4 + N, 1);
    
    %   Find the solution
    result = linprog(f, A, b, Aeq, beq);
    
    found = size(result);
    
    save('a.mat', 'A');
    save('Aeq.mat', 'Aeq');
    save('b.mat', 'b');
    save('beq.mat', 'beq');
    
    if found > 0
        ci = result((N + 1) * 4 + 1: (N + 1) * 4 + N);
    else
        ci = -1;
    end
end