%% FitzHugh-Nagumo model GUI
% Master in Information Health Engineering
% Course 2019/2010
% Course: Biosignals and bioimages
% Gonzalo R. Ríos-Muñoz
% Code version 1.0 October 2019
% Universidad Carlos III de Madrid
%%
function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 08-Nov-2019 15:37:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)


% Initiating variables

% U panel variables
handles.et_coeff1 = 7;
handles.et_coeff2 = 1;
handles.et_coeff3 = 2;
handles.et_coeff4 = -0.7;

handles.et_noise_mean = 0;
handles.et_noise_var = 0.5;


% V panel variables
handles.et_a = 2.5;
handles.et_b = 20;
handles.et_c = 0.5;
handles.et_d = 30;

handles.et_r = 1;

% General variables
handles.et_T = 5e-3; % In seconds
handles.et_S = 2e-2; % In cm
handles.et_D = handles.et_S^2; % In cm^2
handles.et_F = 20;
handles.et_tf = 15; % In seconds
handles.et_FT = 5; % Forcing signal period

% Simulation variables
handles.simulating = 0;

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_a_Callback(hObject, eventdata, handles)
% hObject    handle to et_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_a as text
%        str2double(get(hObject,'String')) returns contents of et_a as a double

% Update handles value
handles.et_a = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function et_b_Callback(hObject, eventdata, handles)
% hObject    handle to et_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_b as text
%        str2double(get(hObject,'String')) returns contents of et_b as a double

% Update handles value
handles.et_b = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_c_Callback(hObject, eventdata, handles)
% hObject    handle to et_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_c as text
%        str2double(get(hObject,'String')) returns contents of et_c as a double

% Update handles value
handles.et_c = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_d_Callback(hObject, eventdata, handles)
% hObject    handle to et_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_d as text
%        str2double(get(hObject,'String')) returns contents of et_d as a double

% Update handles value
handles.et_d = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function et_noise_var_Callback(hObject, eventdata, handles)
% hObject    handle to et_noise_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_noise_var as text
%        str2double(get(hObject,'String')) returns contents of et_noise_var as a double

% Update handles value
handles.et_noise_var = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_noise_var_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_noise_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_noise_mean_Callback(hObject, eventdata, handles)
% hObject    handle to et_noise_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_noise_mean as text
%        str2double(get(hObject,'String')) returns contents of et_noise_mean as a double

% Update handles value
handles.et_noise_mean = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_noise_mean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_noise_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_coeff4_Callback(hObject, eventdata, handles)
% hObject    handle to et_coeff4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_coeff4 as text
%        str2double(get(hObject,'String')) returns contents of et_coeff4 as a double

% Update handles value
handles.et_coeff4 = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_coeff4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_coeff4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_coeff3_Callback(hObject, eventdata, handles)
% hObject    handle to et_coeff3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_coeff3 as text
%        str2double(get(hObject,'String')) returns contents of et_coeff3 as a double

% Update handles value
handles.et_coeff3 = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_coeff3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_coeff3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_coeff2_Callback(hObject, eventdata, handles)
% hObject    handle to et_coeff2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_coeff2 as text
%        str2double(get(hObject,'String')) returns contents of et_coeff2 as a double

% Update handles value
handles.et_coeff2 = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_coeff2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_coeff2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_coeff1_Callback(hObject, eventdata, handles)
% hObject    handle to et_coeff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_coeff1 as text
%        str2double(get(hObject,'String')) returns contents of et_coeff1 as a double

% Update handles value
handles.et_coeff1 = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_coeff1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_coeff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_T_Callback(hObject, eventdata, handles)
% hObject    handle to et_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_T as text
%        str2double(get(hObject,'String')) returns contents of et_T as a double

% Update handles value
handles.et_T = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_S_Callback(hObject, eventdata, handles)
% hObject    handle to et_S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_S as text
%        str2double(get(hObject,'String')) returns contents of et_S as a double

% Update handles value
handles.et_S = str2double(get(hObject,'String'));
handles.et_D = str2double(get(hObject,'String'))^2;

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_F_Callback(hObject, eventdata, handles)
% hObject    handle to et_F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_F as text
%        str2double(get(hObject,'String')) returns contents of et_F as a double

% Update handles value
handles.et_F = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_F_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_tf_Callback(hObject, eventdata, handles)
% hObject    handle to et_tf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_tf as text
%        str2double(get(hObject,'String')) returns contents of et_tf as a double

% Update handles value
handles.et_tf = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_tf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_tf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function et_r_Callback(hObject, eventdata, handles)
% hObject    handle to et_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_r as text
%        str2double(get(hObject,'String')) returns contents of et_r as a double

% Update handles value
handles.et_r = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_simulate.
function pb_simulate_Callback(hObject, eventdata, handles)
% hObject    handle to pb_simulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pb_simulate_handle = handles.pb_simulate;
handles.simulating = 1;

set(handles.pb_stop, 'Enable', 'on')

% Update handles structure
guidata(hObject, handles);

% Retrieving values

% V parameters
a = handles.et_a;
b = handles.et_b;
c = handles.et_c;
d = handles.et_d;
    
r = handles.et_r;

% U parameters
%speed = handles.et_speed;
noise_mean = handles.et_noise_mean;
noise_var = handles.et_noise_var;

coeff = [ handles.et_coeff1, handles.et_coeff2, handles.et_coeff3, handles.et_coeff4].*5./(r^4);

T = handles.et_T;
S = handles.et_S;
D = handles.et_D;
F = handles.et_F;
tf = handles.et_tf;
FT = handles.et_FT;

% Forcing signal
tF0 = 1;
Nt = tf/T;
Fs = forcing_signal(F, tF0, FT, T, Nt);

% Calculate FitzHugh-Nagumo equations
aux_U = -0.6;
aux_V = 36;
U_t = zeros(1,Nt);
U_t(1) = aux_U;
V_t = U_t;

t_ref = 0:T:(Nt-1)*T;

axes(handles.fig_equations)
cla(handles.fig_equations)

% V-nullcline
S01_calculate_V_nullcline;

% U-nullcline
S02_calculate_U_nullcline;

% Solving equations
S03_solve_Equations;

set(handles.pb_stop, 'Enable', 'off')
pb_simulate_string = 'Run Simulation';
set(pb_simulate_handle,'String', pb_simulate_string);

% --- Executes on button press in pb_reset.
function pb_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pb_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcbf)
GUI;


% --- Executes on button press in pb_stop.
function pb_stop_Callback(hObject, eventdata, handles)
% hObject    handle to pb_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

is_simulating = handles.simulating;
if is_simulating == 1
    
    handles.simulating = 0;
    % Update handles structure
    guidata(hObject, handles);
    
end

function et_FT_Callback(hObject, eventdata, handles)
% hObject    handle to et_FT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_FT as text
%        str2double(get(hObject,'String')) returns contents of et_FT as a double
% Update handles value
handles.et_FT = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function et_FT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_FT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
