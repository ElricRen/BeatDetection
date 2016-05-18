clc;clear;
for train_num=1:20
    
    input=['E:/毕设/train_beat/train',num2str(train_num),'.wav'];
    sig = Signal(input);
    sig.windowLength = 4.5;      %sets windows of 70ms 需要考虑降采样，self.nfft = round(self.fs*self.windowLength/1000);
    sig.overlapRatio = 0.5;     %sets overlap ratio 0 < overlapRatio < 1 default:0.8
    sig.CQT;
    diff_s=zeros(size(sig.Sq,2),1);
    for i=1:size(sig.Sq,2)-1
        temp=zeros(size(sig.Sq,1),1);
        for j=1:size(sig.Sq,1)
            %             temp(j) = abs(sig.Sq(j,i+1)) - abs(sig.Sq(j,i));
            temp(j)=norm(sig.Sq(j,i+1)-sig.Sq(j,i));
            
            temp(j)=abs(temp(j));
        end
        diff_s(i+1)=abs(sum(temp));
    end
    
    
    %   pick peak
    %     peak=peak_dect(diff_s,0.2,0.5);
    peak=peak_dect2(diff_s,0.7,0.7);
    %   get the infomation of beat index
    beat=zeros(size(sig.Sq,2),1);
    beat_index=txt_read(['E:/毕设/train_beat/train',num2str(train_num),'.txt'],100);
    for i=1:100
        index=round(beat_index{i,1}*sig.fs/(10*sig.nfft*(1-sig.overlapRatio)));
        beat(index)=max(peak);
    end
    
    figure(1);
        plot(diff_s);
    title(sprintf('CQT of train%d.wav',train_num));
        hold on;
    plot(peak,'o');
    hold on; plot(beat,'r'); 
    set(1,'position',[0,0,1900,800]);
    A=getframe(1);
    imwrite(A.cdata,['E:\毕设\result\cqt\5train',num2str(train_num),'.jpg']);
    clc;clear;clf;
end