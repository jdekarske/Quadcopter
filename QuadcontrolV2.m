function varargout = QuadcontrolV2(varargin)
% QUADCONTROLV2 MATLAB code for QuadcontrolV2.fig
%      QUADCONTROLV2, by itself, creates a new QUADCONTROLV2 or raises the existing
%      singleton*.
%
%      H = QUADCONTROLV2 returns the handle to a new QUADCONTROLV2 or the handle to
%      the existing singleton*.
%
%      QUADCONTROLV2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUADCONTROLV2.M with the given input arguments.
%
%      QUADCONTROLV2('Property','Value',...) creates a new QUADCONTROLV2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QuadcontrolV2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QuadcontrolV2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QuadcontrolV2

% Last Modified by GUIDE v2.5 30-Aug-2017 12:28:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @QuadcontrolV2_OpeningFcn, ...
    'gui_OutputFcn',  @QuadcontrolV2_OutputFcn, ...
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


% --- Executes just before QuadcontrolV2 is made visible.
function QuadcontrolV2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QuadcontrolV2 (see VARARGIN)

% Choose default command line output for QuadcontrolV2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global abort axes1 axes2 c lasttime abortbtn motorsonbtn m1 m2 m3 m4 increment slist tm1 tm2 tm3 tm4 lastPerror lastAerror Aerrsum Perrsum saved count
%initialize everything here:
saved = 1;
count=0;
lastPerror = [0 0;0 0;0 0];
lastAerror = [0 0;0 0;0 0];
Perrsum = 0;
Aerrsum = 0;
abort = 0;
tm1 = handles.tm1;
tm2 = handles.tm2;
tm3 = handles.tm3;
tm4 = handles.tm4;
abortbtn = handles.abortbtn;
motorsonbtn = handles.motorsonbtn;
slist = seriallist;
increment = 4;
m1 = 1000;
m2 = 1000;
m3 = 1000;
m4 = 1000;
lasttime = 0;
c = natnet;
%c.ClientIP = '127.0.0.1';
%c.HostIP = '127.0.0.1';
c.ConnectionType = 'Multicast';
c.connect
axes1 = plot3(handles.axes1,0,0,0, 'ko');
xlabel(handles.axes1,'Desk');
ylabel(handles.axes1,'Door');
grid(handles.axes1);
axis(handles.axes1,[-2 2 -3 0 0 2]);
axes2 = bar(handles.axes2,[1000; 1000; 1000; 1000], 'BaseValue', 1000);
axis(handles.axes2,[0 5 1200 1800]);
c.addlistener( 1 , 'ControlCallbackV2' );
c.IsReporting = 1;
% UIWAIT makes QuadcontrolV2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = QuadcontrolV2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function xin_Callback(hObject, eventdata, handles)
% hObject    handle to xin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xin as text
%        str2double(get(hObject,'String')) returns contents of xin as a double


% --- Executes during object creation, after setting all properties.
function xin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yin_Callback(hObject, eventdata, handles)
% hObject    handle to yin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yin as text
%        str2double(get(hObject,'String')) returns contents of yin as a double


% --- Executes during object creation, after setting all properties.
function yin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zin_Callback(hObject, eventdata, handles)
% hObject    handle to zin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zin as text
%        str2double(get(hObject,'String')) returns contents of zin as a double


% --- Executes during object creation, after setting all properties.
function zin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in go.
function go_Callback(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xc yc zc rbx rby rbz axes1;
xc = str2double(get(handles.X,'String'));
yc = str2double(get(handles.Y,'String'));
zc = str2double(get(handles.Z,'String'));
set(axes1,'XData',[rbx xc]','YData',[rby yc]','ZData',[rbz zc]');
drawnow

% --- Executes on button press in enable.
function enable_Callback(hObject, eventdata, handles)
% hObject    handle to enable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global c abort abortbtn motorsonbtn
c.enable(0)
abort = 1;
set(abortbtn,'Enable', 'Off')
set(motorsonbtn,'Enable', 'On')

% --- Executes on button press in disable.
function disable_Callback(hObject, eventdata, handles)
% hObject    handle to disable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global c abort abortbtn motorsonbtn
c.disable(0);
abort = 1;
set(abortbtn,'Enable', 'Off')
set(motorsonbtn,'Enable', 'Off')

% --- Executes on button press in abortbtn.
function abortbtn_Callback(hObject, eventdata, handles)
% hObject    handle to abortbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global m1 m2 m3 m4 abort abortbtn motorsonbtn possave anglesave
abort = 1;
disp([num2str(round(m1))," ",num2str(round(m2))," ",num2str(round(m3))," ",num2str(round(m4))]);
set(abortbtn,'Enable', 'Off')
set(motorsonbtn,'Enable', 'On')
setspeed()
save('log.mat','possave', 'anglesave', '-append');


% --- Executes on button press in openserial.
function openserial_Callback(hObject, eventdata, handles)
% hObject    handle to openserial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s comport slist
s = serial(slist(comport), 'BAUD', 115200);
fopen(s);

% --- Executes on button press in closeserial.
function closeserial_Callback(hObject, eventdata, handles)
% hObject    handle to closeserial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s
fclose(s);

% --- Executes on selection change in serialmenu.
function serialmenu_Callback(hObject, eventdata, handles)
% hObject    handle to serialmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns serialmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from serialmenu
global comport
try
    comport = get(handles.serialmenu,'Value');
catch
    errordlg("Initializing COM ports doesn't work sometimes, please restart");
end

% --- Executes during object creation, after setting all properties.
function serialmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serialmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global slist
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
try
    set(hObject, 'String', slist);
catch
    errordlg("Initializing COM ports doesn't work sometimes, please restart");
end


% --- Executes on button press in motorsonbtn.
function motorsonbtn_Callback(hObject, eventdata, handles)
% hObject    handle to motorsonbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global abort abortbtn motorsonbtn saved possave anglesave
possave = [];
anglesave = [];
abort = 0;
saved = 0;
set(abortbtn,'Enable', 'On')
set(motorsonbtn,'Enable', 'Off')
