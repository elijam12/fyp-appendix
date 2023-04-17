function f = TB(t,x)
global K r R_m alpha mu gamma beta nu omega

dxdt(1) = r*x(1)*(1-x(1)/K) - R_m*x(2)*x(1)^2/(alpha^2+x(1)^2);
dxdt(2) = gamma*R_m*x(2)*x(1)^2/(alpha^2+x(1)^2) - mu*x(2);

f = [dxdt'];
end