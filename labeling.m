function varargout = labeling(varargin)
% LABELING MATLAB code for labeling.fig
%      LABELING, by itself, creates a new LABELING or raises the existing
%      singleton*.
%
%      H = LABELING returns the handle to a new LABELING or the handle to
%      the existing singleton*.
%
%      LABELING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABELING.M with the given input arguments.
%
%      LABELING('Property','Value',...) creates a new LABELING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before labeling_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to labeling_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help labeling

% Last Modified by GUIDE v2.5 08-Jan-2017 20:50:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @labeling_OpeningFcn, ...
    'gui_OutputFcn',  @labeling_OutputFcn, ...
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

% --- Executes just before labeling is made visible.
function labeling_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to labeling (see VARARGIN)
global img_file_path
global labels

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % DEV OPTION - COMMENT!!!!    %
% img_file_path = './lena.jpg'; %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose default command line output for labeling
handles.output = hObject;

% Set image file path as the window title
set(hObject, 'Name', [img_file_path, ' - TSC Leishmaniosis Labeling App']);

% Save original window size for when restoring the its size
set(hObject,'Units', 'normalized');
handles.original_size = get(hObject, 'outerposition');

% Plot the selected image in 'main.m'
image = imread(img_file_path);
im_size = size(image);

% Initialize empty label matrix
labels = zeros(im_size(1:2), 'uint8');

imageHandle = imshow(image);
set(imageHandle,'ButtonDownFcn',@ImageClickCallback);

% Update handles structure
guidata(hObject, handles);

% --- Executes when the image is clicked.
function ImageClickCallback ( objectHandle , eventData )
% This function opens a sub-window to select the type of parasite in the picture
global px_coordinates

axesHandle  = get(objectHandle,'Parent');

set(axesHandle, 'Units', 'Pixels');
coordinates = get(axesHandle,'CurrentPoint');
px_coordinates = floor(coordinates(1,1:2));

uiwait(label_select)

% --- Outputs from this function are returned to the command line.
function varargout = labeling_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in toggle_size.
function toggle_size_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% TODO: Fix -> When the image has been clicked, it does not restore or maximize
% properly

if isequal(get(get(hObject, 'Parent'), 'outerposition'), [0 0 1 1])
    % The window is maximized -> unmaximize
    set(get(hObject, 'Parent'),'Units', 'normalized', 'outerposition', handles.original_size);
    set(hObject, 'String', 'Maximize');
else
    % The window is not maximize -> maximize
    set(get(hObject, 'Parent'),'Units', 'normalized', 'outerposition',[0 0 1 1]);
    set(hObject, 'String', 'Restore');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEV OPTION - UNCOMMENT!!!! %
% Open main menu figure      %
main                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hint: delete(hObject) closes the figure
delete(hObject);
