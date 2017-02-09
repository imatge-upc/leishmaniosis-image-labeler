function varargout = label_select(varargin)
% LABEL_SELECT MATLAB code for label_select.fig
%      LABEL_SELECT, by itself, creates a new LABEL_SELECT or raises the existing
%      singleton*.
%
%      H = LABEL_SELECT returns the handle to a new LABEL_SELECT or the handle to
%      the existing singleton*.
%
%      LABEL_SELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABEL_SELECT.M with the given input arguments.
%
%      LABEL_SELECT('Property','Value',...) creates a new LABEL_SELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before label_select_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to label_select_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help label_select

% Last Modified by GUIDE v2.5 25-Jan-2017 20:12:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @label_select_OpeningFcn, ...
                   'gui_OutputFcn',  @label_select_OutputFcn, ...
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


% --- Executes just before label_select is made visible.
function label_select_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to label_select (see VARARGIN)

% Get current pointer location
pointer_pos(1,1:2)=get(0,'Pointerlocation');

% Choose default command line output for label_select
handles.output = hObject;

% Position the window at the current pointer's coordinates
set(hObject, 'Units', 'Pixels');
outer_position = get(hObject, 'OuterPosition');

selector_position = [pointer_pos(1),pointer_pos(2)-outer_position(4), outer_position(3:4)];
set(hObject, 'OuterPosition', selector_position);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = label_select_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in parasite_types.
function parasite_types_Callback(hObject, eventdata, handles)
% hObject    handle to parasite_types (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns parasite_types contents as cell array
%        contents{get(hObject,'Value')} returns selected item from parasite_types


% --- Executes during object creation, after setting all properties.
function parasite_types_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parasite_types (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
% hObject    handle to ok_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global labels
global rect_data
global rect_on
global poly_on

% Save label as the pop-up menu value
if get(handles.parasite_types, 'Value') <= length(get(handles.parasite_types, 'String'))
    % Parasite type selected -> add data to labels cell array
    if rect_on
        labels{length(labels) + 1} = struct(...
            'x', rect_data(1), ...
            'y', rect_data(2), ...
            'width', rect_data(3), ...
            'height', rect_data(4), ...
            'parasite_type', get(handles.parasite_types, 'Value'), ...
            'comments', get(handles.comments_textbox, 'String') ...
            );
    elseif poly_on
        labels{length(labels) + 1} = struct(...
            'Position', rect_data, ...
            'parasite_type', get(handles.parasite_types, 'Value'), ...
            'comments', get(handles.comments_textbox, 'String') ...
            );
    end
end

% Return to previous window
uiresume
delete(get(hObject, 'Parent'));


% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Return to previous window
uiresume
delete(get(hObject, 'Parent'));


function comments_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to comments_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of comments_textbox as text
%        str2double(get(hObject,'String')) returns contents of comments_textbox as a double

% --- Executes during object creation, after setting all properties.
function comments_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comments_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
