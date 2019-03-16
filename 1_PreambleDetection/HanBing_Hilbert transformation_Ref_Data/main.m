clear, clc, clf;
close all;

load( 'matlab6CH40_3M.mat' );
dataCh1 = data1 + 2048;

% 绘制原始信号序列
figure( 'name' , '原始信号序列' );
% subplot( 1 , 2 , 1 );
plot( dataCh1 , 'color' , 'b' , 'linewidth' , 1 );
% hold on;
% axis( [ 500 1000 -160 160 ] );
% subplot( 1 , 2 , 2 );
% plot( abs( dataCh1 ) , 'color' , 'm' , 'linewidth' , 1 );
% legend( '原始信号' , '原始信号取模' );
axis( [ 0 2701 -200 200 ] );
%

% 计算输入序列的离散傅里叶变换，点数选择输入序列的长度
N = length( dataCh1 );

X = zeros( 1 , N );

for k = 1 : N 
    X(k) = dft( dataCh1 , k );
end

x_bot = linspace( -40/3 , 40/3 , N );
figure( 'name' , '输入序列的DFT' );
subplot( 1 , 2 , 1 );
plot( x_bot , abs( X ) , 'linewidth' , 1 , 'color' , 'b' );
title( '频谱幅值' );
subplot( 1 , 2 , 2 );
plot( x_bot , angle( X ) , 'linewidth' , 1 , 'color' , 'b' );
title( '频谱相位' );
%

% 计算冲激响应序列的离散傅里叶变换，点数选择输入序列的长度
Y = [ 1i * ones( 1 , ( 2701 - 1 ) / 2 ) , -1i , - 1i * ones( 1 , ( 2701 - 1 ) / 2 ) ];
% y = 1 / pi * 1 ./ ( 1 : N );
% Y = zeros( 1 , N );
% 
% for k = 1 : N
%     Y(k) = dft( y , k );
% end
% 
figure( 'name' , '冲激响应序列的DFT' );
subplot( 1 , 2 , 1 );
plot( -1350 : 1 : 1350 , abs( Y ) , 'color' , 'b' , 'linewidth' , 3 );
xlabel( '\omega' , 'fontsize' , 20 );
title( '频谱幅值' );
subplot( 1 , 2 , 2 );
plot( -1350 : 1 : 1350 , angle( Y ) , 'color' , 'b' , 'linewidth' , 3 );
xlabel( '\omega' , 'fontsize' , 20 );
title( '频谱相位' );
%

% 频域相乘
H = X .* Y;
% figure( 'name' , 'Hilbert 变换后的频谱与原始信号频谱比较' );
% subplot( 2 , 2 , 1 );
% plot( abs( H ) );
% title( 'Aft频谱幅度' );
% subplot( 2 , 2 , 2 );
% plot( angle( H( 1290 : 1412 ) ) , '-o' );
% title( 'Aft频谱相位' );
% subplot( 2 , 2 , 3 );
% plot( abs( X ) );
% title( 'Ori频谱幅度' );
% subplot( 2 , 2 , 4 );
% plot( angle( X( 1290 : 1412 ) ) , '-o' );
% title( 'Ori频谱相位' );

figure( 'name' , '经过 Hilbert 变换后的频谱' );
subplot( 1 , 2 , 1 );
plot( -1350 : 1 : 1350 , abs( H ) , 'color' , 'b' , 'linewidth' , 1 );
title( '频谱幅值' );
subplot( 1 , 2 , 2 );
plot( -1350 : 1 : 1350 , angle( H ) , '-o' , 'color' , 'b' , 'linewidth' , 1 );
title( '频谱相位' );
%

% 分析变换前后的相位差
figure( 'name' , '前后相位差' );
% % subplot( 3 , 1 , 1 );
% plot( angle( X( 1320 : 1382 ) ) , '-o' , 'color' , 'r' , 'linewidth' , 1 );
% % subplot( 3 , 1 , 2 );
% hold on;
% plot( angle( H( 1320 : 1382 ) ) , '-o' , 'color' , 'g' , 'linewidth' , 1 );
% % subplot( 3 , 1 , 3 );
% hold on;
% plot( angle( H( 1320 : 1382 ) ) - angle( X( 1320 : 1382 ) ) , '-o' , 'color' , 'b' , 'linewidth' , 1 );
% legend( '原始信号相位' , '变换后相位' , '相位差' );

plot( -1350 : 1 : 1350 , angle( H ) - angle( X ) , '.' , 'markersize' , 5 , 'color' , 'b' );

%

% 使用 IDFT 计算输出序列，得到原始信号的 Hilbert 变换，即解析信号的虚部
h = zeros( 1 , N );

for n = 1 : N
    h(n) = idft( H , n );
end

% 构建解析信号，令 Hilbert 变换后的序列作为虚部
signal_analytic = dataCh1 + 1i * h;

% Z = zeros( 1 , N );
% for n = 1 : N
%     Z(n) = dft( signal_analytic , n );
% end
% 
% figure( 'name' , '解析信号频谱' );
% subplot( 1 , 2 , 1 );
% plot( -1350 : 1 : 1350 , abs( Z ) , '-o' , 'color' , 'b' );
% title( '解析信号频谱幅值' );
% subplot( 1 , 2 , 2 );
% plot( -1350 : 1 : 1350 , abs( X ) , '-o' , 'color' , 'b' );
% title( '原始信号频谱幅值' );

figure( 'name' , 'Hilbert 变换后的序列' );
plot( dataCh1 , 'r' , 'linewidth' , 3 );
hold on;
plot( abs( signal_analytic ) , 'g' , 'linewidth' , 3 );
hold on;
plot( abs( dataCh1 ) , 'b' , 'linewidth' , 3 );
% hold on;
% plot( abs( hilbert( dataCh1 ) ) , 'b' , 'linewidth' , 2 );
legend( '原始信号' , '解析信号的模' , '原始信号的模' );
% plot( abs( hilbert( dataCh1 ) ) , 'b' );
%


