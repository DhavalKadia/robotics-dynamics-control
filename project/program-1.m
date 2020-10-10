% Final project
% This program gives us the control inputs for the desired part of the problem

% Problem: obtain the control input A1 so that toy comes to nearby -15
% The [lo, up] = [-30, -29.0625] above the SAT in termila gives the value
% of A1.

clear all;
clc;

eps = 3;
x0 = 0;
v0 = 10;
x2 = -15;

X0 = Interval(x0 - eps, x0 + eps);
V0 = Interval(v0 - eps, v0 + eps);
A1 = Interval(-30, 30);

domain = [X0, V0, A1];

queue = Queue();
queue.enqueue(domain);

unknown = false;
sat = false;
epsilon = 0.01;

while ~queue.isempty()
    domain = queue.dequeue();
    
    oi_1 = function_1(domain)   % represents the final position of toy [should be between [x2 - eps, x2 + eps]
    
    [sat_1, unsat_1] = lesser(oi_1, x2 + eps);
    [sat_2, unsat_2] = greater(oi_1, x2 - eps);
    
    if sat_1 &&  sat_2                      % SAT
        sat = true;
        disp_refinement(domain, 2);
        break;
    elseif unsat_1 && unsat_2               % UNSAT
        disp_refinement(domain, 0);
    else                                    % UNKNOWN -> further refinement
        [max_width, index] = get_max_w_id(domain);
        
        if max_width >= epsilon
            [domain_1, domain_2] = split_domain(domain, index);
            
            disp_refinement(domain, 1);
            queue.enqueue(domain_1);
            queue.enqueue(domain_2);
        else
            unknown = true;
        end
    end
    
    if sat
        disp("SAT!");
    elseif unknown
        disp("UNKNOWN!");
    else
        disp("UNSAT!");
    end
end

function disp_refinement(domain, decision)
    n_domains = size(domain);
    n_domains = n_domains(2);
    
    for i = 1:n_domains
        domain(i).disp();
    end

    if decision == 0
        disp(" (UNSAT) => discarded.");
    elseif decision == 1
        disp(" (UNKNOWN) => subdivided and added back to the queue.");
    else
        disp(" (SAT) => terminate the program.");
    end
end

function [sat, unsat] = greater(interval, value)
    sat = interval.lo >= value;
    unsat = interval.up < value;
end

function [sat, unsat] = lesser(interval, value)
    sat = interval.up <= value;
    unsat = interval.lo > value;
end


function X_2 = function_1(domain)
    X_0 = domain(1);
    V_0 = domain(2);
    A_1 = domain(3);
%     A_2 = domain(4);
    
    X_1 = X_0 + V_0;
    V_1 = V_0 + A_1;
    
    X_2 = X_1 + V_1;
end

function eq_output = function_2(domain)
    eq_output = (domain(1)*domain(1) + domain(2)*domain(2));    
    eq_output = Interval(-1, -1) * eq_output;
    eq_output = eq_output + Interval(5, 5);
end

function [max_width, index] = get_max_w_id(domain)
    n_domains = size(domain);
    n_domains = n_domains(2);
    
    widths = zeros(n_domains);
    for i = 1:n_domains
        widths(i) = domain(i).width;
    end
    
    [max_width, index] = max(widths);
    max_width = max_width(1);
    index = index(1);    
end

function [split_1, split_2] = split_domain(domain, index)
    [X1, X2] = domain(index).split();
    
    split_1 = domain;
    split_2 = domain;
    
    split_1(index) = X1;
    split_2(index) = X2;
end