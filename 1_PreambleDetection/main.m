% clc;
clear,clc,clf;

% 读入数据
fid = fopen( 'ORIGIN-DATA_RATE-4M_SIZE-1.92GB_FLOAT.txt', 'r' );
[data, count] = fread( fid , 8*10^6 , 'float' );

% 选取有 ADS-B 信号的一段
% frame_inclu = data;
frame_inclu = data( 3 * 10^6 : 5 * 10^6 );

% 将低于阈值的信号设为 0
% for i = 1 : length(frame_inclu)
%     if ( frame_inclu(i) < 0.6 )
%         frame_inclu(i) = 0;
%     end
% end

% 采样频率为 4M
delta_t = 0.25; %us

% 将横轴扩展为真实时间
x_bot = 0 : delta_t : delta_t * ( length( frame_inclu ) - 1 );

% 作图
subplot( 2 , 1 , 1 );

% for i = 1 : length(frame_inclu)
%    plot( [x_bot(i) x_bot(i)] , [0 frame_inclu(i)] , 'color' , 'm' );
%    hold on; 
% end
% 
% hold on; 
% 
% plot( x_bot , frame_inclu , '.' , 'markersize' , 8 , 'color' , 'b' );

plot( frame_inclu );

% xlabel('Time[\mus]', 'fontsize' , 20);
% ylabel('Amplitude' , 'fontsize' , 20);

% 报头模板（对应采样率为 4M，报头模板需要根据采样率决定）
% preamble_template = [ 1 1 0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 ];

% 模板与信号互相关，检测报头
tic;
r = preamble_detection( 4*10^6 , frame_inclu );
toc;

subplot( 2 , 1 , 2 );

plot( r , '.' , 'markersize' , 12 );
hold on;
plot( [0 length(frame_inclu)] , [4 4] , 'color' , 'm' , 'linewidth' , 2 );
