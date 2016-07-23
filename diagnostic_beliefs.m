%% "Diagnostic Expectations and Credit Cycles" 
%% by Pedro Bordalo, Nicola Gennaioli, Andrei Shleifer (2015)


close all
clear all
clc


%% Set parameters
T = 150; % number of periods to simulate
b = 0.7; % autoregressive paramater
sigma = 1; % variance of shock
theta = 1; % "thinking" parameters


%% Get draws of omega
% See p.17 for the AR(1)-process: omega_t = 0.7 * omega_{t-1} + epsilon_t

omega = nan(T, 1);
omega(1) = 0; % omega_0

rng(123) % set random seed

epsilon = sigma*randn(T, 1); % draw a shock series

for t=2:T
    omega(t) = b*(omega(t-1)) + epsilon(t);
end


%% Calculate expectations of omega

% Rational expectations
rat_exp = b * omega(1:end-1);

% Diagnostic expectations. (See equation (4) in the paper on p. 14)
diagn_exp = b * omega(1:end-1) * (1 + theta * (1 - b));

% Check dimensions
assert( length(rat_exp) + 1 == length(omega) ) 
assert( length(diagn_exp) + 1 == length(omega) )


%% Need these for the plot
forecast_error = omega(2:end) - diagn_exp;

dexp = diagn_exp - rat_exp;

dpos = zeros(T-1, 1);
dpos(dexp > 0) = dexp(dexp > 0);

dneg = zeros(T-1, 1);
dneg(dexp < 0) = dexp(dexp < 0);


%% Reproduce Figure 2 from the paper

% First figure (first panel in Figure 2)
f = figure;
plot(rat_exp, 'Linewidth', 2, 'Color', [0.9059, 0.1608, 0.5412])
hold on
plot(diagn_exp, 'Linewidth', 2, 'Color', [0.4588, 0.4392, 0.7020])
xlabel('Time')
legend('Rational expectations', 'Diagnostic expectations', 'Location', ...
    'South')
legend boxoff   
set(gca, 'XTick', []);
set(gca, 'YTick', []);
title('Rational vs. diagnostic expectations')
box off

% Reposition the figure
set(gcf, 'Position', [100 200 600 300]) % in vector: left bottom width height
set(f, 'Units', 'Inches');
pos = get(f, 'Position');
set(f, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

print(f, 'diagn_beliefs_fig2_1.pdf', '-dpdf', '-r0') % save as pdf
saveas(f, 'diagn_beliefs_fig2_1.jpg') % save figure as jpg

% Second figure (not in paper)
f = figure;
a = area([dpos, zeros(T-1, 1)]);
h = get(a, 'children');
set(h{1}, 'FaceColor', [0.1059, 0.6196, 0.4667]);
xlabel('Time')
hold on
a = area([dneg, zeros(T-1, 1)]);
h = get(a, 'children');
set(h{1}, 'FaceColor', [0.8510, 0.3725, 0.0078]);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
title('Difference')
box off

% Reposition the figure
set(gcf, 'Position', [100 200 600 300]) % in vector: left bottom width height
set(f, 'Units', 'Inches');
pos = get(f, 'Position');
set(f, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

print(f, 'diagn_beliefs_fig2_2.pdf', '-dpdf', '-r0') % save as pdf
saveas(f, 'diagn_beliefs_fig2_2.jpg') % save figure as jpg

% Third figure (second panel in Figure 2)
f = figure;
scatter(omega(1:end-1), forecast_error, 'MarkerEdgeColor', [0.2, 0.2, 0.2])
lsline % trend line
title('In bad times: positive forecast errors')
xlabel('$\omega_t$', 'Interpreter', 'LaTex')
ylabel('$\omega_{t+1} - E_t^\theta [\omega_{t+1}]$', 'Interpreter', 'LaTex')
set(gca, 'XTick', []);
set(gca, 'YTick', []);
box off

set(gca,'FontSize', 14) % change default font size of axis labels

% Reposition the figure
set(gcf, 'Position', [100 200 600 300]) % in vector: left bottom width height
set(f, 'Units', 'Inches');
pos = get(f, 'Position');
set(f, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

print(f, 'diagn_beliefs_fig2_3.pdf', '-dpdf', '-r0') % save as pdf
saveas(f, 'diagn_beliefs_fig2_3.jpg') % save figure as jpg
