clear,clc;
close all;

% >>> �������� <<<
% dataCH6 = readFile( 'D:\1_Work\Y_�о������⣨2018��12������\3_L�����źŴ���ϵͳ\0_Data\3_6ChannelData_22M\TEST6ch22M.dat' );
% data1 = dataCH6( 1 , : ) + 2048; % �����һ��ͨ��������

% plot(data1(1e7 + 3.1725e6 : 1e7 + 3.176e6));
% hold on;
% plot(abs(data1(1e7 + 3.1725e6 : 1e7 + 3.176e6)));

% plot(data1(0.5e7+8.704e5 : 0.5e7+8.735e5));
% hold on;
% stem(abs(data1(0.5e7+8.704e5 : 0.5e7+8.735e5)));

% % >>> �����ݽ��� Hilbert �任 <<<
% % data2_analytic = hilbert_transform( data2 ); % �Աຯ��̫��
% data1_analytic = abs( hilbert( data1 ) );
% 
% % >>> �����Ѿ���ɱ任�����ݣ�Ϊ��ʡʱ�䣩 <<<
% % load( 'D:\1_Work\Y_�о������⣨2018��12������\3_L�����źŴ���ϵͳ\0_Data\3_6ChannelData_22M\data2_analytic.mat' );

% % >>> ɸѡ��һ������ <<<
% % data = data2_analytic( 100 : 26e5 );
% % stem(data);
% % 
% % >>> �������� <<<
% plot( data , '-o' );
% % hold on;
% % xn = data( 5271 : 5271 + 11 * 120 * 2 - 1 );
% % bot = 5271 : 5271 + 11 * 120 * 2 - 1;
% % plot( bot , xn , '-o' , 'color' , 'r' );
% 
% % >>> ���б�ͷ��Ⲣ����ת�� <<<
% detect_threshold = 9000;
% adsb_possible = pre_detect( detect_threshold , data );
% 
% % >>> ���� <<<
% [ len_m , len_n ] = size( adsb_possible );
% for i = 1 : len_m
%     frame_on_hex = bin2hex( adsb_possible( i , : ) );
%     disp( frame_on_hex );
%     DF17Decoder( frame_on_hex );
% end
