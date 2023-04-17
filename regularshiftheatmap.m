 %clear, clc, clf, clear global

iterations = 50; %square root of # of iterations

%preallocating arrays
shiftint = zeros(iterations); shiftext72LC10 = zeros(1,iterations); shiftext72LC20 = zeros(1,iterations);
shiftext72LC50 = zeros(1,iterations);
totalpyridineadded = 30;
criticalpyridine = 2.75; %critical concentration of pyridine
tspan = [0:1/24:10]'; %hourly evaluations over 10 days


%creating a logical array that adds pyridine in 10 hour shifts, 6 days a week

shifts = zeros(1, length(tspan));
 
 for h = 1:6
     for hh = 1:10
     shifts(24*(h-1) + hh) = 1;
     end
 end

  for h = 8:10
     for hh = 1:10
     shifts(24*(h-1) + hh) = 1;
     end
  end


for i = 1:iterations
    
    c = i/iterations; %increase c, consumption rate, from 0 to 1 in [iteration] steps
    
for j = 1:iterations
    
    e = j/iterations; %increase e, excretion rate, from 0 to 1 in [iteration] steps
    
A = zeros(length(tspan), 3); %preallocating arrays
time = 0; x0 = [0, 0]; start = 1; %initial conditions

    while time < max(tspan)-1/24
        
    timetopyridine = 1/24; %time until first addition of pyridine

    [t, x] = ode45(@(t,x) tktd(t,x,c,e), [time:1/24:time+timetopyridine]', x0);

    x0 = [x(length(t),1)+ shifts(floor(24*t(1))+1)*totalpyridineadded/90, x(length(t),2)]; %addition of 1 unit of pyridine into external system

    A(start:start+length(t)-1,:) = [t,x]; %storing the results from each time interval consecutively in A
    start = start + length(t); %recording the length of each time interval
    time = time + timetopyridine; %time until next event (addition of pyridine)

    end
    
%calculates the length of the longest consecutive period spent above the critical level of pyridine in hours
shiftint(iterations+1-j, i) = (length(tspan)-1)*(findlength(A(:,3), criticalpyridine))/length(A);

end

%LC10, 20 and 50 values

shiftext72LC10(i) = (length(tspan)-1)*(findlength(A(:,2), 0.066))/length(A);
shiftext72LC20(i) = (length(tspan)-1)*(findlength(A(:,2), 0.26))/length(A);
shiftext72LC50(i) = (length(tspan)-1)*(findlength(A(:,2), 2.75))/length(A);
end

%plot heat map and adjust colour scale for comparison

shiftmap = heatmap(shiftint, 'Xdata', num2cell(1/iterations:1/iterations:1), 'Ydata', num2cell(1:-1/iterations:1/iterations), 'CellLabelColor','none'); %plot heat map
ylabel('Excretion rate'); xlabel('Consumption rate');
shiftmap.Colormap = turbo;
shiftmap.ColorLimits = [0 max(max(intensiveint))];

%Display axis in 0.1 steps, for clarity

idx = rem(1/iterations:1/iterations:1, 0.1) == 0;
shiftmap.XDisplayLabels(~idx) = num2cell({''}); % replace rejected tick labels with empties
idy = rem(1:-1/iterations:1/iterations, 0.1) == 0;
shiftmap.YDisplayLabels(~idy) = num2cell({''}); % replace rejected tick labels with empties