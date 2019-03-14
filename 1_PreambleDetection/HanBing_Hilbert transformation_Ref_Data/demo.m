clear, clc, clf;
close all;

% �����źţ������ź������Ա任
load( 'matlab6CH40_3M.mat' );
dataCh1 = abs( data1 + 2048 );
dataCh2 = abs( data2 + 2048 );
dataCh3 = abs( data3 + 2048 );
dataCh4 = abs( data4 + 2048 );
dataCh5 = abs( data5 + 2048 );
dataCh6 = abs( data6 + 2048 );

% ���� 6 ��ͨ�����ź�
figure( 'name' , '6��ͨ�����ź�' );
subplot( 3 , 2 , 1 );
plot( dataCh1 );
subplot( 3 , 2 , 2 );
plot( dataCh2 );
subplot( 3 , 2 , 3 );
plot( dataCh3 );
subplot( 3 , 2 , 4 );
plot( dataCh4 );
subplot( 3 , 2 , 5 );
plot( dataCh5 );
subplot( 3 , 2 , 6 );
plot( dataCh6 );

% �� 1 ͨ�����ź��õ����߱�ʾ����
% figure( 'name' , '1ͨ���źŵ�����' );
% for i = 1 : length( data1 )
%     plot( [ i , i ] , [ 0 dataCh1(i) ] , 'color' , 'm' );
%     hold on;
% end
% plot( dataCh1 , '.' , 'markersize' , 8 , 'color' , 'b' );

% ����ͨ�� 1 ���ź�
figure( 'name' , '1ͨ���źŵ�Ƶ��' );
subplot( 2 , 1 , 1 );
plot( abs( fft( dataCh1 , 4096 ) ) );
subplot( 2 , 1 , 2 );
plot( angle( fft( dataCh1 , 4096 ) ) );

% �� 1 ͨ�����ź��� Hilbert �任��Ϊ���ź�
dataCh1_complex = hilbert( data1 + 2048 );
mod_dataCh1_complex = abs( dataCh1_complex );
% figure( 'name' , '1ͨ���źž��� Hilbert �任' );
% for i = 1 : length( mod_dataCh1_complex )
%     plot( [ i , i ] , [ 0 mod_dataCh1_complex(i) ] , 'color' , 'm' );
%     hold on;
% end
% plot( mod_dataCh1_complex , '.' , 'markersize' , 8 , 'color' , 'b' );

% �� 1 ͨ��ԭʼ�ź��뾭�� Hilbert �任���ź����Ƚ�
figure( 'name' , '1ͨ���ź�ǰ��Ƚ�' );
% for i = 1 : length( mod_dataCh1_complex )
%     plot( [ i , i ] , [ mod_dataCh1_complex(i) dataCh1(i) ] , 'color' , 'm' );
%     hold on;
% end
% plot( mod_dataCh1_complex , '.' , 'markersize' , 8 , 'color' , 'g' );
% hold on;
% plot( dataCh1 , '.' , 'markersize' , 8 , 'color' , 'b' );
plot( dataCh1 , 'color' , 'b' );
hold on;
plot( mod_dataCh1_complex , 'color' , 'm' );