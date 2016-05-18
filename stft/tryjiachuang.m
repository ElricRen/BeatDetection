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

framelength=200; %����
framemove=100;%֡��
x1=enframe(x,framelength,framemove);%��֡
x2=enframe(x,hamming(framelength),framemove);%��һ֡��Ӻ�����
% figure;%��ͼ
% subplot(2,1,1),plot(x1(50,:))
% subplot(2,1,2),plot(x2(50,:))%��ֻ�Ƿ�һ֡����һ֡�Ӵ�
%�����ʱƽ������
x11=abs(x1);
x21=abs(x2);
amplitudex1=sum(x11,2);%��һ֡�ķ�ֵ������ӣ����м�
amplitudex2=sum(x21,2);
%�����ʱƽ������
x12=x1.^2;
x22=x2.^2;
engeryx1=sum(x12,2);%��һ֡������������ӣ����м�
engeryx2=sum(x22,2);
%h=gaussdesign(1/1000);
[z,pp]=butter(5,10000/fs);
engeryx1= filter(z,pp,engeryx1);
engeryx2= filter(z,pp,engeryx2);

% zeroratex1=zcro(x1);
% zeroratex1=zcro(x2);
%���������
% tmp1=enframe(x(1:end-1),framelength,framemove);
% tmp2=enframe(x(2:end),framelength,framemove);
% signs = (tmp1.*tmp2)<0;
% zcrx1 = sum(signs,2);%
 
zcrx1=zcro(x1);
zcrx2=zcro(x2);

framenum=length(zcrx1);%��ȡ֡��

figure(1);
subplot(2,2,1),plot(amplitudex1);ylabel('��ʱ����');
subplot(2,2,2),plot(amplitudex2);ylabel('�Ӵ���ʱ����');
subplot(2,2,3),plot(engeryx1);ylabel('��ʱ����');
subplot(2,2,4),plot(engeryx2);ylabel('�Ӵ���ʱ����');

% figure(2);%,zcrxx11,'b'
% subplot(1,2,1),plot(zcrx1);ylabel('������');
% subplot(1,2,2),plot(zcrx2);ylabel('�Ӵ�������');

% %�趨�������
% amp1 = 100;          %��ʱ������ֵ
% amp2 = 80;           %���趨������������ֵ��
% zcr1 = 5;          %��������ֵ
% zcr2 = 2;                 %�����ʵ�������ֵ���о���һ��û���õ���
% minsilence = 6;   %�������ĳ������ж������Ƿ����
% minlen  = 15;    %�ж�����������С����
% status  = 0;      %��¼�����ε�״̬
% count   = 0;     %�������еĳ���
% silence = 0;      %�����ĳ���
% 
% % amp1 = min(amp1, max(engeryx1)/4);
% % amp2 = min(amp2, max(engeryx1)/8);%min����������Сֵ�ģ�û��Ҫ˵�ˡ�
% m=0;
% q=0;
% p=0;
% %��ʼ�˵���
% for n=1:framenum
%     if engeryx1(n+j)>amp1 % ȷ�Ž���������
%         p=p+1;
%         A(p)=n;
%     end
% end
%     
% 
% % for n=1:length(zcrx1)%�����￪ʼ�������������˼·��Length��zcr���õ����������źŵ�֡����
% %    goto = 0;
% %    switch status
% %    case {0,1}                   % 0 = ����, 1 = ���ܿ�ʼ
% %       if engeryx1(n)>amp1          % ȷ�Ž���������
% %          a=1
% %          n
% %          y1 = max(n-count-1,1) % ��¼�����ε���ʼ��
% %          y1
% %          status  = 2;
% %          silence = 0;
% %          count   = count + 1;
% %       elseif engeryx1(n) > amp2 || zcrx1(n)<zcr2 % ���ܴ���������
% %           b=1
% %          status = 1;
% %          count  = count + 1;
% %       else                       % ����״̬
% %          status  = 0;
% %          count   = 0;
% %       end
% %    case 2,                       % 2 = ������
% %       if engeryx1(n)>amp2||zcrx1(n)<zcr2     % ������������
% %            count = count + 1;
% %       else                       % ����������
% %          silence = silence+1;
% %          if silence<minsilence % ����������������δ����
% %             count  = count + 1;
% %          elseif count<minlen   % ��������̫�̣���Ϊ������
% %             status  = 0;
% %             silence = 0;
% %             count   = 0;
% %          else                    % ��������
% %             status  = 3;
% %          end
% %       end
% %    case 3,
% %       break;
% %    end
% % end  
% % count = count-silence/2;
% % y2=y1+count -1;              %��¼�����ν�����
% %��ߵĳ������ҳ������ˣ�Ȼ���ú��߸��������û���ټ����������Ͳ���˵�ˡ�
% figure(3)
% subplot(3,1,1)
% plot(x)
% axis([1 length(x) -1 1])%����x����y��ķ�Χ��
% ylabel('Speech');
% line([y1*framemove y1*framemove], [-1 1], 'Color', 'red');
% line([y2*framemove y2*framemove], [-1 1], 'Color', 'red');%ע����line�������÷���������������һ��ֱ�ߣ�������ˡ�
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

