%% Dhaval Kadia: 101622808

%   Include library: startup_rvc.m from https://github.com/petercorke/robotics-toolbox-matlab/blob/master/Bug2.m
disp('Robotics, Vision & Control: (c) Peter Corke 1992-2011 http://www.petercorke.com')

if verLessThan('matlab', '7.0')
    warning('You are running a very old (and unsupported) version of MATLAB.  You will very likely encounter significant problems using the toolboxes but you are on your own with this');
end
tb = false;
rvcpath = fileparts( mfilename('fullpath') );

robotpath = fullfile(rvcpath, 'robot');
if exist(robotpath,'dir')
    addpath(robotpath);
    tb = true;
    startup_rtb
end

visionpath = fullfile(rvcpath, 'vision');
if exist(visionpath,'dir')
    addpath(visionpath);
    tb = true;
    startup_mvtb
end

if tb
    addpath(fullfile(rvcpath, 'common'));
    addpath(fullfile(rvcpath, 'simulink'));
end

clear tb rvcpath robotpath visionpath

%%

%   2D space 
map = zeros(130, 130);

%   Define the obstacles 
for i = 30:40
    for j = 20:110
        map(i, j) = 1;
    end
end

for i = 65:75
    for j = 50:90
        map(i, j) = 1;
    end
end

for i = 65:110
    for j = 80:90
        map(i, j) = 1;
    end
end

%   Use the Bug2 function
bug = Bug2(map);      

xlabel('x') 
ylabel('y') 

bug.goal = [60 100];    %   Starting co-ordinates
bug.path([40 20]);      %   Destination co-ordinates

%   Markers
hold on
plot(40, 20,'o', 'MarkerSize',10, 'MarkerEdgeColor','black', 'MarkerFaceColor',[0 0 0])
plot(60, 100,'p', 'MarkerSize',10, 'MarkerEdgeColor','black', 'MarkerFaceColor',[0 0 0])