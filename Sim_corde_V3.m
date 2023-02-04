
T = 2;
m = 0.2;
L = 10;

P = T/(m*L);
c = 2;
N = 15;

syms s

Y = zeros(1,N);
y_0 = zeros(1,N);
y_0_p = zeros(1,N);
F = zeros(1,N);
%F(3) = 0.1;
%s = tf('s');
%F = [0 0 0 1/(s^2 + 1) 0 ];

for z = 1:40
    F(3) = sin(z);
    %fprintf('The vector Y is: [');
    %fprintf('%g ', Y);
    %fprintf(']\n');
    fprintf('The vector Y is: [');
    fprintf('%g ', max(Y));
    fprintf(']\n');
    if z > 2
    F(3) = 0;
    end
    %if mod(z,5) == 0 
    %F(3) = -1;    
    %else
    %F(3) = 1;
    %end
    %Y = (((y_0.*(2.*P + c)) + (P.*(s.*[Y(2:N) 0] - [y_0(2:N) 0])) + (P.*(s.*[0 Y(1:N-1)] - [0 y_0(1:N-1)])) + (F/s))./(s^2 + s.*(2.*P + c)));
    Y = ((P*([0 Y(1:N-1)] + [Y(2:N) 0]) + y_0*((1/m)+s) + y_0_p + (F/(m*s)))/(s^2 + (c/m)*s + 2*P));
    Y = ilaplace(Y);
    Y = subs(Y,1);
    Y = double(Y);
    Y(1) = 0;
    Y(N) = 0;
    y_0 = Y;
    y_0_p = y_0 - y_0_p;
    %y_0_p(1) = 0;
    %y_0_p(N) = 0;
   
    %y_0(1) = 0;
    %y_0(N) = 0;
    plot(Y);
    drawnow;
 
end






