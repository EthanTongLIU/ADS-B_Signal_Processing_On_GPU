function x_n = idft( X , n )
% 利用定义计算一个点的离散傅里叶逆变换
% 输入 X 为经过 DFT 之后的频域信号序列，n 为需要计算的第 n 个点的 IDFT
% 输出 x_n 第 n 个点的 IDFT 

N = length( X );
x_n_Re = 0;
x_n_Im = 0;
for k = 1 : N
    x_n_Re = x_n_Re + X(k) * cos( 2 * pi / N * k * n );
    x_n_Im = x_n_Im + X(k) * sin( 2 * pi / N * k * n );
end

x_n = 1 / N * ( x_n_Re + 1i * x_n_Im );

end

