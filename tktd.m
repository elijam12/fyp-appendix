%TKTD model with pyridine added as a seperate function

function f = tktd(t,x, c, e)

delta = (-1/8)*log(0.1); %rate of pyridine decay

%Alternative source functions:

%dxdt(1) = S -(delta + c)*x(1);  %S(t) = S
%dxdt(1) = 0;                    % S(t) = (delta + c)*x(1)
%dxdt(1) = -(delta + c)*x(1);    % S(t) = 0

dxdt(1) = -(delta + c)*x(1); %x(1) is the external conc of pyridine
dxdt(2) = c*x(1)-e*x(2); %x(2) is the internal conc of pyridine (in a crab)

f = [dxdt'];
