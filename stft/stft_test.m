%STFT
clear;clc;
for train_num=1:20
    
    input=['E:/毕设/train_beat/train',num2str(train_num),'.wav'];
    %     input='E:/毕设/train_beat/train17.wav';
    [x,fs]=audioread(input);
    x=x(44100*0+1:44100*30);%fs=44100
    x=decimate(x,10);   %降采样
    % x=abs(x);
    [r,l]=size(x);
    m=size(x,1);  % 信号真实长度
    % [z,pp]=butter(5,10000/fs);
    
    framelength=200; %窗长
    framemove=100;%帧移
    % x1=enframe(x,framelength,framemove);%分帧
    x2=enframe(x,hamming(framelength),framemove);%分帧，并给一帧添加汉明窗,
    
    framenum=size(x2,1);%求取帧数
    %frametime=(((1:framelength)-1)*framemove+framelength/2)/fs;
    wlen=framelength/2+1; %频谱域的坐标长度
    n2=1:wlen;
    freq=(n2-1)*fs/framelength; %计算FFT后的频率刻度
    for i=1:framenum
        stft_x2(i,:)=fft(x2(i,:),framelength);
    end
    % stft_x2=fft(x2);  %STFT变换
    amp_stft_x2=abs(stft_x2(n2,:));%STFT共轭对称，只看一半就可以了
    diff_angle=zeros(framenum,1);%初始化相位差矩阵
    
    for i=1:framenum-1
        temp1=zeros(framelength,1);
        for j=1:framelength
            temp1(j)=acos(dot(stft_x2(i+1,j),stft_x2(i,j))/norm(stft_x2(i+1,j))*norm(stft_x2(i,j)));
            temp1(j)=abs(temp1(j));
        end
        diff_angle(i+1)=sum(temp1);
    end
    diff_amp=zeros(framenum,1);%初始化幅值矩阵
    temp3=zeros(wlen,1);
    for i=1:framenum-1
        for j=1:wlen
            %             temp3(j)=abs(stft_x2(i+1,j))-abs(stft_x2(i,j));
            temp3(j)=norm(stft_x2(i+1,j)-stft_x2(i,j));
            %        temp3(j)=abs(temp3(j));
        end
        diff_amp(i+1)=abs(sum(temp3));
    end
    
    %   获取txt文件中的节拍坐标
    beat=zeros(framenum,1);
    beat_index=txt_read(['E:/毕设/train_beat/train',num2str(train_num),'.txt'],100);
    for i=1:100
        index=round(beat_index{i,1}*fs/(framemove*10));
        beat(index)=max(diff_angle);
    end
    
    
    figure(1)
    plot(diff_angle);ylabel('相角差');xlabel('帧/个');
    title(['STFT phase of train',num2str(train_num),'.wav']);
    %     获取峰值
    peak=peak_dect(diff_angle,0.7,1.5);
    hold on;
    plot(peak,'o');
    hold on;
    plot(beat,'r');
    set(1,'position',[0,0,1900,800]);
    A=getframe(1);
    imwrite(A.cdata,['E:\毕设\result\stft_phase\train',num2str(train_num),'.jpg']);
    clf;
    
    figure(2)
    plot(diff_amp);ylabel('幅值差');xlabel('帧/个');
    title(['STFT of train',num2str(train_num),'.wav']);
    %     获取峰值
    peak=peak_dect(diff_amp,0.1,1.5);
    hold on;
    plot(peak,'o');
    hold on;
    for i=1:100
        index=round(beat_index{i,1}*fs/(framemove*10));
        beat(index)=max(diff_amp);
    end
    plot(beat,'r');
    set(2,'position',[0,0,1900,800]);
    A=getframe(2);
    imwrite(A.cdata,['E:\毕设\result\stft\train',num2str(train_num),'.jpg']);
    clc;clear;clf;
end
