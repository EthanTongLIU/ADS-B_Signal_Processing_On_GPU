clear, clc, clf;
close all;

% 加载信号，并将信号做线性变换
load( 'matlab6CH40_3M.mat' );
dataCh1 = abs( data1 + 2048 );
dataCh2 = abs( data2 + 2048 );
dataCh3 = abs( data3 + 2048 );
dataCh4 = abs( data4 + 2048 );
dataCh5 = abs( data5 + 2048 );
dataCh6 = abs( data6 + 2048 );

% 绘制 6 个通道的信号
figure( 'name' , '6个通道的信号' );
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

% 将 1 通道的信号用点竖线表示出来
% figure( 'name' , '1通道信号点竖线' );
% for i = 1 : length( data1 )
%     plot( [ i , i ] , [ 0 dataCh1(i) ] , 'color' , 'm' );
%     hold on;
% end
% plot( dataCh1 , '.' , 'markersize' , 8 , 'color' , 'b' );

% 分析通道 1 的信号
figure( 'name' , '1通道信号的频谱' );
subplot( 2 , 1 , 1 );
plot( abs( fft( dataCh1 , 4096 ) ) );
subplot( 2 , 1 , 2 );
plot( angle( fft( dataCh1 , 4096 ) ) );

% 将 1 通道的信号做 Hilbert 变换变为复信号
dataCh1_complex = hilbert( data1 + 2048 );
mod_dataCh1_complex = abs( dataCh1_complex );
% figure( 'name' , '1通道信号经过 Hilbert 变换' );
% for i = 1 : length( mod_dataCh1_complex )
%     plot( [ i , i ] , [ 0 mod_dataCh1_complex(i) ] , 'color' , 'm' );
%     hold on;
% end
% plot( mod_dataCh1_complex , '.' , 'markersize' , 8 , 'color' , 'b' );

% 将 1 通道原始信号与经过 Hilbert 变换的信号作比较
figure( 'name' , '1通道信号前后比较' );
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