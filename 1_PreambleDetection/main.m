% clc;
clear,clc,clf;

% ��������
fid = fopen( 'ORIGIN-DATA_RATE-4M_SIZE-1.92GB_FLOAT.txt', 'r' );
[data, count] = fread( fid , 8*10^6 , 'float' );

% ѡȡ�� ADS-B �źŵ�һ��
% frame_inclu = data;
frame_inclu = data( 3 * 10^6 : 5 * 10^6 );

% ��������ֵ���ź���Ϊ 0
% for i = 1 : length(frame_inclu)
%     if ( frame_inclu(i) < 0.6 )
%         frame_inclu(i) = 0;
%     end
% end

% ����Ƶ��Ϊ 4M
delta_t = 0.25; %us

% ��������չΪ��ʵʱ��
x_bot = 0 : delta_t : delta_t * ( length( frame_inclu ) - 1 );

% ��ͼ
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

% ��ͷģ�壨��Ӧ������Ϊ 4M����ͷģ����Ҫ���ݲ����ʾ�����
% preamble_template = [ 1 1 0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 ];

% ģ�����źŻ���أ���ⱨͷ
tic;
r = preamble_detection( 4*10^6 , frame_inclu );
toc;

subplot( 2 , 1 , 2 );

plot( r , '.' , 'markersize' , 12 );
hold on;
plot( [0 length(frame_inclu)] , [4 4] , 'color' , 'm' , 'linewidth' , 2 );
