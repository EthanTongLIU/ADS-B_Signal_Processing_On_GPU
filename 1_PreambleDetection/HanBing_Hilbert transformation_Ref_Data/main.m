clear, clc, clf;
close all;

load( 'matlab6CH40_3M.mat' );
dataCh1 = data1 + 2048;

%% 绘制原始信号序列
figure( 'name' , '原始信号序列' );
% subplot( 1 , 2 , 1 );
plot( dataCh1 , 'color' , 'b' , 'linewidth' , 2 );
hold on;
% axis( [ 500 1000 -160 160 ] );
% subplot( 1 , 2 , 2 );
plot( abs( dataCh1 ) , 'color' , 'm' , 'linewidth' , 2 );
legend( '原始信号' , '原始信号取模' );
axis( [ 160 280 -200 200 ] );
%%

% 计算输入序列的离散傅里叶变换，点数选择输入序列的长度
N = length( dataCh1 );

X = zeros( 1 , N );

for k = 1 : N 
    X(k) = dft( dataCh1 , k );
end

figure( 'name' , '输入序列的DFT' );
subplot( 1 , 2 , 1 );
plot( abs( X ) , '-o' );
title( '原始dft计算结果' );
subplot( 1 , 2 , 2 );
plot( abs( fft( dataCh1 ) ) , '-o' );
title( 'Matlab自带fft计算结果' );

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
plot( -1350 : 1 : 1350 , abs( Y ) , '-o' );
xlabel( '\omega' , 'fontsize' , 20 );
title( '频谱幅值' );
subplot( 1 , 2 , 2 );
plot( -1350 : 1 : 1350 , angle( Y ) , '-o' );
xlabel( '\omega' , 'fontsize' , 20 );
title( '频谱相位' );

% 频域相乘
H = X .* Y;
figure( 'name' , 'Hilbert 变换后的频谱与原始信号频谱比较' );
subplot( 2 , 2 , 1 );
plot( abs( H ) );
title( 'Aft频谱幅度' );
subplot( 2 , 2 , 2 );
plot( angle( H( 1290 : 1412 ) ) , '-o' );
title( 'Aft频谱相位' );
subplot( 2 , 2 , 3 );
plot( abs( X ) );
title( 'Ori频谱幅度' );
subplot( 2 , 2 , 4 );
plot( angle( X( 1290 : 1412 ) ) , '-o' );
title( 'Ori频谱相位' );

figure( 'name' , '前后相位差' );
plot( angle( H( 1290 : 1412 ) ) - angle( X( 1290 : 1412 ) ) , '-o' );

% 使用 IDFT 计算输出序列，得到原始信号的 Hilbert 变换，即解析信号的虚部
h = zeros( 1 , N );

for n = 1 : N
    h(n) = idft( H , n );
end

% 构建解析信号，令 Hilbert 变换后的序列作为虚部
signal_analytic = dataCh1 + 1i * abs( h );

figure( 'name' , 'Hilbert 变换后的序列' );
plot( dataCh1 , 'g' , 'linewidth' , 3 );
hold on;
plot( abs( signal_analytic ) , 'm' , 'linewidth' , 3 );
hold on;
plot( abs( hilbert( dataCh1 ) ) , 'b' , 'linewidth' , 3 );
legend( '原始信号' , '解析信号--自己实现变换' , '解析信号--Matlab自带变换' );
% plot( abs( hilbert( dataCh1 ) ) , 'b' );



