clear,clc;
close all;

% >>> 读入数据 <<<
% dataCH6 = readFile( 'D:\1_Work\Y_研究生课题（2018年12月至今）\3_L波段信号处理系统\0_Data\3_6ChannelData_22M\TEST6ch22M.dat' );
% data1 = dataCH6( 1 , : ) + 2048; % 分离出一个通道的数据

% plot(data1(1e7 + 3.1725e6 : 1e7 + 3.176e6));
% hold on;
% plot(abs(data1(1e7 + 3.1725e6 : 1e7 + 3.176e6)));

% plot(data1(0.5e7+8.704e5 : 0.5e7+8.735e5));
% hold on;
% stem(abs(data1(0.5e7+8.704e5 : 0.5e7+8.735e5)));

% % >>> 对数据进行 Hilbert 变换 <<<
% % data2_analytic = hilbert_transform( data2 ); % 自编函数太慢
% data1_analytic = abs( hilbert( data1 ) );
% 
% % >>> 加载已经完成变换的数据（为节省时间） <<<
% % load( 'D:\1_Work\Y_研究生课题（2018年12月至今）\3_L波段信号处理系统\0_Data\3_6ChannelData_22M\data2_analytic.mat' );

% % >>> 筛选出一段数据 <<<
% % data = data2_analytic( 100 : 26e5 );
% % stem(data);
% % 
% % >>> 绘制数据 <<<
% plot( data , '-o' );
% % hold on;
% % xn = data( 5271 : 5271 + 11 * 120 * 2 - 1 );
% % bot = 5271 : 5271 + 11 * 120 * 2 - 1;
% % plot( bot , xn , '-o' , 'color' , 'r' );
% 
% % >>> 进行报头检测并进行转码 <<<
% detect_threshold = 9000;
% adsb_possible = pre_detect( detect_threshold , data );
% 
% % >>> 解码 <<<
% [ len_m , len_n ] = size( adsb_possible );
% for i = 1 : len_m
%     frame_on_hex = bin2hex( adsb_possible( i , : ) );
%     disp( frame_on_hex );
%     DF17Decoder( frame_on_hex );
% end
