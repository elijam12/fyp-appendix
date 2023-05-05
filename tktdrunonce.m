clear, clc, clf, clear global

iterations = 50; %square root of # of iterations

z = zeros(iterations); %preallocating arrays
criticalpyridine = 1; %critical concentration of pyridine
tspan = [0:1/24:10]'; %hourly evaluations over 4 weeks
m = 1/2; %rate at which event occurs (1/7 = weekly)

c = 0.5; e = 0.5;

A = zeros(length(tspan), 3);%preallocating arrays
time = 0; x0 = [1, 0]; start = 1; %initial variables

while time < max(tspan)
    
    %%% For Figure 4a
    timetopyridine = log(1-rand)/(-m); %time until first addition of pyridine

    %%% For Figure 4a
    %timetopyridine = 2;  
    
    if timetopyridine < 1/24
        timetopyridine = 1/24; %this ensures the time interval (tspan) has at least 2 values
    end
    
    if time + timetopyridine < max(tspan)-1/24
        [t, x] = ode45(@(t,x) tktd(t,x,c,e), [time:1/24:time+timetopyridine]', x0);
    else
        time = max(tspan)-1/24;
        [t, x] = ode45(@(t,x) tktd(t,x,c,e), [time:1/24:max(tspan)]', x0); %this ensures it doesn't evaluate the system past 4 weeks
    end
    
    x0 = [x(length(t),1)+1, x(length(t),2)]; %addition of 1 unit of pyridine into (external) system
    
    A(start:start+length(t)-1,:) = [t,x]; %storing the results from each time interval consecutively in A
    start = start + length(t);
    hold on
    plot(t,x)
    legend('External', 'Internal')
    ax = gca; %same colours used each time
    ax.ColorOrderIndex = 1;
    if time+timetopyridine < max(tspan)
        xline(time+timetopyridine, '--', 'pyridine added') %vertical line when pyridine added
    end
    xlabel('Time (days)'); ylabel('Concentration (mg/L, mg/kg)');
    time = time + timetopyridine; %time until next event (addition of pyridine)
    
end
hold off