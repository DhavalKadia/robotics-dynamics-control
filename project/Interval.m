%   Assignment 4

classdef Interval < handle
	properties
        lo = [];    % lower bound of the interval
        up = [];    % upper bound of the interval
    end
    
	methods	
        function obj = Interval(lo, up)	            
            if lo <= up
                obj.lo = lo;
                obj.up = up;   
            else
                disp('enter valid range');
                return
            end
        end
        
        function disp(obj)
            info = ['[lo, up] = [', num2str(obj.lo),', ', num2str(obj.up), ']'];
            disp(info);
        end
        
        function [X1, X2] = split(obj)
            X1 = Interval(obj.lo, (obj.lo + obj.up) / 2);
            X2 = Interval((obj.lo + obj.up) / 2, obj.up);
        end
        
        function add = plus(obj1, obj2)
            lo = obj1.lo + obj2.lo;
            up = obj1.up + obj2.up;
            add = Interval(lo, up);
        end
        
        function sub = minus(obj1, obj2)
            lo = obj1.lo - obj2.up;
            up = obj1.up - obj2.lo;
            sub = Interval(lo, up);
        end
        
        function mul = mtimes(obj1, obj2)
            lo = min([obj1.lo * obj2.lo, obj1.lo * obj2.up, obj1.up * obj2.lo, obj1.up * obj2.up]);
            up = max([obj1.lo * obj2.lo, obj1.lo * obj2.up, obj1.up * obj2.lo, obj1.up * obj2.up]);
            mul = Interval(lo, up);
        end
        
        function div = mrdivide(obj1, obj2)            
            if obj2.up == 0 || obj2.lo == 0
                disp('divide by zero error');
                return                
            else
                obj2 = Interval(1 / obj2.up, 1 / obj2.lo);
                div = mtimes(obj1, obj2);
            end
        end	
        
        function w = width(obj)
            w = obj.up - obj.lo;
        end
        
        function mid = midpoint(obj)
            mid = (obj.lo + obj.up) / 2;
        end
        
        function mag = magnitude(obj)
            mag = max([abs(obj.lo), abs(obj.up)]);
        end
        
        function pow_interval = mpower(obj, m)
            a = obj.lo;
            b = obj.up;
            
            if mod(m, 2) == 0
                if a >= 0
                    pow_a = power(a, m);
                    pow_b = power(b, m);
                else
                    if b >= 0
                        pow_a = 0;
                        pow_b = max([power(a, m), power(b, m)]);
                    else
                        pow_a = power(b, m);
                        pow_b = power(a, m);
                    end
                end
            else
                pow_a = power(a, m);
                pow_b = power(b, m);
            end
            
            pow_interval = Interval(pow_a, pow_b); 
        end
        
        function interval = interval_cosine(obj)
            obj.lo = obj.lo + pi / 2;
            obj.up = obj.up + pi / 2;
            
            interval = interval_sin(obj);
        end

        function interval = interval_sin(obj)
            a = obj.lo;
            b = obj.up;
            
            case_sin = crossing_sin(obj, a, b);

            a_sin = 999;
            b_sin = 999;

            if case_sin == 1
                a_sin = -1;
                b_sin = 1;
            elseif case_sin == 2
                a_sin = -1;
                b_sin = max([sin(a), sin(b)]);
            elseif case_sin == 3
                a_sin = min([sin(a), sin(b)]);
                b_sin = 1;
            else
                a_sin = min([sin(a), sin(b)]);
                b_sin = max([sin(a), sin(b)]);
            end
            
            interval = Interval(a_sin, b_sin);
        end

        function sat_case = crossing_sin(obj, a, b)

            [n1, quad1] = get_n_quad(obj, a);
            [n2, quad2] = get_n_quad(obj, b);  

            if n1 > n2
                temp = n1;
                n1 = n2;
                n2 = n1;

                temp = quad1;
                quad1 = quad2;
                quad2 = quad1;
            end

            if n1 == n2 && quad1 > quad2
                temp = quad1;
                quad1 = quad2;
                quad2 = quad1;
            end

            sat_case = 0;

            up = 999;
            down = 999;

            if n1 == n2
                if (quad1 + quad2) / 2 == 1.5
                    up = 1;
                elseif (quad1 + quad2) / 2 == 3.5
                    down = -1;
                end

                if quad1 == 1
                    if quad2 == 3
                        up = 1;
                    elseif quad2 > 3
                        up = 1;
                        down = -1;
                    end
                elseif quad1 == 2
                    if quad2 > 3
                        down = -1;
                    end  
                end        
            else
                if n2 - n1 > 1
                    up = 1;
                    down = -1;
                else
                    if quad1 < 2
                        up = 1;
                        down = -1;
                    elseif quad1 < 4
                        down = -1;
                    end

                    if quad2 > 3
                        up = 1;
                        down = -1;
                    elseif quad2 > 1
                        up = 1;
                    end
                end
            end

            if up == 1 && down == 999
                sat_case = 3;
            elseif up == 999 && down == -1
                sat_case = 2;
            elseif up == 1 && down == -1
                sat_case = 1;
            else
                sat_case = 4;
            end
        end

        function [n, quad] = get_n_quad(obj, x)
            div_pi = x / pi;

            int_part = floor(div_pi);
            int_part_copy = double(int_part);

            n = -1;
            quad = 0;

            if mod(int_part_copy, 2) == 0
                n = int8(int_part_copy);

                if div_pi - int_part_copy < 1 / 2
                    quad = 1;
                elseif div_pi - int_part_copy == 1/2
                    quad = 1.5;
                else
                    quad = 2;
                end
            else
                int_part_copy = int_part_copy - 1;
                div_pi = div_pi - 1;

                n = int8(int_part_copy);

                if div_pi - int_part_copy < 1 / 2
                    quad = 3;
                elseif div_pi - int_part_copy == 1/2
                    quad = 3.5;
                else
                    quad = 4;
                end
            end

            if mod(x, pi) == 0 && mod(x, 2 * pi) == 0
                quad = 0.5;
            elseif mod(x, pi) == 0
                quad = 2.5;
            end

            n = n / 2;
        end
    end
end