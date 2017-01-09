function test3
	clc;
	global g
	g = pi; % Assign a value.
	% Call f1
	fprintf('Prior to calling f1, g = %f\n', g);
	f1
	fprintf('After calling f1, g = %f\n', g);
	
function f1
	global g;
	fprintf('In f1, g = %f\n', g);
	g = 42.5;
	fprintf('In f1, g = %f\n', g);