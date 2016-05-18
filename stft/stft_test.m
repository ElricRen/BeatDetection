%STFT
clear;clc;
for train_num=1:20
    
    input=['E:/����/train_beat/train',num2str(train_num),'.wav'];
    %     input='E:/����/train_beat/train17.wav';
    [x,fs]=audioread(input);
    x=x(44100*0+1:44100*30);%fs=44100
    x=decimate(x,10);   %������
    % x=abs(x);
    [r,l]=size(x);
    m=size(x,1);  % �ź���ʵ����
    % [z,pp]=butter(5,10000/fs);
    
    framelength=200; %����
    framemove=100;%֡��
    % x1=enframe(x,framelength,framemove);%��֡
    x2=enframe(x,hamming(framelength),framemove);%��֡������һ֡��Ӻ�����,
    
    framenum=size(x2,1);%��ȡ֡��
    %frametime=(((1:framelength)-1)*framemove+framelength/2)/fs;
    wlen=framelength/2+1; %Ƶ��������곤��
    n2=1:wlen;
    freq=(n2-1)*fs/framelength; %����FFT���Ƶ�ʿ̶�
    for i=1:framenum
        stft_x2(i,:)=fft(x2(i,:),framelength);
    end
    % stft_x2=fft(x2);  %STFT�任
    amp_stft_x2=abs(stft_x2(n2,:));%STFT����Գƣ�ֻ��һ��Ϳ�����
    diff_angle=zeros(framenum,1);%��ʼ����λ�����
    
    for i=1:framenum-1
        temp1=zeros(framelength,1);
        for j=1:framelength
            temp1(j)=acos(dot(stft_x2(i+1,j),stft_x2(i,j))/norm(stft_x2(i+1,j))*norm(stft_x2(i,j)));
            temp1(j)=abs(temp1(j));
        end
        diff_angle(i+1)=sum(temp1);
    end
    diff_amp=zeros(framenum,1);%��ʼ����ֵ����
    temp3=zeros(wlen,1);
    for i=1:framenum-1
        for j=1:wlen
            %             temp3(j)=abs(stft_x2(i+1,j))-abs(stft_x2(i,j));
            temp3(j)=norm(stft_x2(i+1,j)-stft_x2(i,j));
            %        temp3(j)=abs(temp3(j));
        end
        diff_amp(i+1)=abs(sum(temp3));
    end
    
    %   ��ȡtxt�ļ��еĽ�������
    beat=zeros(framenum,1);
    beat_index=txt_read(['E:/����/train_beat/train',num2str(train_num),'.txt'],100);
    for i=1:100
        index=round(beat_index{i,1}*fs/(framemove*10));
        beat(index)=max(diff_angle);
    end
    
    
    figure(1)
    plot(diff_angle);ylabel('��ǲ�');xlabel('֡/��');
    title(['STFT phase of train',num2str(train_num),'.wav']);
    %     ��ȡ��ֵ
    peak=peak_dect(diff_angle,0.7,1.5);
    hold on;
    plot(peak,'o');
    hold on;
    plot(beat,'r');
    set(1,'position',[0,0,1900,800]);
    A=getframe(1);
    imwrite(A.cdata,['E:\����\result\stft_phase\train',num2str(train_num),'.jpg']);
    clf;
    
    figure(2)
    plot(diff_amp);ylabel('��ֵ��');xlabel('֡/��');
    title(['STFT of train',num2str(train_num),'.wav']);
    %     ��ȡ��ֵ
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
    imwrite(A.cdata,['E:\����\result\stft\train',num2str(train_num),'.jpg']);
    clc;clear;clf;
end
