% INC=20       													% set frame increment
% NW=INC*2     													% oversample by a factor of 2 (4 is also often used)
% S=cos((0:NW*7)*6*pi/NW);								% example input signal
% W=sqrt(hamming(NW+1)); W(end)=[];      % sqrt hamming window of period NW
% F=enframe(S,W,INC);               			% split into frames
% ... process frames ...
% X=overlapadd(F,W,INC);           			% reconstitute the time waveform (omit "X=" to plot waveform)
% i=1:281;
% for i=1:280
%     S(i);
%     X(i);
% end
% i=1:280;
% plot(i,S(i),'r',i,X(i),'b');

[x,fs]=audioread('b2dan.wav');
x=x(44100*0+1:44100*20);
x=decimate(x,12)
% x=abs(x);
[r,l]=size(x);
% [z,pp]=butter(5,10000/fs);

framelength=200; %窗长
framemove=100;%帧移
x1=enframe(x,framelength,framemove);%分帧
x2=enframe(x,hamming(framelength),framemove);%给一帧添加汉明窗
% figure;%画图
% subplot(2,1,1),plot(x1(50,:))
% subplot(2,1,2),plot(x2(50,:))%这只是分一帧，给一帧加窗
%计算短时平均幅度
x11=abs(x1);
x21=abs(x2);
amplitudex1=sum(x11,2);%把一帧的幅值进行相加，按列加
amplitudex2=sum(x21,2);
%计算短时平均能量
x12=x1.^2;
x22=x2.^2;
engeryx1=sum(x12,2);%把一帧的能量进行相加，按列加
engeryx2=sum(x22,2);
%h=gaussdesign(1/1000);
[z,pp]=butter(5,10000/fs);
engeryx1= filter(z,pp,engeryx1);
engeryx2= filter(z,pp,engeryx2);

% zeroratex1=zcro(x1);
% zeroratex1=zcro(x2);
%计算过零率
% tmp1=enframe(x(1:end-1),framelength,framemove);
% tmp2=enframe(x(2:end),framelength,framemove);
% signs = (tmp1.*tmp2)<0;
% zcrx1 = sum(signs,2);%
 
zcrx1=zcro(x1);
zcrx2=zcro(x2);

framenum=length(zcrx1);%求取帧数

figure(1);
subplot(2,2,1),plot(amplitudex1);ylabel('短时幅度');
subplot(2,2,2),plot(amplitudex2);ylabel('加窗短时幅度');
subplot(2,2,3),plot(engeryx1);ylabel('短时能量');
subplot(2,2,4),plot(engeryx2);ylabel('加窗短时能量');

% figure(2);%,zcrxx11,'b'
% subplot(1,2,1),plot(zcrx1);ylabel('过零率');
% subplot(1,2,2),plot(zcrx2);ylabel('加窗过零率');

% %设定检测门限
% amp1 = 100;          %短时能量阈值
% amp2 = 80;           %即设定能量的两个阈值。
% zcr1 = 5;          %过零率阈值
% zcr2 = 2;                 %过零率的两个阈值，感觉第一个没有用到。
% minsilence = 6;   %用无声的长度来判断语音是否结束
% minlen  = 15;    %判断是语音的最小长度
% status  = 0;      %记录语音段的状态
% count   = 0;     %语音序列的长度
% silence = 0;      %无声的长度
% 
% % amp1 = min(amp1, max(engeryx1)/4);
% % amp2 = min(amp2, max(engeryx1)/8);%min函数是求最小值的，没必要说了。
% m=0;
% q=0;
% p=0;
% %开始端点检测
% for n=1:framenum
%     if engeryx1(n+j)>amp1 % 确信进入语音段
%         p=p+1;
%         A(p)=n;
%     end
% end
%     
% 
% % for n=1:length(zcrx1)%从这里开始才是整个程序的思路。Length（zcr）得到的是整个信号的帧数。
% %    goto = 0;
% %    switch status
% %    case {0,1}                   % 0 = 静音, 1 = 可能开始
% %       if engeryx1(n)>amp1          % 确信进入语音段
% %          a=1
% %          n
% %          y1 = max(n-count-1,1) % 记录语音段的起始点
% %          y1
% %          status  = 2;
% %          silence = 0;
% %          count   = count + 1;
% %       elseif engeryx1(n) > amp2 || zcrx1(n)<zcr2 % 可能处于语音段
% %           b=1
% %          status = 1;
% %          count  = count + 1;
% %       else                       % 静音状态
% %          status  = 0;
% %          count   = 0;
% %       end
% %    case 2,                       % 2 = 语音段
% %       if engeryx1(n)>amp2||zcrx1(n)<zcr2     % 保持在语音段
% %            count = count + 1;
% %       else                       % 语音将结束
% %          silence = silence+1;
% %          if silence<minsilence % 静音还不够长，尚未结束
% %             count  = count + 1;
% %          elseif count<minlen   % 语音长度太短，认为是噪声
% %             status  = 0;
% %             silence = 0;
% %             count   = 0;
% %          else                    % 语音结束
% %             status  = 3;
% %          end
% %       end
% %    case 3,
% %       break;
% %    end
% % end  
% % count = count-silence/2;
% % y2=y1+count -1;              %记录语音段结束点
% %后边的程序是找出语音端，然后用红线给标出来，没多少技术含量，就不多说了。
% figure(3)
% subplot(3,1,1)
% plot(x)
% axis([1 length(x) -1 1])%限制x轴与y轴的范围。
% ylabel('Speech');
% line([y1*framemove y1*framemove], [-1 1], 'Color', 'red');
% line([y2*framemove y2*framemove], [-1 1], 'Color', 'red');%注意下line函数的用法：基于两点连成一条直线，就清楚了。
% subplot(3,1,2)
% plot(engeryx1);axis([1 length(engeryx1) 0 max(engeryx1)])
% ylabel('Energy');line([y1 y1], [min(engeryx1),max(engeryx1)], 'Color', 'red');
% line([y2 y2], [min(engeryx1),max(engeryx1)], 'Color', 'red');
% subplot(3,1,3)
% plot(zcrx1);
% axis([1 length(zcrx1) 0 max(zcrx1)])
% ylabel('ZCR');
% line([y1 y1], [min(zcrx1),max(zcrx1)], 'Color', 'red');
% line([y2 y2], [min(zcrx1),max(zcrx1)], 'Color', 'red');

