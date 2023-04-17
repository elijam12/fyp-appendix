tspan = [0 200];
x0 = [1 1];

[t, x] = ode45(@TB, tspan, x0);

plot(t,x)
legend('Phytoplankton population', 'Zooplankton population')
xlabel('time')
ylabel('population')
title('Truscott-Brindley model of ocean plankton populations')