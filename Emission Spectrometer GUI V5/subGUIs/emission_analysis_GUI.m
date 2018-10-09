function varargout = emission_analysis_GUI(varargin)
% EMISSION_ANALYSIS_GUI MATLAB code for emission_analysis_GUI.fig
%      EMISSION_ANALYSIS_GUI, by itself, creates a new EMISSION_ANALYSIS_GUI or raises the existing
%      singleton*.
%
%      H = EMISSION_ANALYSIS_GUI returns the handle to a new EMISSION_ANALYSIS_GUI or the handle to
%      the existing singleton*.
%
%      EMISSION_ANALYSIS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EMISSION_ANALYSIS_GUI.M with the given input arguments.
%
%      EMISSION_ANALYSIS_GUI('Property','Value',...) creates a new EMISSION_ANALYSIS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before emission_analysis_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to emission_analysis_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help emission_analysis_GUI

% Last Modified by GUIDE v2.5 28-Mar-2018 15:19:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @emission_analysis_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @emission_analysis_GUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before emission_analysis_GUI is made visible.
function emission_analysis_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to emission_analysis_GUI (see VARARGIN)

%load data from main GUI
h = findobj('Tag','Emission_spectrometer_GUI');

% if exists (not empty)
if ~isempty(h)
    % get handles and other user-defined data associated to Gui1
    main_GUI_data = guidata(h);
    
end

%Set file index and initial file
file_idx=1;
file_list=main_GUI_data.file_list;

%Generate file name
PMT_short_file=[file_list{file_idx} '_short.txt.'];

%make sure data block is large enough to load
if size(main_GUI_data.main_data_table,2)<20
    main_GUI_data.main_data_table{1,20}=[];
end

%Set table data
handles.data_table.Data=main_GUI_data.central_table.Data(:,[1,7]);
handles.data_table.Data(:,[3,4])=main_GUI_data.main_data_table(:,[16,17]);

%Set current plot
handles.selected_file_txt.String=main_GUI_data.file_list{file_idx};

%%%Initialize Plots%%%
%Generate data
%import necessary data
if sum(cellfun('isempty',main_GUI_data.main_data_table(1,[5,6])))==0;
    time=main_GUI_data.main_data_table{file_idx,5};
    radiance=main_GUI_data.main_data_table{file_idx,6};
        
else
    time=zeros(1,1e2);
    radiance=zeros(1,1e2);
   
end

%Initialize data markers
tmarker=[0 0];
rmarker=[0 0];

%initialize plots with real data
figure(handles.emission_analysis_GUI_bkg);
handles.rad_sub=subplot('Position',[0.25,0.15 0.70 0.80]);
handles.rad_plot=semilogx(time,radiance,'k',tmarker,rmarker,'or');

%adjust plot windows
ylabel(handles.rad_sub,'radiance (W/sr \cdot m^2)');
xlabel(handles.rad_sub,'time (s)');
xlim(handles.rad_sub,[1e-9 1e-5]);

%initialize close function
handles.decision=3;

% Update main GUI
handles.output = hObject;
handles.main_GUI_data=main_GUI_data;
handles.file_idx=file_idx;
handles.PMT_short_file=PMT_short_file;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes emission_analysis_GUI wait for user response (see UIRESUME)
% uiwait(handles.emission_analysis_GUI_bkg);


% --- Outputs from this function are returned to the command line.
function varargout = emission_analysis_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function data_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%initialize table
set(hObject,'Data',cell(1,4));
set(hObject, 'ColumnName', {'shot #','radiance','rise time (ns)','FWHM (ns)'});
set(hObject, 'ColumnFormat',{'numeric','logical','numeric','numeric'});


% --- Executes when selected cell(s) is changed in data_table.
function data_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to data_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
file_list=handles.main_GUI_data.file_list;

try
    selected_cells=eventdata.Indices(1);
    
    %Move to the file in the list which was selected
    file_idx=selected_cells;
    
    %Generate file name
    PMT_short_file=[file_list{file_idx} '_short.txt.'];
    
    %Set display
    set(handles.selected_file_txt,'String',file_list{file_idx});
    
        
        %retreive data for replotting
        if sum(cellfun('isempty',handles.main_GUI_data.main_data_table(1,[5,6])))==0;
            time=handles.main_GUI_data.main_data_table{file_idx,5};
            radiance=handles.main_GUI_data.main_data_table{file_idx,6};
            
        else
            time=zeros(1,1e2);
            radiance=zeros(1,1e2);
        end
        
        %update plots
        handles.rad_plot(1).XData= time;handles.rad_plot(1).YData = radiance;    
        handles.rad_plot(2).XData= [0];handles.rad_plot(2).YData = [0];

        
    handles.file_idx=file_idx;
    handles.PMT_short_file=PMT_short_file;
    guidata(hObject,handles);
catch
end


% --- Executes when user attempts to close emission_analysis_GUI_bkg.
function emission_analysis_GUI_bkg_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to emission_analysis_GUI_bkg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.decision]=GUI_pass;

switch handles.decision
    case 1
        main_GUI=findobj('Tag','Emission_spectrometer_GUI');
        guidata(main_GUI,handles.main_GUI_data);
        delete(handles.emission_analysis_GUI_bkg);
    case 2
        delete(handles.emission_analysis_GUI_bkg);
    case 3
end


% --------------------------------------------------------------------
function save_close_Callback(hObject, eventdata, handles)
% hObject    handle to save_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Grab fits
%Get data to be saved
parent_p=handles.main_GUI_data.parent_p;file_list=handles.main_GUI_data.file_list;

data_block=handles.main_GUI_data.main_data_table(:,[1,16,17]);

%make sure data block is large enough to load
if size(data_block,2)<20
    data_block{1,20}=[];
end

%Save just rise time and full width
save_flag=6;

%Prompt for file name
prompt={'Enter file save name'};
dlg_title='Saved file name';
name=[cell2mat(inputdlg(prompt,dlg_title))];

text_name=[name,' derived emission data.txt'];

save_with_flags_v5(parent_p,file_list,data_block,text_name,save_flag);

main_GUI=findobj('Tag','Emission_spectrometer_GUI');
guidata(main_GUI,handles.main_GUI_data);
delete(handles.emission_analysis_GUI_bkg);


% --------------------------------------------------------------------
function save_no_close_Callback(hObject, eventdata, handles)
% hObject    handle to save_no_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Get data to be saved
parent_p=handles.main_GUI_data.parent_p;file_list=handles.main_GUI_data.file_list;

data_block=handles.main_GUI_data.main_data_table(:,[1,16,17]);

%make sure data block is large enough to load
if size(data_block,2)<20
    data_block{1,20}=[];
end

%Save just rise time and full width
save_flag=6;

%Prompt for file name
prompt={'Enter file save name'};
dlg_title='Saved file name';
name=[cell2mat(inputdlg(prompt,dlg_title))];

text_name=[name,' derived emission data.txt'];

save_with_flags_v5(parent_p,file_list,data_block,text_name,save_flag);



% --------------------------------------------------------------------
function pass_close_Callback(hObject, eventdata, handles)
% hObject    handle to pass_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
main_GUI=findobj('Tag','Emission_spectrometer_GUI');
guidata(main_GUI,handles.main_GUI_data);1
delete(handles.emission_analysis_GUI_bkg);


% --------------------------------------------------------------------
function rise_header_Callback(hObject, eventdata, handles)
% hObject    handle to rise_header (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FWHM_header_Callback(hObject, eventdata, handles)
% hObject    handle to FWHM_header (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function fwhm_single_Callback(hObject, eventdata, handles)
% hObject    handle to fwhm_single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_idx=handles.file_idx;
file_list=handles.main_GUI_data.file_list;

%Update current shot
set(handles.selected_file_txt,'String',file_list{file_idx});

%Generate data
%import necessary data
if sum(cellfun('isempty',handles.main_GUI_data.main_data_table(file_idx,[5,6])))==0;
    time=handles.main_GUI_data.main_data_table{file_idx,5};
    radiance=handles.main_GUI_data.main_data_table{file_idx,6};
    
else
    time=zeros(1,1e2);
    radiance=zeros(1,1e2);
    
end

%Turn off warning about negative data
warning('off','MATLAB:Axes:NegativeDataInLogAxis');


%update plots
handles.rad_plot(1).XData= time;handles.rad_plot(1).YData = radiance;

[time_bounds ~]=ginput(2);

[~, l_bound] = min(abs(time-time_bounds(1))); %closest index for lower time bound
[~, r_bound] = min(abs(time-time_bounds(2))); %closest index for higher time bound

[max_value ~]=max(radiance(l_bound:r_bound));

time_interp=linspace(time(l_bound),time(r_bound),5000);
radiance_interp=spline(time,radiance,time_interp);

low_idx=find(radiance_interp>=max_value*0.5,1,'first');
high_idx=find(radiance_interp>=max_value*0.5,1,'last');

fwhm=time_interp(high_idx)-time_interp(low_idx);

%update plots
handles.rad_plot(2).XData= [time_interp(low_idx), time_interp(high_idx)];
handles.rad_plot(2).YData = [radiance_interp(low_idx),radiance_interp(high_idx)];

%update tables
handles.data_table.Data{file_idx,4}=fwhm*1e9;
handles.main_GUI_data.main_data_table{file_idx,17}=fwhm*1e9;

guidata(hObject,handles);


% --------------------------------------------------------------------
function fwhm_all_Callback(hObject, eventdata, handles)
% hObject    handle to fwhm_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_list=handles.main_GUI_data.file_list;


%loop
for idx=1:length(file_list)
    
    if handles.data_table.Data{idx,2}=='True'
        
        %Update current shot
        set(handles.selected_file_txt,'String',file_list{idx});
        
        %Generate data
        %import necessary data
        if sum(cellfun('isempty',handles.main_GUI_data.main_data_table(idx,[5,6])))==0;
            time=handles.main_GUI_data.main_data_table{idx,5};
            radiance=handles.main_GUI_data.main_data_table{idx,6};
            
        else
            time=zeros(1,1e2);
            radiance=zeros(1,1e2);
            
        end
        
        %Turn off warning about negative data
        warning('off','MATLAB:Axes:NegativeDataInLogAxis');
        
        
        %update plots
        handles.rad_plot(1).XData= time;handles.rad_plot(1).YData = radiance;
        
        if idx==1
            
            [time_bounds ~]=ginput(2);
            
            [~, l_bound] = min(abs(time-time_bounds(1))); %closest index for lower time bound
            [~, r_bound] = min(abs(time-time_bounds(2))); %closest index for higher time bound
            
        end
        
        [max_value ~]=max(radiance(l_bound:r_bound));
        
        time_interp=linspace(time(l_bound),time(r_bound),5000);
        radiance_interp=spline(time,radiance,time_interp);
        
        low_idx=find(radiance_interp>=max_value*0.5,1,'first');
        high_idx=find(radiance_interp>=max_value*0.5,1,'last');
        
        fwhm=time_interp(high_idx)-time_interp(low_idx);
        
        %update plots
        handles.rad_plot(2).XData= [time_interp(low_idx), time_interp(high_idx)];
        handles.rad_plot(2).YData = [radiance_interp(low_idx),radiance_interp(high_idx)];
        
        %update tables
        handles.data_table.Data{idx,4}=fwhm*1e9;
        handles.main_GUI_data.main_data_table{idx,17}=fwhm*1e9;
        
        drawnow
        pause(0.25);
    end
    
end


guidata(hObject,handles);

% --------------------------------------------------------------------
function rise_single_Callback(hObject, eventdata, handles)
% hObject    handle to rise_single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_idx=handles.file_idx;
file_list=handles.main_GUI_data.file_list;

%Update current shot
set(handles.selected_file_txt,'String',file_list{file_idx});

%Generate data
%import necessary data
if sum(cellfun('isempty',handles.main_GUI_data.main_data_table(file_idx,[5,6])))==0;
    time=handles.main_GUI_data.main_data_table{file_idx,5};
    radiance=handles.main_GUI_data.main_data_table{file_idx,6};
    
else
    time=zeros(1,1e2);
    radiance=zeros(1,1e2);
    
end

%Turn off warning about negative data
warning('off','MATLAB:Axes:NegativeDataInLogAxis');


%update plots
handles.rad_plot(1).XData= time;handles.rad_plot(1).YData = radiance;

[time_bounds ~]=ginput(2);

[~, l_bound] = min(abs(time-time_bounds(1))); %closest index for lower time bound
[~, r_bound] = min(abs(time-time_bounds(2))); %closest index for higher time bound

[max_value ~]=max(radiance(l_bound:r_bound));

time_interp=linspace(time(l_bound),time(r_bound),5000);
radiance_interp=spline(time,radiance,time_interp);

low_idx=find(radiance_interp>=max_value*0.1,1,'first');
high_idx=find(radiance_interp>=max_value*0.9,1,'first');

rising_edge=time_interp(high_idx)-time_interp(low_idx);

%update plots
handles.rad_plot(2).XData= [time_interp(low_idx), time_interp(high_idx)];
handles.rad_plot(2).YData = [radiance_interp(low_idx),radiance_interp(high_idx)];

%update tables
handles.data_table.Data{file_idx,3}=rising_edge*1e9;
handles.main_GUI_data.main_data_table{file_idx,16}=rising_edge*1e9;

guidata(hObject,handles);


% --------------------------------------------------------------------
function rise_all_Callback(hObject, eventdata, handles)
% hObject    handle to rise_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_list=handles.main_GUI_data.file_list;

%loop
for idx=1:length(file_list)
    
    if handles.data_table.Data{idx,2}=='True'
        
        %Update current shot
        set(handles.selected_file_txt,'String',file_list{idx});
        
        %Generate data
        %import necessary data
        if sum(cellfun('isempty',handles.main_GUI_data.main_data_table(idx,[5,6])))==0;
            time=handles.main_GUI_data.main_data_table{idx,5};
            radiance=handles.main_GUI_data.main_data_table{idx,6};
            
        else
            time=zeros(1,1e2);
            radiance=zeros(1,1e2);
            
        end
        
        %Turn off warning about negative data
        warning('off','MATLAB:Axes:NegativeDataInLogAxis');
        
        
        %update plots
        handles.rad_plot(1).XData= time;handles.rad_plot(1).YData = radiance;
        
        if idx==1
            
            [time_bounds ~]=ginput(2);
            
            [~, l_bound] = min(abs(time-time_bounds(1))); %closest index for lower time bound
            [~, r_bound] = min(abs(time-time_bounds(2))); %closest index for higher time bound
            
        end
        
        [max_value ~]=max(radiance(l_bound:r_bound));
        
        time_interp=linspace(time(l_bound),time(r_bound),5000);
        radiance_interp=spline(time,radiance,time_interp);
        
        low_idx=find(radiance_interp>=max_value*0.1,1,'first');
        high_idx=find(radiance_interp>=max_value*0.9,1,'first');
        
        rising_edge=time_interp(high_idx)-time_interp(low_idx);
        
        %update plots
        handles.rad_plot(2).XData= [time_interp(low_idx), time_interp(high_idx)];
        handles.rad_plot(2).YData = [radiance_interp(low_idx),radiance_interp(high_idx)];
        
        handles.data_table.Data{idx,3}=rising_edge*1e9;
        handles.main_GUI_data.main_data_table{idx,16}=rising_edge*1e9;
        
        drawnow
        pause(0.25);
    end
    
end


guidata(hObject,handles);
