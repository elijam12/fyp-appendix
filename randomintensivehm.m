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
    exprv(k) = log(1-rand)/(-m);
    if sum(exprv)> 10
        break
    end 
end


numberofadditions = length(exprv);
exprv(end) = 10 - sum(exprv(1:(end-1))); 


for k = 1:length(exprv)
    if time + exprv(k) < 10
        [t, x] = ode45(@(t,x) tktd(t,x,c,e), [time time+exprv(k)]', x0);
    x0 = [x(length(t),1) + totalpyridineadded/numberofadditions, x(length(t),2)]; %addition of 1 unit of pyridine into external system
    A(start:start+length(t)-1,:) = [t,x]; %storing the results from each time interval consecutively in A
    start = start + length(t); 
    time = time + exprv(k); %time until next event (addition of pyridine)
    else
        [t, x] = ode45(@(t,x) tktd(t,x,c,e), [time 10]', x0); %integrate to end of time interval
        A(start:start+length(t)-1,:) = [t,x]; %storing the results from each time interval consecutively in A
    end
    
end
rintensiveint(iterations+1-j, i) = (length(tspan)-1)*(findlength(A(:,3), criticalpyridine))/length(A);
end
rintensiveext72LC10(i) = (length(tspan)-1)*(findlength(A(:,2), 0.066))/length(A); %time above LC10 value
rintensiveext72LC20(i) = (length(tspan)-1)*(findlength(A(:,2), 0.26))/length(A); %time above LC20 value
rintensiveext72LC50(i) = (length(tspan)-1)*(findlength(A(:,2), 2.75))/length(A); %time above LC50 value
end

%average over the # of iterations
average = average + rintensiveint./averageiter;
LC50 = LC50 + sum(rintensiveext72LC50 > 72)/averageiter; 
end

%Plot heat map and adjust colour scale for comparison

rintensivemap = heatmap(rintensiveint, 'Xdata', num2cell(1/iterations:1/iterations:1), 'Ydata', num2cell(1:-1/iterations:1/iterations), 'CellLabelColor','none'); %plot heat map
ylabel('Excretion rate'); xlabel('Consumption rate');
rintensivemap.Colormap = turbo;
%intensivemap.ColorLimits = [0 max(max(intensiveint))];

%Display axis in 0.1 steps, for clarity

idx = rem(1/iterations:1/iterations:1, 0.1) == 0;
rintensivemap.XDisplayLabels(~idx) = num2cell({''}); % replace rejected tick labels with empties
idy = rem(1:-1/iterations:1/iterations, 0.1) == 0;
rintensivemap.YDisplayLabels(~idy) = num2cell({''}); % replace rejected tick labels with empties
