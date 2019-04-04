clear,clc;
close all;

% dataCH6 = readFile( 'TEST6ch22M.dat' );
% 
% dataLen = 80000; % 读入数据的长度 26214400
% 
% % 分离出第一个通道的数据
% data1 = dataCH6( 1 , 1.594*10^6 : 1.594*10^6 + dataLen ) + 2048;
% 
% % 对第1通道的数据进行 Hilbert 变换
% % data1_analytic = hilbert_transform( data1 ); % 自编函数太慢
% data1_analytic = abs( hilbert( data1 ) );

load( 'data2_analytic.mat' );

data = data2_analytic( 1 : length( data2_analytic ) );
% data = data1_analytic( 50000 : 70000 );



plot( data , '-o' );
% 查看错误报头
% hold on;
% xn = data( 5271 : 5271 + 11 * 120 * 2 - 1 );
% bot = 5271 : 5271 + 11 * 120 * 2 - 1;
% plot( bot , xn , '-o' , 'color' , 'r' );

% 提取报头并进行转码
adsb_possible = pre_detect( 9000 , data );
