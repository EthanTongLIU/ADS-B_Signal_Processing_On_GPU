function [ dataCH6 ] = readFile( fileName )
% 读入文件，分解出 6 个通道
% 输入为文件名，输出为 6 个通道的数据

FID = fopen( fileName , 'r' );
N_s = 400; 
SamplesNum = 1024*256*2/8*N_s;
A = fread(FID,SamplesNum*8,'ushort');%when the function read the number, the binary number transfer to decimal number
%1024*256=AD_DATA_LEN
% 1024*256*2 equal to 1MB data (8channels and only 6ch usable).
dataCH6 = zeros(6,SamplesNum);
chipSamplesNum = 1024*256/4;
for i = 1:N_s 
    dataCH6(1,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A(2*(i-1)*chipSamplesNum*4+1:4:chipSamplesNum*(2*i-1)*4);
    dataCH6(2,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A(2*(i-1)*chipSamplesNum*4+2:4:chipSamplesNum*(2*i-1)*4);
    dataCH6(3,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A(2*(i-1)*chipSamplesNum*4+3:4:chipSamplesNum*(2*i-1)*4);
    dataCH6(4,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A(2*(i-1)*chipSamplesNum*4+4:4:chipSamplesNum*(2*i-1)*4);
    dataCH6(5,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A((2*i-1)*chipSamplesNum*4+1:4:chipSamplesNum*2*i*4);
    dataCH6(6,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A((2*i-1)*chipSamplesNum*4+2:4:chipSamplesNum*2*i*4);
 end
 dataCH6 =dataCH6 - 36864; %bin2dec('1001000000000000')=36864;
 
end