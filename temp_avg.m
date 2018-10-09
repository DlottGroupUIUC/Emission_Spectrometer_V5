clear
clc

%Load files to analyze
[r,p]=uigetfile('*3.txt;*.tdms;*short.txt','multiselect','on');

%Make cell if only 1 file is selected
if ischar(r)==1
    disp(true)
    r={r};
end

for q=1:length(r)
    
    data=importdata(fullfile(p,r{q}));
    
    while size(data,1)>70
        
        data(1,:)=[];
        
    end
        
    data_3d(:,:,q)=data;
end

time=data_3d(:,1,:);
t=permute(time,[1,3,2]);

mean_data=mean(data_3d,3);

%Prompt for file name
prompt={'Enter file save name'};
dlg_title='Saved file name';
name=[cell2mat(inputdlg(prompt,dlg_title))];

text_name=[name,' avg_spec_rad_short.txt'];

dlmwrite(text_name,mean_data,' ');