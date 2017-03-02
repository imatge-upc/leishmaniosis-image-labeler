function varargout = main_menu(varargin)
% MAIN_MENU MATLAB code for main_menu.fig
%      MAIN_MENU, by itself, creates a new MAIN_MENU or raises the existing
%      singleton*.
%
%      H = MAIN_MENU returns the handle to a new MAIN_MENU or the handle to
%      the existing singleton*.
%
%      MAIN_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_MENU.M with the given input arguments.
%
%      MAIN_MENU('Property','Value',...) creates a new MAIN_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_menu

% Last Modified by GUIDE v2.5 02-Mar-2017 11:56:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @main_menu_OpeningFcn, ...
    'gui_OutputFcn',  @main_menu_OutputFcn, ...
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


% --- Executes just before main_menu is made visible.
function main_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_menu (see VARARGIN)

% Initialize selected image path
global img_file_path

img_file_path = '';

% Choose default command line output for main_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = main_menu_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_img.
function browse_img_Callback(hObject, eventdata, handles)
% hObject    handle to browse_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_file_path

% Display file selection UI. Default filter: JPEG images
[filename, pathname] = uigetfile( ...
    {'*.jpg;*.jpeg', 'Joint Photographic Experts Group (*.jpg, *.jpeg)';
    '*.*',  'All Files (*.*)';
    '*.png', 'Portable Network Graphics (*.png)';
    '*.bmp', 'Windows Bitmap (*.bmp)';
    '*.cur', 'Windows Cursor resources (*.cur)';
    '*.gif', 'Graphics Interchange Format (*.gif)';
    '*.hdf', 'Hierarchical Data Format (*.hdf)';
    '*.ico', 'Windows Icon resources (*.ico)';
    '*.pbm', 'Portable Bitmap (*.pbm)';
    '*.pcx', 'Windows Paintbrush (*.pcx)';
    '*.pgm', 'Portable Graymap (*.pgm)';
    '*.pnm', 'Portable Any Map (*.pnm)';
    '*.ppm', 'Portable Pixmap (*.ppm)';
    '*.ras', 'Sun Raster (*.ras)';
    '*.xwd', 'X Window Dump (*.xwd)';
    '*.jp2', 'JPEG 2000 (Part 1) (*.jp2)';
    '*.jpf;*.jpx', 'JPEG 2000 (Part 2) (*.jpf, *.jpx)';
    '*.j2c;*.j2k', 'JPEG 2000 (raw codestream) (*.j2c, *.j2k)';
    '*.tif;*.tiff', 'Tagged Image File Format (*.tif, *.tiff)';
    '*.fts;*.fits', 'Flexible Image Transport System (*.fts, *.fits)'}, ...
    'Select an image to label');

% Discern between whether the user has chosen an image or not
if strcmp(num2str(filename), '0') && strcmp(num2str(pathname), '0')
    % The user has cancelled. Display the already displayed text
    displayString = get(handles.img_path, 'String');
    
else
    % The user has selected an image. Display its path
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Code from Trogdor @ StackOverflow
    % http://stackoverflow.com/a/40159162/7390416
    % License: MIT License
    img_file_path = [pathname, filename];
    
    set(handles.img_path,'Units', 'Characters'); %set units to characters for convenience
    pos = get(handles.img_path,'Position'); %get the position info
    maxLength = floor(pos(3)) - 18; %extract the length of the box
    if length(img_file_path) > maxLength % cut beginning if string is too long
        newStart = length(img_file_path) - maxLength + 1;
        displayString = ['...',img_file_path(newStart:end)];
    else
        displayString = img_file_path;
    end
end

set(handles.img_path,'String', displayString);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);


function img_path_Callback(hObject, eventdata, handles)
% hObject    handle to img_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of img_path as text
%        str2double(get(hObject,'String')) returns contents of img_path as a double

% Set the image file path if the user writes it in the edit box
global img_file_path

img_file_path = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function img_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in openimage.
function openimage_Callback(hObject, eventdata, handles)
% hObject    handle to openimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img_file_path
global username

% Detect if an image has been selected
if ~strcmp(img_file_path, '')
    if numel(username) > 0
        % Open region_selection applet figure
        region_selection
        
        % Close this figure
        close(get(hObject, 'Parent'))
    else
        warndlg('Please, select a username before clicking the Open Image button', ...
        'No username selected')
    end
else
    warndlg('Please, select an image before clicking the Open Image button', ...
        'No image selected')
end



function edit_username_Callback(hObject, eventdata, handles)
% hObject    handle to edit_username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_username as text
%        str2double(get(hObject,'String')) returns contents of edit_username as a double
global username

username = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function edit_username_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global last_username

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


if numel(last_username) > 0
    set(hObject,'String', last_username);
end

function clearEditBox(hObj, event) %#ok<INUSD>

set(hObj, 'String', '', 'Enable', 'on');
uicontrol(hObj); % This activates the edit box and
% places the cursor in the box,
% ready for user input.


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit_username.
function edit_username_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit_username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Toggle the "Enable" state to ON

set(hObject, 'string', '');
set(hObject, 'Enable', 'On');

% Create UI control

uicontrol(handles.edit_username);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over img_path.
function img_path_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to img_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Toggle the "Enable" state to ON

set(hObject, 'string', '');
set(hObject, 'Enable', 'On');

% Create UI control

uicontrol(handles.img_path);
