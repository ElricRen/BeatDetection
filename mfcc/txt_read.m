function beat_data=txt_read(txt_input,row)
if row<0
    row=100;
end
beat_data=cell(row,1);
fid=fopen(txt_input,'r');
for i=1:row
    beat_data{i,1}=fscanf(fid,'%s',[1,1]);
end
fclose(fid);

for i=1:row
    beat_data{i,1}=str2num(beat_data{i,1});
end