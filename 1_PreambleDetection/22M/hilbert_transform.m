function [ signal_analytic ] = hilbert_transform( data )

% 计算输入序列的离散傅里叶变换，点数选择输入序列的长度
N = length( data );

X = zeros( 1 , N );

for k = 1 : N 
    X(k) = dft( data , k );
end

% 计算冲激响应序列的离散傅里叶变换，点数选择输入序列的长度
Y = [ 1i * ones( 1 , ( N - 1 ) / 2 ) , -1i , - 1i * ones( 1 , ( N - 1 ) / 2 ) ];

% 频域相乘
H = X .* Y;

% 使用 IDFT 计算输出序列，得到原始信号的 Hilbert 变换，即解析信号的虚部
h = zeros( 1 , N );

for n = 1 : N
    h(n) = idft( H , n );
end

% 构建解析信号，令 Hilbert 变换后的序列作为虚部
signal_analytic = data + 1i * real( h ); % 虚部的微小扰动舍去，只保留实部

signal_analytic = abs( signal_analytic );

end

