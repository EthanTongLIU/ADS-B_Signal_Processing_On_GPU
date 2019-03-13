% FID = fopen('C:\Users\Administrator\Desktop\Samples\VC\Simple\AD\TEST6ch40_3M.dat','r');
SamplesNum = 1024*256*2*100/8;
A = fread(FID,SamplesNum*8,'ushort');%when the function read the number, the binary number transfer to decimal number
%1024*256=AD_DATA_LEN
% 1024*256*2 equal to 1MB data (8channels and only 6ch usable).
dataCH6 = zeros(6,SamplesNum);
chipSamplesNum = 1024*256/4;
for i = 1:100 
    dataCH6(1,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A(2*(i-1)*chipSamplesNum*4+1:4:chipSamplesNum*(2*i-1)*4);
    dataCH6(2,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A(2*(i-1)*chipSamplesNum*4+2:4:chipSamplesNum*(2*i-1)*4);
    dataCH6(3,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A(2*(i-1)*chipSamplesNum*4+3:4:chipSamplesNum*(2*i-1)*4);
    dataCH6(4,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A(2*(i-1)*chipSamplesNum*4+4:4:chipSamplesNum*(2*i-1)*4);
    dataCH6(5,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A((2*i-1)*chipSamplesNum*4+1:4:chipSamplesNum*2*i*4);
    dataCH6(6,(i-1)*chipSamplesNum+1:chipSamplesNum*i) = A((2*i-1)*chipSamplesNum*4+2:4:chipSamplesNum*2*i*4);
end
dataCH6 =dataCH6 - 36864; %bin2dec('1001000000000000')=36864; 
%at  1.65*1e5 ,there is a ADSB signal. //for TEST6ch20M
%at 3.9122e6 ,there is a ADSB signal. //for TEST6ch40_3M
data1 = dataCH6(1,3.9122e6:3.9124e6+2500);%data1 = dataCH6(1,1.65*1e5:1.65*1e5+2500);
data2 = dataCH6(2,3.9122e6:3.9124e6+2500);% data2 = dataCH6(2,1.65*1e5:1.65*1e5+2500);
data3 = dataCH6(3,3.9122e6:3.9124e6+2500);% data3 = dataCH6(3,1.65*1e5:1.65*1e5+2500);
data4 = dataCH6(4,3.9122e6:3.9124e6+2500);% data4 = dataCH6(4,1.65*1e5:1.65*1e5+2500);
data5 = dataCH6(5,3.9122e6:3.9124e6+2500);% data5 = dataCH6(5,1.65*1e5:1.65*1e5+2500);
data6 = dataCH6(6,3.9122e6:3.9124e6+2500);% data6 = dataCH6(6,1.65*1e5:1.65*1e5+2500);
figure
plot(data1,'b');
hold on
plot(data2+1000,'r')
plot(data3+2000,'m')
plot(data4+3000,'g')
plot(data5+4000,'y')
plot(data6+5000,'c')
plot(abs(data+2048+1i*(data2+2048)),'g')
%%
figure
plot(data1,'b');
hold on
% plot(data2,'r')
% plot(data3,'m')
% plot(data4,'g')
% plot(data5,'y')
plot(data6,'c')
%%
Y1 = filter(b,1,data1+2048);
figure
plot(abs(Y1))
%%
Y1_f = fft(Y1);
data1_f = fft(data1);
X_ax = 1:40000/length(data1):40000;
figure
plot(X_ax,Y1_f,'b');
hold on 
plot(X_ax,data1_f,'r');
%%
dataCH6_2 = dataCH6;
dataCH6_2 = floor(dataCH6_2/16);
%%
figure(1)
plot(dataCH6(1,:),'b');
hold on
plot(dataCH6(2,:),'r');
figure(2)
plot(dataCH6_2(1,:),'b');
hold on
plot(dataCH6_2(2,:),'r');
%%
figure(3)
plot(dataCH6(1,:),'b');
hold on
plot(dataCH6(2,:),'r');
plot(dataCH6(3,:),'y');
plot(dataCH6(4,:),'m');
plot(dataCH6(5,:),'g');
plot(dataCH6(6,:),'k');
%%
a = abs(data1+2048);
b = filter([1/3,1/3,1/3 ],1,a);
figure
plot(b)
hold on 
plot(ones(1,2701)*1000,'r')
maxB = max(b);
c = b > 0.4*maxB;
bb = abs(data1+2048);
maxBB = max(bb);
cc = bb > 0.4*maxBB;
%%
d = zeros(1,ceil((1850-189)/20)*3);
k = 1;
for i = 189:20:1850
    c1 = sum(c(i:i+6));
    c2 = sum(c(i+7:i+12));
    c3 = sum(c(i+13:i+19));
    if c1 > 3
        d(k) = 1;
    end
    k = k+1;
    if c2 > 3
        d(k) = 1;
    end
    k = k+1;
    if c3 > 3
        d(k) = 1;
    end
    k = k+1;
end
%%
f = zeros(1,2701);
for i = 189:20:1850
    c1 = sum(c(i:i+7));
    c2 = sum(c(i+7:i+14));
    c3 = sum(c(i+13:i+20));
    if c1 > 3
        f(i:i+6) = 1;
    end
    if c2 > 3
        f(i+7:i+12) = 1;
    end
    if c3 > 3
        f(i+13:i+19) = 1;
    end
end
%%
Max_A = max(a);
g = zeros(1,2701);
for i = 190:20:1850
    c1 = sum(a(i:i+7));
    c2 = sum(a(i+7:i+14));
    c3 = sum(a(i+13:i+20));
    if c1 > 3*Max_A*1.2
        g(i:i+6) = 1;
    end
    if c2 > 3*Max_A*1.2
        g(i+7:i+12) = 1;
    end
    if c3 > 3*Max_A*1.2
        g(i+13:i+19) = 1;
    end
end
%%
figure;
plot(c,'m')
hold on
% plot(cc,'b')
plot(f*1.1,'c')
plot(g*1.2,'r')
plot(ones(1,2701)*10,'r')
%%
za = hilbert(data1+2048);
zb = abs(za);
zc = zb>0.5*max(zb);
zd = zeros(1,2701);
flag = 1;
for i = 188:20:1850
    zd(i:i+6) = flag;
    flag = mod(flag+1,2);
    zd(i+7:i+12) = flag;
    flag = mod(flag+1,2);
    zd(i+13:i+20) = flag;
    flag =mod(flag+1,2);
end
%%
figure
plot(zc,'b');
hold on
plot(zd*1.1,'r');