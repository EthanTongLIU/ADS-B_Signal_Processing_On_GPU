clear,clc;
close all;

% dataCH6 = readFile( 'TEST6ch22M.dat' );
% 
% dataLen = 80000; % �������ݵĳ��� 26214400
% 
% % �������һ��ͨ��������
% data1 = dataCH6( 1 , 1.594*10^6 : 1.594*10^6 + dataLen ) + 2048;
% 
% % �Ե�1ͨ�������ݽ��� Hilbert �任
% % data1_analytic = hilbert_transform( data1 ); % �Աຯ��̫��
% data1_analytic = abs( hilbert( data1 ) );

load( 'data2_analytic.mat' );

data = data2_analytic( 1 : length( data2_analytic ) );
% data = data1_analytic( 50000 : 70000 );



plot( data , '-o' );
% �鿴����ͷ
% hold on;
% xn = data( 5271 : 5271 + 11 * 120 * 2 - 1 );
% bot = 5271 : 5271 + 11 * 120 * 2 - 1;
% plot( bot , xn , '-o' , 'color' , 'r' );

% ��ȡ��ͷ������ת��
adsb_possible = pre_detect( 9000 , data );
