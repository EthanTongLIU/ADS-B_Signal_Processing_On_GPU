clear, clc, clf;
close all;

load( 'matlab6CH40_3M.mat' );
dataCh1 = data1 + 2048;

% �����������е���ɢ����Ҷ�任������ѡ���������еĳ���
N = length( dataCh1 );

X = zeros( 1 , N );

for k = 1 : N 
    X(k) = dft( dataCh1 , k );
end

figure( 'name' , '�������е�DFT' );
subplot( 1 , 2 , 1 );
plot( abs( X ) , '-o' );
title( 'ԭʼdft������' );
subplot( 1 , 2 , 2 );
plot( abs( fft( dataCh1 ) ) , '-o' );
title( 'Matlab�Դ�fft������' );

% ����弤��Ӧ���е���ɢ����Ҷ�任������ѡ���������еĳ���
Y = [ 1i * ones( 1 , ( 2701 - 1 ) / 2 ) , 0 , - 1i * ones( 1 , ( 2701 - 1 ) / 2 ) ];
% y = 1 / pi * 1 ./ ( 1 : N );
% Y = zeros( 1 , N );
% 
% for k = 1 : N
%     Y(k) = dft( y , k );
% end
% 
figure( 'name' , '�弤��Ӧ���е�DFT' );
subplot( 2 , 1 , 1 );
plot( abs( Y ) , '-o' );
title( '��ֵ' );
subplot( 2 , 1 , 2 );
plot( angle( Y ) , '-o' );
title( '��λ' );

% Ƶ�����
H = X .* Y;
figure( 'name' , 'Hilbert �任���Ƶ����ԭʼ�ź�Ƶ�ױȽ�' );
subplot( 2 , 2 , 1 );
plot( abs( H ) );
title( 'AftƵ�׷���' );
subplot( 2 , 2 , 2 );
plot( angle( H( 1290 : 1412 ) ) , '-o' );
title( 'AftƵ����λ' );
subplot( 2 , 2 , 3 );
plot( abs( X ) );
title( 'OriƵ�׷���' );
subplot( 2 , 2 , 4 );
plot( angle( X( 1290 : 1412 ) ) , '-o' );
title( 'OriƵ����λ' );

figure( 'name' , 'ǰ����λ��' );
plot( angle( H( 1290 : 1412 ) ) - angle( X( 1290 : 1412 ) ) , '-o' );

% ʹ�� IDFT ����������У��õ�ԭʼ�źŵ� Hilbert �任���������źŵ��鲿
h = zeros( 1 , N );

for n = 1 : N
    h(n) = idft( H , n );
end

signal_aft = dataCh1 + 1i * h;

figure( 'name' , 'Hilbert �任�������' );
plot( dataCh1 , 'g' );
hold on;
plot( real( h ) , 'm' );
hold on;
plot( abs( h ) , 'r' );
hold on;
plot( abs( signal_aft ) , 'k' );
legend( 'ԭʼ�ź�' , 'Hilbert�任��ʵ��' , 'Hilbert�任��ģ' , '�����ź�' );
% plot( abs( hilbert( dataCh1 ) ) , 'b' );



