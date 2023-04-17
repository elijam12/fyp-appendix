global K r R_m alpha mu gamma beta nu omega

K = 108; %carrying capacity
r = 0.3; %maximum growth rate
R_m = 0.7; %maximum specific predation rate
alpha = 5.7; %governs how quickly R_m is attained as prey density increases
mu = 0.012; %rate of removal of zooplankton by death and predation
gamma = 0.05; %ratio of biomass consumed to biomass of new herbivores produced (efficiency of eating?)
beta = r/R_m;  %variables from non-dimensionalisation
nu = alpha/K;
omega = mu/(gamma*R_m);