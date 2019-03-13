clear, clc;

n = 6;
A0 = 10;

lambda = 3 * power(10, 8) / (1090 * power(10, 6));
d = 0.15;

theta = 0 : 0.5 : 360;
A = zeros(1, length(theta));

% ��ָ���ˮƽ����ͼ

subplot(1,2,1);

for i = 1 : length(theta) 
    phi = 2 * pi / lambda * d * cos(deg2rad(theta(i)));
    A(i) = abs( A0 * sin(n * phi / 2) / sin(phi / 2) );
end

x = A .* cos(deg2rad(theta));
y = A .* sin(deg2rad(theta));

plot( x , y , '-' , 'color' , 'b' , 'linewidth' , 3 );
axis equal;
hold on;

% ���ο���

x = max(A) .* cos(deg2rad(theta));
y = max(A) .* sin(deg2rad(theta));

plot( x , y , '--' , 'color' , 'm' );

hold on;

plot( [-max(A), max(A)] , [0 ,0] , '--' , 'color' , 'm' );

title('��̬ˮƽ������ͼ��ˮƽ����Ϊ��Ԫ���з���');

% ��Ȩ�ķ���ͼ

subplot(1,2,2);

theta_d = 110; % ָ��

beta = 2 * pi / lambda * d * cos( deg2rad( theta_d ) );

for i = 1 : length(theta)
    phi = 2 * pi / lambda * d * cos(deg2rad(theta(i)));
    phi_new = phi - beta;
    A(i) = abs( A0 * sin(n * phi_new / 2) / sin(phi_new / 2) ); 
end

x = A .* cos(deg2rad(theta));
y = A .* sin(deg2rad(theta));

plot( x , y , '-' , 'color' , 'b' , 'linewidth' , 3 );
axis equal;
hold on;

% ���ο���

x = max(A) .* cos(deg2rad(theta));
y = max(A) .* sin(deg2rad(theta));

plot( x , y , '--' , 'color' , 'm' );

hold on;

plot( [-max(A), max(A)] , [0 ,0] , '--' , 'color' , 'm' );

title(['��ָ���ˮƽ������ͼ��ָ��Ϊ ',num2str(theta_d),' �ȣ�']);