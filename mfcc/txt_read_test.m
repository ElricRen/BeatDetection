beat_data=txt_read('E:/±ÏÉè/train_beat/train1.txt',100);
for i=1:size(beat_data)
    disp(sprintf('data: %f',beat_data{i,1}));
end