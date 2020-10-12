
function varargout = gui_afinador(varargin)
% GUI_AFINADOR MATLAB code for gui_afinador.fig
%      GUI_AFINADOR, by itself, creates a new GUI_AFINADOR or raises the existing
%      singleton*.
%
%      H = GUI_AFINADOR returns the handle to a new GUI_AFINADOR or the handle to
%      the existing singleton*.
%
%      GUI_AFINADOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_AFINADOR.M with the given input arguments.
%
%      GUI_AFINADOR('Property','Value',...) creates a new GUI_AFINADOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_afinador_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_afinador_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_afinador

% Last Modified by GUIDE v2.5 14-Nov-2019 22:38:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_afinador_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_afinador_OutputFcn, ...
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


% --- Executes just before gui_afinador is made visible.
function gui_afinador_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_afinador (see VARARGIN)

% Choose default command line output for gui_afinador
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_afinador wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_afinador_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
op=get(handles.popupmenu1,'Value');



%Variables
Fs = 44100; %frecuencia natural
dt = 1/Fs;
nBits = 16 ; 
nChannels = 2 ; 
ID = -1; % default audio input device 

bandera=true;

while (bandera)
    %Grabamos el audio
    recObj = audiorecorder(Fs,nBits,nChannels,ID);
    disp('Inicia Grabación.')
    recordblocking(recObj,2); %grabar cada 2 sg
    disp('Finaliza Grabación.');
    %Obtenemos los datos de la grabación
    x = getaudiodata(recObj); %obtengo los datos grabados
    %Escribimos la grabación
    
    audiowrite('audio.wav',x,Fs);
    %Obtenemos los datos
   % x=getaudiodata(recObj);
    %plot(x);

    %Transformada de fourier
    y=x(:,1);%Usamos el canal uno
    t=(1:1:length(y))/Fs;
    t=t';
     axes(handles.axes1);
cla('reset');
  axes(handles.axes1);
    plot(t,y); 
    N = length(y);
    nFFT=2;
    while nFFT<N
        nFFT=nFFT*2;
    end
    P1=abs(fft(y,nFFT));%Transformada de Fourier (Eje Y)
    f1=linspace(0,Fs,nFFT);%Eje X(Espacio muestral de frecuencias)
    %La ubicación donde se encuentra la potencia máxima
    [recObj,k]=max(P1);
    %La frecuencia de la potencia máxima
    fn=f1(k);

    %Según selección
    disp('Resultado: ')
    switch op
        case 2
            freq=329.628;
            error = ((fn-329.63)/329.63)*100
        case 3
            freq=246.942;
            error = ((fn-246.94)/246.94)*100
        case 4
            freq=195.998; 
            error = ((fn-196.00)/196.00)*100
        case 5
            freq=146.832;
            error = ((fn-146.83)/146.83)*100
        case 6
            freq=220;
            error = ((fn-220.00)/220.00)*100
        case 7
            freq=164.814;
            error = ((fn-164.81)/164.81)*100
    end

    if(error>0.5)
       set(handles.text3,'String','Aflojar')
        disp('Aflojar...');
    end
    if(error<-0.5)
        set(handles.text3,'String','Ajustar')
        disp('Ajustar...');
    end
    if(error>-0.5 && error<0.5)
        set(handles.text3,'String','Afinado')
        disp('...Listo Afinado...');
        bandera=false;
    end
end

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


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --------------------------------------------------------------------
function uibuttongroup1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
