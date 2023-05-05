clear, clc, clf
global delta

c = 0.5; e = 0.5; initialpyridine = 1;  % consumption and excretion rate

tspan = [0:1/24:10]'; x0 = [initialpyridine, 0]; % initial conditions

[t, x] = ode45(@(t,x) tktd(t,x,c,e), tspan, x0);

plot(t,x); %title("c = " + c + " and e = " + e + ", the initial external pyridine concentration is " + initialpyridine);

yline(1/(c+delta)); %fixed point
legend("External", "Internal")