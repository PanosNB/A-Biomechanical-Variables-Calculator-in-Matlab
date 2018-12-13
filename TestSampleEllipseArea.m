% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

clear ALL;
clc;

% On a line: expected zero
v = [ 
    [-1 -1] 
    [1 1]
    [1 1]
    [-1 -1]
    ];

cov(v)

ellipseArea(v, 1, 2)

% Create multiple points around (0,0) with stddev=(1,1)
mu = [0 0];
sigma = [1 0; 0 1];

R = mvnrnd(mu, sigma, 1000);
figure
plot(R(:,1),R(:,2),'+')

A=ellipseArea(R, 1, 2)
r=sqrt(A/pi)
viscircles([0 0], r);
line([0 0], [0 r], 'LineWidth', 2, 'Color', 'green')
line([0 r], [0 0], 'LineWidth', 2, 'Color', 'green')
annotation('textbox',[.2 .6 .3 .3],'String','1000 randommly generated points around (0,0) with sx=1, sy=1 and cov=0','FitBoxToText','on');

