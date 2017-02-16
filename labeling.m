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

% Last Modified by GUIDE v2.5 16-Feb-2017 12:04:50

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
global regions
global active_region_type

active_region_type = '';

% Initialize labels as an empty cell array
labels = cell(0);

% Initialize regions as an empty cell array
regions = cell(0);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % DEV OPTION - COMMENT WHEN FINISHED!!!!         %
% img_file_path = './data/BCN877_72h_x20bf_3.jpg'; %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose default command line output for labeling
handles.output = hObject;

% Set image file path as the window title
set(hObject, 'Name', [img_file_path, ' - TSC Leishmaniosis Labeling App']);

% Save original window size for when restoring the its size
set(hObject,'Units', 'normalized');
handles.original_size = get(hObject, 'outerposition');

% Plot the selected image
image = imread(img_file_path);
imageHandle = imshow(image);

% Update handles structure
guidata(hObject, handles);

end


% --- Executes when the rectangle is double-clicked.
function ImageClickCallback ( objectHandle , eventData )
% This function opens a sub-window to select the type of parasite in the picture
global px_coordinates

axesHandle  = get(objectHandle,'Parent');

set(axesHandle, 'Units', 'Pixels');
coordinates = get(axesHandle,'CurrentPoint');
px_coordinates = floor(coordinates(1,1:2));

uiwait(label_select)

end


% --- Outputs from this function are returned to the command line.
function varargout = labeling_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end


% --- Executes on button press in toggle_size.
function toggle_size_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(get(hObject, 'Parent'),'Units', 'normalized')

if isequal(get(get(hObject, 'Parent'), 'outerposition'), [0 0 1 1])
    % The window is maximized -> unmaximize
    set(get(hObject, 'Parent'),'Units', 'normalized', 'outerposition', handles.original_size);
    
    set(handles.axes1, 'Units', 'normalized', ...
        'outerposition', [-0.0986   -0.0234    1.1546    1.0061]);
    
    set(hObject, 'String', 'Maximize');
else
    % The window is not maximize -> maximize
    set(get(hObject, 'Parent'), 'Units', 'normalized', ...
        'outerposition',[0 0 1 1]);
    
    set(handles.axes1, 'Units', 'normalized', ...
        'outerposition', [-0.0986   -0.0234    1.1546    1.0061]);
    
    set(hObject, 'String', 'Restore');
end

end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEV OPTION - UNCOMMENT WHEN FINISHED!!!! %
% Open main menu figure                    %
main                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hint: delete(hObject) closes the figure
delete(hObject);

end


% --- Executes on button press in toggle_rectangle.
function toggle_rectangle_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_rectangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_rectangle

global rect_data
global regions
global active_region_type

active_region_type = 'rectangle';

fcn = makeConstrainToRectFcn( ...
    'imrect', ...
    handles.axes1.XLim, ...
    handles.axes1.YLim ...
    );

while get(hObject,'Value')
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'Off')
    
    l = size(regions,1) + 1;
    regions{l, 1} = imrect;
    
    setPositionConstraintFcn(regions{end,1},fcn);
    
    rect_data = wait(regions{end,1});
    
    % Launch label_select
    ImageClickCallback(handles.axes1)
    
    if ~isempty(rect_data)
        % Add color rectangle on top of the drawn one
        regions{l, 2} = rectangle(...
            'Position', rect_data, ...
            'LineWidth',2, ...
            'EdgeColor','g'...
            );
        
        % Callback for updating rectangle info when it is moved
        addNewPositionCallback(regions{end, 1},...
            (@(p) rectanglePositionCallback(p,l)) ...
            );
    end
    
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'On')
end

end

% --- Executes on when the user moves a rectangle.
function rectanglePositionCallback(rect_data, l)

global labels
global regions

% Update position of the color rectangle
set(regions{l,2}, 'Position', rect_data)

% Update rectangle position in labels cell array
labels{l}.x = rect_data(1);
labels{l}.y = rect_data(2);
labels{l}.width = rect_data(3);
labels{l}.height = rect_data(4);

end


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global labels
global img_file_path

% Get image path without extension
pattern = '.jpg';
replacement = '';
img_name = regexprep(img_file_path,pattern,replacement);

% TODO Try saving in UBJSON format
% Save labels to JSON file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEV - Activate compact when finished!!                                   %
savejson('', labels, 'FileName', [img_name,'_labels.json'], 'Compact', 1); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

helpdlg('Labels have been saved','Save success')
end


% --- Executes on button press in toggle_polygon.
function toggle_polygon_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_polygon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_polygon

global rect_data
global regions
global active_region_type

active_region_type = 'polygon';

fcn = makeConstrainToRectFcn( ...
    'impoly', ...
    handles.axes1.XLim, ...
    handles.axes1.YLim ...
    );

while get(hObject,'Value')
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'Off')
    
    l = size(regions,1) + 1;
    regions{l, 1} = impoly('Closed',true);
    
    api = iptgetapi(regions{end,1});
    api.setPositionConstraintFcn(fcn);
    
    rect_data = wait(regions{end,1});
    
    % Launch label_select
    ImageClickCallback(handles.axes1)
    
    if ~isempty(rect_data)
        % Set polygon colour
        api.setColor('green');
        
        % Callback for updating region info when it is moved
        addNewPositionCallback(regions{end, 1},...
            (@(p) polygonPositionCallback(p,l)) ...
            );
    end
    
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'On')
end

end

% --- Executes on when the user moves a polygon.
function polygonPositionCallback(rect_data, l)

global labels

% Update region position in labels cell array
labels{l}.Position = rect_data;

end


% --- Executes on button press in set_square.
function set_square_Callback(hObject, eventdata, handles)
% hObject    handle to set_square (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global rect_data
global regions
global active_region_type

% Check that rectangles are being selected and there is at least one selected
try
    assert(strcmp(active_region_type,'rectangle'),...
        'MATLAB:Rect:Unselected',...
        'This option is only available for rectangle regions')
    assert(size(regions,1) >= 1,...
        'MATLAB:Rect:No_rectangles', 'There are no rectangles to set square')
    
    position = getPosition(regions{end,1});

    max_dim = max(position(3:4));

    setPosition(regions{end,1}, [position(1:2),max_dim, max_dim])

catch MException
    helpdlg(MException.message,MException.identifier)
end

end
