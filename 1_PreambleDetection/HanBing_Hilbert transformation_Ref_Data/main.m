clear, clc, clf;
close all;

load( 'matlab6CH40_3M.mat' );
dataCh1 = data1 + 2048;

% ����ԭʼ�ź�����
figure( 'name' , 'ԭʼ�ź�����' );
% subplot( 1 , 2 , 1 );
plot( dataCh1 , 'color' , 'b' , 'linewidth' , 1 );
% hold on;
% axis( [ 500 1000 -160 160 ] );
% subplot( 1 , 2 , 2 );
% plot( abs( dataCh1 ) , 'color' , 'm' , 'linewidth' , 1 );
% legend( 'ԭʼ�ź�' , 'ԭʼ�ź�ȡģ' );
axis( [ 0 2701 -200 200 ] );
%

% �����������е���ɢ����Ҷ�任������ѡ���������еĳ���
N = length( dataCh1 );

X = zeros( 1 , N );

for k = 1 : N 
    X(k) = dft( dataCh1 , k );
end

x_bot = linspace( -40/3 , 40/3 , N );
figure( 'name' , '�������е�DFT' );
subplot( 1 , 2 , 1 );
plot( x_bot , abs( X ) , 'linewidth' , 1 , 'color' , 'b' );
title( 'Ƶ�׷�ֵ' );
subplot( 1 , 2 , 2 );
plot( x_bot , angle( X ) , 'linewidth' , 1 , 'color' , 'b' );
title( 'Ƶ����λ' );
%

% ����弤��Ӧ���е���ɢ����Ҷ�任������ѡ���������еĳ���
Y = [ 1i * ones( 1 , ( 2701 - 1 ) / 2 ) , -1i , - 1i * ones( 1 , ( 2701 - 1 ) / 2 ) ];
% y = 1 / pi * 1 ./ ( 1 : N );
% Y = zeros( 1 , N );
% 
% for k = 1 : N
%     Y(k) = dft( y , k );
% end
% 
figure( 'name' , '�弤��Ӧ���е�DFT' );
subplot( 1 , 2 , 1 );
plot( -1350 : 1 : 1350 , abs( Y ) , 'color' , 'b' , 'linewidth' , 3 );
xlabel( '\omega' , 'fontsize' , 20 );
title( 'Ƶ�׷�ֵ' );
subplot( 1 , 2 , 2 );
plot( -1350 : 1 : 1350 , angle( Y ) , 'color' , 'b' , 'linewidth' , 3 );
xlabel( '\omega' , 'fontsize' , 20 );
title( 'Ƶ����λ' );
%

% Ƶ�����
H = X .* Y;
% figure( 'name' , 'Hilbert �任���Ƶ����ԭʼ�ź�Ƶ�ױȽ�' );
% subplot( 2 , 2 , 1 );
% plot( abs( H ) );
% title( 'AftƵ�׷���' );
% subplot( 2 , 2 , 2 );
% plot( angle( H( 1290 : 1412 ) ) , '-o' );
% title( 'AftƵ����λ' );
% subplot( 2 , 2 , 3 );
% plot( abs( X ) );
% title( 'OriƵ�׷���' );
% subplot( 2 , 2 , 4 );
% plot( angle( X( 1290 : 1412 ) ) , '-o' );
% title( 'OriƵ����λ' );

figure( 'name' , '���� Hilbert �任���Ƶ��' );
subplot( 1 , 2 , 1 );
plot( -1350 : 1 : 1350 , abs( H ) , 'color' , 'b' , 'linewidth' , 1 );
title( 'Ƶ�׷�ֵ' );
subplot( 1 , 2 , 2 );
plot( -1350 : 1 : 1350 , angle( H ) , '-o' , 'color' , 'b' , 'linewidth' , 1 );
title( 'Ƶ����λ' );
%

% �����任ǰ�����λ��
figure( 'name' , 'ǰ����λ��' );
% % subplot( 3 , 1 , 1 );
% plot( angle( X( 1320 : 1382 ) ) , '-o' , 'color' , 'r' , 'linewidth' , 1 );
% % subplot( 3 , 1 , 2 );
% hold on;
% plot( angle( H( 1320 : 1382 ) ) , '-o' , 'color' , 'g' , 'linewidth' , 1 );
% % subplot( 3 , 1 , 3 );
% hold on;
% plot( angle( H( 1320 : 1382 ) ) - angle( X( 1320 : 1382 ) ) , '-o' , 'color' , 'b' , 'linewidth' , 1 );
% legend( 'ԭʼ�ź���λ' , '�任����λ' , '��λ��' );

plot( -1350 : 1 : 1350 , angle( H ) - angle( X ) , '.' , 'markersize' , 5 , 'color' , 'b' );

%

% ʹ�� IDFT ����������У��õ�ԭʼ�źŵ� Hilbert �任���������źŵ��鲿
h = zeros( 1 , N );

for n = 1 : N
    h(n) = idft( H , n );
end

% ���������źţ��� Hilbert �任���������Ϊ�鲿
signal_analytic = dataCh1 + 1i * h;

% Z = zeros( 1 , N );
% for n = 1 : N
%     Z(n) = dft( signal_analytic , n );
% end
% 
% figure( 'name' , '�����ź�Ƶ��' );
% subplot( 1 , 2 , 1 );
% plot( -1350 : 1 : 1350 , abs( Z ) , '-o' , 'color' , 'b' );
% title( '�����ź�Ƶ�׷�ֵ' );
% subplot( 1 , 2 , 2 );
% plot( -1350 : 1 : 1350 , abs( X ) , '-o' , 'color' , 'b' );
% title( 'ԭʼ�ź�Ƶ�׷�ֵ' );

figure( 'name' , 'Hilbert �任�������' );
plot( dataCh1 , 'r' , 'linewidth' , 3 );
hold on;
plot( abs( signal_analytic ) , 'g' , 'linewidth' , 3 );
hold on;
plot( abs( dataCh1 ) , 'b' , 'linewidth' , 3 );
% hold on;
% plot( abs( hilbert( dataCh1 ) ) , 'b' , 'linewidth' , 2 );
legend( 'ԭʼ�ź�' , '�����źŵ�ģ' , 'ԭʼ�źŵ�ģ' );
% plot( abs( hilbert( dataCh1 ) ) , 'b' );
%


