function peak=peak_dect2(diff,c1,c2)

frame_num=size(diff,1);
max_diff=max(diff);
init_threshold=c1*max_diff;
peak=zeros(frame_num,1);
m=10;
n=20;
sum_local=sum(diff(1:2*m+1));
for k=1:frame_num
    
    if diff(k)>init_threshold
        peak(k)=max_diff;
    else
        peak(k)=diff(k);
    end
    
    if k<=m+1 || k>frame_num-m
        peak(k)=peak(k)/sum_local;
    else
        sum_local=sum_local+diff(k+m)-diff(k-m-1);
        %sum_local=sum(diff(k-m:k+m));
        peak(k)=peak(k)/sum_local;
    end
end

diff=peak;
peak(:)=0;
%     find a peak
%      选择大于附近均值一定值的峰值
max_temp=0;
for k=2:frame_num-1
    
    if diff(k)>=diff(k-1) && diff(k)>=diff(k+1)
        peak(k)=diff(k);
        disp(sprintf('peak(k)=%f',peak(k)));
    end
    %   不处理峰值为零的情况
    if peak(k)==0
        continue;
    end
    %     get the threshold
    if k>n && k<frame_num-n
        temp_peak=median(diff(k-n:k+n));
        max_temp=max(diff(k-n:k+n));
    else if k<10
            temp_peak=median(diff(1:n));
            max_temp=max(diff(1:n));
        else
            temp_peak=median(diff(frame_num-n:frame_num));
            max_temp=max(diff(frame_num-n:frame_num));
        end
    end
    threshold=c2*(max_temp-temp_peak) +temp_peak;
    if peak(k)<threshold
        peak(k)=0;
    else
        peak(k)=diff(k);
    end
end