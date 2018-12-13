% Copyright 2018 the project authors as listed in the AUTHORS file.
% All rights reserved. Use of this source code is governed by the
% license that can be found in the LICENSE file.

clear ALL;
clc;

v = [1 2 3 4 1 2 3 4 5];
[e,se,A,B] = sampen(v, 5, .2 ,1 ,0);
e
