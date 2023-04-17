clear, clc, clf
m = 24; iterations = 50; tspan = [0:1/24:10]'; criticalpyridine = 2.75; totalpyridineadded = 30; LC50 = 0;
average = zeros(iterations);
averageiter = 20;

for n = 1:averageiter

for i = 1:iterations
    
    c = i/iterations; %vary c, consumption rate, from 0 to 1 in [iteration] steps
    
for j = 1:iterations
    
    e = j/iterations; %vary e, excretion rate, from 0 to 1 in [iteration] steps
    
A = zeros(length(tspan), 3); %preallocating arrays
time = 0; x0 = [0, 0]; start = 1; %initial conditions


%calculate time between additions
for k = 1:10000000
    exprv(k) = mod(log(1-rand)/(-m), 10/24);
    if sum(exprv)>90/24
        break
    end 
end

numberofadditions = length(exprv);
exprv(end) = 90/24 - sum(exprv(1:(end-1)));

for days = 1:6
for k = 1:length(exprv)
    if time + exprv(k) < (days-1) + 10/24
        [t, x] = ode45(@(t,x) tktd(t,x,c,e), [time time+exprv(k)]', x0);
    x0 = [x(length(t),1) + totalpyridineadded/numberofadditions, x(length(t),2)]; %addition of pyridine
    A(start:start+length(t)-1,:) = [t,x]; %storing the results from each time interval consecutively in A
    start = start + length(t); 
    time = time + exprv(k); %time until next event (addition of pyridine)
    
    else
       % exprv(k) = 10 - sum(exprv(1:k-1));
        exprv = exprv(k:end);
        break
    end

end

[t, x] = ode45(@(t,x) tktd(t,x,c,e), [time days]', x0);

    A(start:start+length(t)-1,:) = [t,x]; %storing the results from each time interval consecutively in A
    start = start + length(t); 
    time = days; %time until next event (addition of pyridine)
    x0 = [x(length(t),1), x(length(t),2)]; 
end

[t, x] = ode45(@(t,x) tktd(t,x,c,e), [6 7]', x0);

    A(start:start+length(t)-1,:) = [t,x]; %storing the results from each time interval consecutively in A
    start = start + length(t);
    time = 7; %time until next event (addition of pyridine)
    x0 = [x(length(t),1), x(length(t),2)]; 
    
for days = 7:9
for k = 1:length(exprv)
    if time + exprv(k) < (days) + 10/24
        [t, x] = ode45(@(t,x) tktd(t,x,c,e), [time time+exprv(k)]', x0);
    x0 = [x(length(t),1) + totalpyridineadded/numberofadditions, x(length(t),2)]; %addition of 1 unit of pyridine into external system
    A(start:start+length(t)-1,:) = [t,x]; %storing the results from each time interval consecutively in A
    start = start + length(t); 
    time = time + exprv(k); %time until next event (addition of pyridine)
    else
        exprv = exprv(k:end);
        break
    end

end

[t, x] = ode45(@(t,x) tktd(t,x,c,e), [time days+1]', x0);

    A(start:start+length(t)-1,:) = [t,x]; %storing the results from each time interval consecutively in A
    start = start + length(t); 
    time = days+1; %time until next event (addition of pyridine)
    x0 = [x(length(t),1), x(length(t),2)]; 
end
rshiftint(iterations+1-j, i) = (length(tspan)-1)*(findlength(A(:,3), criticalpyridine))/length(A);
end

%LC10, 20 and 50 values
rshiftext72LC10(i) = (length(tspan)-1)*(findlength(A(:,2), 0.066))/length(A);
rshiftext72LC20(i) = (length(tspan)-1)*(findlength(A(:,2), 0.26))/length(A);
rshiftext72LC50(i) = (length(tspan)-1)*(findlength(A(:,2), 2.75))/length(A);
end

%average over the number of iterations
average = average + rshiftint./averageiter;
LC50 = LC50 + sum(rshiftext72LC50 > 72)/averageiter;
end

%Plot heat map and adjust colour scale for comparison

rshiftmap = heatmap(rshiftint, 'Xdata', num2cell(1/iterations:1/iterations:1), 'Ydata', num2cell(1:-1/iterations:1/iterations), 'CellLabelColor','none'); %plot heat map
ylabel('Excretion rate'); xlabel('Consumption rate');
rshiftmap.Colormap = turbo;
intensivemap.ColorLimits = [0 191.5566];

%Display axis in 0.1 steps, for clarity
idx = rem(1/iterations:1/iterations:1, 0.1) == 0;
rshiftmap.XDisplayLabels(~idx) = num2cell({''}); % replace rejected tick labels with empties
idy = rem(1:-1/iterations:1/iterations, 0.1) == 0;
rshiftmap.YDisplayLabels(~idy) = num2cell({''}); % replace rejected tick labels with empties

% lines = [(0:5)*24 ((0:5)*24+10) (7:10)*24 (7:9)*24+10];
% plot(A(:,1), A(:,2), A(:,1), A(:,3)); xline(lines);