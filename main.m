function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 08-Jan-2017 17:53:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @main_OpeningFcn, ...
    'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Initialize selected image path
global img_file_path
img_file_path = '';

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles)
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

% Detect if an image has been selected
if ~strcmp(img_file_path, '')
    % Open labeling applet figure
    labeling
    
    % Close this figure
    close(get(hObject, 'Parent'))
else
    warndlg('Please, select an image before clicking the Open Image button', ...
        'No image selected')
end
