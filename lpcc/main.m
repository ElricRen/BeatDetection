
clear;clc;clf;
for train_num=1:20
    input=['E:/毕设/train_beat/train',num2str(train_num),'.wav'];
    [x,fs]=audioread(input);
    % x=filter([1-0.9375],1,x);
    x=decimate(x,10);
    len=200;%160
    framemove=100;
    y=enframe(x,len,len/2);
    
    [b,c]=size(y);
    
    for n=1:b
        yy=y(n,:);
        p=10;
        A=real(lpc3(yy,p));
        lpc1=A;
        a=lpc2lpcc(lpc1);
        lpcc(n,:)=a;
    end
    diff_lpcc=zeros(b,1);
    temp_lpcc=zeros(12,1);
   
    for i=1:b-1
        for j=1:12
            temp_lpcc(j)=lpcc(i+1,j)-lpcc(i,j);
        end
        diff_lpcc(i+1)=abs(sum(temp_lpcc));
    end
    
    %   获取txt文件中的节拍坐标
    beat=zeros(b,1);
    beat_index=txt_read(['E:/毕设/train_beat/train',num2str(train_num),'.txt'],100);
    for i=1:100
        index=round(beat_index{i,1}*fs/(framemove*10));
        beat(index)=max(diff_lpcc);
    end
    
    figure(1);
    title(['LPCC of train',num2str(train_num),'.wav']);
    plot(diff_lpcc);
    hold on;
    plot(beat,'r');
    set(1,'position',[0,0,1900,800]);
    A=getframe(1);
    imwrite(A.cdata,['E:\毕设\result\lpcc\train',num2str(train_num),'.jpg']);
    clc;clear;clf;
end