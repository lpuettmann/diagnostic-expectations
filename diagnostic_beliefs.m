%% "Diagnostic Expectations and Credit Cycles" 
%% by Pedro Bordalo, Nicola Gennaioli, Andrei Shleifer (2015)


close all
clear all
clc


%% Set parameters
T = 150;
b = 0.7;
sigma = 1;
theta = 1;


%% Get draws of omega
omega = nan(T, 1);
omega(1) = 0; % omega_0

epsilon = 2*randn(T, 1);

for t=2:T
    omega(t) = b*(omega(t-1)) + epsilon(t);
end

%% Calculate expectations of omega
rat_exp = b * omega(1:end-1);
assert( length(rat_exp) + 1 == length(omega) ) % check dimensions

diagn_exp = b * omega(1:end-1) * (1 + theta * (1 - b));
assert( length(diagn_exp) + 1 == length(omega) ) % check dimensions

forecast_error = omega(2:end) - diagn_exp;

% Get a trend line for the plot
mdl = fitlm(omega(1:end-1), forecast_error);
xplot = linspace( min(omega(1:end-1)), max(omega(1:end-1)), T - 1);
yplot = mdl.Coefficients.Estimate(1) + mdl.Coefficients.Estimate(2) * ...
    xplot;

%% Make a plot
figure
subplot(2, 1, 1)
plot(rat_exp, 'blue', 'Linewidth', 1.5)
hold on
plot(diagn_exp, 'red', 'Linewidth', 1.5)
legend('Rational expectations', 'Diagnostic expectations')

subplot(2, 1, 2)
scatter(omega(1:end-1), forecast_error)
hold on

plot(xplot, yplot)
