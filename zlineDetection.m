function varargout = zlineDetection(varargin)
% ZLINEDETECTION MATLAB code for zlineDetection.fig
%      ZLINEDETECTION, by itself, creates a new ZLINEDETECTION or raises the existing
%      singleton*.
%
%      H = ZLINEDETECTION returns the handle to a new ZLINEDETECTION or the handle to
%      the existing singleton*.
%
%      ZLINEDETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZLINEDETECTION.M with the given input arguments.
%
%      ZLINEDETECTION('Property','Value',...) creates a new ZLINEDETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before zlineDetection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to zlineDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help zlineDetection

% Last Modified by GUIDE v2.5 05-Sep-2018 13:47:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @zlineDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @zlineDetection_OutputFcn, ...
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


% --- Executes just before zlineDetection is made visible.
function zlineDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to zlineDetection (see VARARGIN)

% Choose default command line output for zlineDetection
handles.output = hObject;

% Add directories that contain code 
addpath('functions');
addpath('functions/coherencefilter_version5b');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes zlineDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = zlineDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function guass_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to guass_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of guass_sigma as text
%        str2double(get(hObject,'String')) returns contents of guass_sigma as a double


% --- Executes during object creation, after setting all properties.
function guass_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to guass_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function orient_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to orient_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of orient_sigma as text
%        str2double(get(hObject,'String')) returns contents of orient_sigma as a double


% --- Executes during object creation, after setting all properties.
function orient_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to orient_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function diffusion_time_Callback(hObject, eventdata, handles)
% hObject    handle to diffusion_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diffusion_time as text
%        str2double(get(hObject,'String')) returns contents of diffusion_time as a double


% --- Executes during object creation, after setting all properties.
function diffusion_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diffusion_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noise_area_Callback(hObject, eventdata, handles)
% hObject    handle to noise_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise_area as text
%        str2double(get(hObject,'String')) returns contents of noise_area as a double


% --- Executes during object creation, after setting all properties.
function noise_area_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tophat_size_Callback(hObject, eventdata, handles)
% hObject    handle to tophat_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tophat_size as text
%        str2double(get(hObject,'String')) returns contents of tophat_size as a double


% --- Executes during object creation, after setting all properties.
function tophat_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tophat_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pix2um_Callback(hObject, eventdata, handles)
% hObject    handle to pix2um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pix2um as text
%        str2double(get(hObject,'String')) returns contents of pix2um as a double


% --- Executes during object creation, after setting all properties.
function pix2um_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pix2um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in disp_df.
function disp_df_Callback(hObject, eventdata, handles)
% hObject    handle to disp_df (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_df


% --- Executes on button press in disp_tophat.
function disp_tophat_Callback(hObject, eventdata, handles)
% hObject    handle to disp_tophat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_tophat


% --- Executes on button press in disp_nonoise.
function disp_nonoise_Callback(hObject, eventdata, handles)
% hObject    handle to disp_nonoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_nonoise


% --- Executes on button press in disp_bw.
function disp_bw_Callback(hObject, eventdata, handles)
% hObject    handle to disp_bw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_bw


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gloabl_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to gloabl_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gloabl_thresh as text
%        str2double(get(hObject,'String')) returns contents of gloabl_thresh as a double


% --- Executes during object creation, after setting all properties.
function gloabl_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gloabl_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function branch_size_Callback(hObject, eventdata, handles)
% hObject    handle to branch_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of branch_size as text
%        str2double(get(hObject,'String')) returns contents of branch_size as a double


% --- Executes during object creation, after setting all properties.
function branch_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to branch_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RUN_dir.
function RUN_dir_Callback(hObject, eventdata, handles)
% hObject    handle to RUN_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Store all of the inputs from the GUI in the structural array called
% settings 
settings = getGUIsettings(handles); 

% Select image files and run analysis.
runDirectory( settings );

% --- Executes on button press in tf_OOP.
function tf_OOP_Callback(hObject, eventdata, handles)
% hObject    handle to tf_OOP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tf_OOP

function dp_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to dp_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dp_threshold as text
%        str2double(get(hObject,'String')) returns contents of dp_threshold as a double

% --- Executes during object creation, after setting all properties.
function dp_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dp_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tf_CZL.
function tf_CZL_Callback(hObject, eventdata, handles)
% hObject    handle to tf_CZL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tf_CZL


% --- Executes on button press in rec_params.
function rec_params_Callback(hObject, eventdata, handles)
% hObject    handle to rec_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%If the user would like parameters recommended to them based on the pixel
%to micron conversion then calculate them. 


% --- Executes on selection change in cardio_type.
function cardio_type_Callback(hObject, eventdata, handles)
% hObject    handle to cardio_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cardio_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cardio_type


% --- Executes during object creation, after setting all properties.
function cardio_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cardio_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in disp_skel.
function disp_skel_Callback(hObject, eventdata, handles)
% hObject    handle to disp_skel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_skel
