function vec_out = vec2frd(vec_in)
% Assumption is the XYZ is defined as in matlab picture of phone
% Z going from screen, Y going away from the home button, X going to right
% of screen
%
% The return is a FRD system (NED like)
% X is going away from home button, Y is on the right, Z is going into
% screen.
vec_out = [vec_in(:, 2), vec_in(:, 1), -vec_in(:, 3)];
end