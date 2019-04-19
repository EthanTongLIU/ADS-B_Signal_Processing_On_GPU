function X_k = dft( x , k )
% 利用定义计算一个点的离散傅里叶变换
% 输入 x 为时域上的采样信号序列，k 为需要计算的第几个值
% 输出 X 为第 k 点经过离散傅里叶变换以后的值

N = length( x );
X_k_Re = 0;
X_k_Im = 0;
for n = 1 : N
    X_k_Re = X_k_Re + x(n) * cos( 2 * pi / N * k * n );
    X_k_Im = X_k_Im + x(n) * sin( 2 * pi / N * k * n );
end

X_k = X_k_Re - 1i * X_k_Im;

end

