%STFT
clc;clear;
[x,fs]=audioread('b2dan.wav');
x=x(44100*0+1:44100*20);
x=decimate(x,12);   %������
% x=abs(x);
[r,l]=size(x);
m=size(x,1);  % �ź���ʵ����
% [z,pp]=butter(5,10000/fs);

framelength=200; %����
framemove=100;%֡��
%x1=enframe(x,framelength,framemove);%��֡
x2=enframe(x,hamming(framelength),framemove);%��֡������һ֡��Ӻ�����,

framenum=size(x2,1);%��ȡ֡��
%frametime=(((1:framelength)-1)*framemove+framelength/2)/fs;
wlen=framelength/2+1; %Ƶ��������곤��
n2=1:wlen;
freq=(n2-1)*fs/framelength; %����FFT���Ƶ�ʿ̶�
for i=1:framenum
    stft_x(i,:)=fft(x2(i,:),framelength);
end
stft_x2=fft(x2);  %STFT�任
amp_stft_x2=abs(stft_x2(n2,:));%STFT����Գƣ�ֻ��һ��Ϳ�����

diff_angle=zeros(framenum,1);%��ʼ����λ�����
for i=1:framenum-1
    temp1=zeros(framelength,1);
    temp2=zeros(framelength,1);
    for j=1:wlen
       temp1(j)=acos(dot(stft_x(i+1,j),stft_x(i,j))/norm(stft_x(i+1,j))*norm(stft_x(i,j)));
       temp1(j)=abs(temp1(j));
    end
    diff_angle(i+1)=sum(temp1);
end
diff_amp=zeros(framenum,1);%��ʼ����ֵ����
for i=1:framenum-1
       temp2=zeros(wlen,1);
    for j=1:wlen
       temp2(j)=abs(stft_x(i+1,j))-abs(stft_x(i,j));
       %temp2(j)=abs(temp2(j));
    end
    diff_amp(i+1)=sum(temp2);
end

[stft_cmp_x2,f,t,p] = spectrogram(x,hamming(framelength),framemove,framelength,fs); 
diff_angle_cmp=zeros(framenum,1);%��ʼ����λ�����
for i=1:framenum-1
    temp1=zeros(framelength,1);
    for j=1:wlen
       temp1(j)=acos(dot(stft_cmp_x2(j,i+1),stft_cmp_x2(j,i))/norm(stft_cmp_x2(j,i+1))*norm(stft_cmp_x2(j,i)));
       temp1(j)=abs(temp1(j));
    end
    diff_angle_cmp(i+1)=sum(temp1);
end
diff_amp_cmp=zeros(framenum,1);%��ʼ����ֵ����
for i=1:framenum-1
       temp2=zeros(wlen,1);
    for j=1:wlen
       temp2(j)=abs(stft_cmp_x2(j,i+1))-abs(stft_cmp_x2(j,i));
       %temp2(j)=abs(temp2(j));
    end
    diff_amp_cmp(i+1)=sum(temp2);
end

% figure(1)
% clf
% imagesc(framenum,freq,amp_stft_x2);%������ֵ��
% axis xy; ylabel('Ƶ��/Hz');xlabel('������/��');
% title('��ֵ��');
% % m=64;


% 
% figure(1)
% clf
% imagesc(framenum,freq,amp_stft_x2);%������ֵ��
% axis xy; ylabel('Ƶ��/Hz');xlabel('������/��');
% title('��ֵ��');
% m=64;
% LightYellow=[0.6 0.6 0.6];
% MidRed=[0 0 0];
% Black=[0.5 0.7 1];
% Colors=[LightYellow;MidRed;Black];
% colormap(SpecColorMap(m,Colors));
% 
% 
figure(2)
subplot(2,1,1);plot(diff_amp_cmp);ylabel('���������ֵ��');xlabel('֡/��');
subplot(2,1,2);plot(diff_amp);ylabel('�Ҽ���ķ�ֵ��');xlabel('֡/��');
% % 
figure(3)
subplot(2,1,1);plot(diff_angle_cmp);ylabel('����������ǲ�');xlabel('֡/��');
subplot(2,1,2);plot(diff_angle);ylabel('�Ҽ������ǲ�');xlabel('֡/��');
