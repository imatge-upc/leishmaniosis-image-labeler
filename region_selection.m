function varargout = region_selection(varargin)
% REGION_SELECTION MATLAB code for region_selection.fig
%      REGION_SELECTION, by itself, creates a new REGION_SELECTION or raises the existing
%      singleton*.
%
%      H = REGION_SELECTION returns the handle to a new REGION_SELECTION or the handle to
%      the existing singleton*.
%
%      REGION_SELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGION_SELECTION.M with the given input arguments.
%
%      REGION_SELECTION('Property','Value',...) creates a new REGION_SELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before region_selection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to region_selection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help region_selection

% Last Modified by GUIDE v2.5 19-Feb-2017 15:46:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @region_selection_OpeningFcn, ...
                   'gui_OutputFcn',  @region_selection_OutputFcn, ...
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


% --- Executes just before region_selection is made visible.
function region_selection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to region_selection (see VARARGIN)
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

% Choose default command line output for region_selection
handles.output = hObject;

% Set image file path as the window title
set(hObject, 'Name', [img_file_path, ' - TSC Leishmaniosis Labeling App']);

% Save original window size for when restoring the its size
set(hObject,'Units', 'normalized');
handles.original_size = get(hObject, 'outerposition');

% Plot the selected image
myImage = imread(img_file_path);
axes(handles.image_axes);
imshow(myImage);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes region_selection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = region_selection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEV OPTION - UNCOMMENT WHEN FINISHED!!!! %
% Open main menu figure                    %
main_menu                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hint: delete(hObject) closes the figure
delete(hObject);

% --- Executes when a region is double-clicked.
function RegionSelectCallback ( objectHandle , eventData )
% This function opens a sub-window to select the type of parasite in the picture
global px_coordinates

axesHandle  = get(objectHandle,'Parent');

set(axesHandle, 'Units', 'Pixels');
coordinates = get(axesHandle,'CurrentPoint');
px_coordinates = floor(coordinates(1,1:2));

uiwait(label_selection)


% --- Executes on button press in toggle_size.
function toggle_size_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_size
set(get(hObject, 'Parent'),'Units', 'normalized')

if isequal(get(get(hObject, 'Parent'), 'outerposition'), [0 0 1 1])
    % The window is maximized -> unmaximize
    set(get(hObject, 'Parent'),'Units', 'normalized', 'outerposition', handles.original_size);
    
    set(handles.image_axes, 'Units', 'normalized', ...
        'outerposition', [-0.0986   -0.0234    1.1546    1.0061]);
    
    set(hObject, 'String', 'Maximize');
else
    % The window is not maximize -> maximize
    set(get(hObject, 'Parent'), 'Units', 'normalized', ...
        'outerposition',[0 0 1 1]);
    
    set(handles.image_axes, 'Units', 'normalized', ...
        'outerposition', [-0.0986   -0.0234    1.1546    1.0061]);
    
    set(hObject, 'String', 'Restore');
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

% --- Executes on button press in set_square.
function set_square_Callback(hObject, eventdata, handles)
% hObject    handle to set_square (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global regions
global active_region_type

% Check that rectangles are being selected and there is at least one selected
try
    assert(strcmp(active_region_type,'rectangle') || ...
        strcmp(active_region_type,'ellipse'),...
        'MATLAB:Wrong:Region',...
        'This option is only available for rectangle or ellipse regions')
    assert(size(regions,1) >= 1,...
        'MATLAB:No:Region', 'There is no region to set to 1:1')
    
    position = getPosition(regions{end,1});

    max_dim = max(position(3:4));

    setPosition(regions{end,1}, [position(1:2),max_dim, max_dim])

catch MException
    helpdlg(MException.message,MException.identifier)
end

% --- Executes on button press in rectangle_region.
function rectangle_region_Callback(hObject, eventdata, handles)
% hObject    handle to rectangle_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rectangle_region
global region_data
global regions
global active_region_type

active_region_type = 'rectangle';

fcn = makeConstrainToRectFcn( ...
    'imrect', ...
    handles.image_axes.XLim, ...
    handles.image_axes.YLim ...
    );

while get(hObject,'Value')
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'Off')
    
    l = size(regions,1) + 1;
    regions{l, 1} = imrect;
    
    setPositionConstraintFcn(regions{end,1},fcn);
    
    wait(regions{end,1});
    
    region_data = getPosition(regions{end,1});
    
    % Launch label_selection
    RegionSelectCallback(handles.image_axes)
    
    if ~isempty(region_data)
        % Add color rectangle on top of the drawn one
        regions{l, 2} = rectangle(...
            'Position', region_data, ...
            'LineWidth',2, ...
            'EdgeColor','g'...
            );
        
        % Callback for updating rectangle info when it is moved
        addNewPositionCallback(regions{end, 1},...
            (@(p) rectangleEllipsePositionCallback(p,l)) ...
            );
    end
    
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'On')
end

% --- Executes on when the user moves a rectangle.
function rectangleEllipsePositionCallback(region_data, l)

global labels
global regions

% Update position of the color rectangle
set(regions{l,2}, 'Position', region_data)

% Update rectangle position in labels cell array
labels{l}.x = region_data(1);
labels{l}.y = region_data(2);
labels{l}.width = region_data(3);
labels{l}.height = region_data(4);

% --- Executes on when the user moves a non-rectangular region.
function regionPositionCallback(region_data, l)

global labels

% Update region position in labels cell array
labels{l}.Position = region_data;


% --- Executes on button press in polygon_region.
function polygon_region_Callback(hObject, eventdata, handles)
% hObject    handle to polygon_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_polygon

global region_data
global regions
global active_region_type

active_region_type = 'polygon';

fcn = makeConstrainToRectFcn( ...
    'impoly', ...
    handles.image_axes.XLim, ...
    handles.image_axes.YLim ...
    );

while get(hObject,'Value')
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'Off')
    
    l = size(regions,1) + 1;
    regions{l, 1} = impoly('Closed',true);
    
    api = iptgetapi(regions{end,1});
    api.setPositionConstraintFcn(fcn);
    
    wait(regions{end,1});
    
    region_data = getPosition(regions{end,1});
    
    % Launch label_selection
    RegionSelectCallback(handles.image_axes)
    
    if ~isempty(region_data)
        % Set polygon colour
        api.setColor('green');
        
        % Callback for updating region info when it is moved
        addNewPositionCallback(regions{end, 1},...
            (@(p) regionPositionCallback(p,l)) ...
            );
    end
    
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'On')
end


% --- Executes on button press in ellipse_region.
function ellipse_region_Callback(hObject, eventdata, handles)
% hObject    handle to ellipse_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of elliptical_region

global region_data
global regions
global active_region_type

active_region_type = 'ellipse';

fcn = makeConstrainToRectFcn( ...
    'imellipse', ...
    handles.image_axes.XLim, ...
    handles.image_axes.YLim ...
    );

while get(hObject,'Value')
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'Off')
%     'PositionConstraintFcn'
    l = size(regions,1) + 1;
    regions{l, 1} = imellipse;
    
    api = iptgetapi(regions{end,1});
    api.setResizable(true);
    api.setPositionConstraintFcn(fcn);
    
    wait(regions{end,1});
    
    region_data = getPosition(regions{end,1});
    
    % Launch label_selection
    RegionSelectCallback(handles.image_axes)
    
    if ~isempty(region_data)
        % Set polygon colour
        api.setColor('green');
        
        % Callback for updating region info when it is moved
        addNewPositionCallback(regions{end, 1},...
            (@(p) rectangleEllipsePositionCallback(p,l)) ...
            );
    end
    
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'On')
end


% --- Executes on button press in freehand_region.
function freehand_region_Callback(hObject, eventdata, handles)
% hObject    handle to freehand_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of freehand_region

global region_data
global regions
global active_region_type

active_region_type = 'freehand';

fcn = makeConstrainToRectFcn( ...
    'imfreehand', ...
    handles.image_axes.XLim, ...
    handles.image_axes.YLim ...
    );

while get(hObject,'Value')
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'Off')
    
    l = size(regions,1) + 1;
    regions{l, 1} = imfreehand('Closed',true);
    
    api = iptgetapi(regions{end,1});
    api.setPositionConstraintFcn(fcn);
    
    wait(regions{end,1});
    
    region_data = getPosition(regions{end,1});
    
    % Launch label_selection
    RegionSelectCallback(handles.image_axes)
    
    if ~isempty(region_data)
        % Set polygon colour
        api.setColor('green');
        
        % Callback for updating region info when it is moved
        addNewPositionCallback(regions{end, 1},...
            (@(p) regionPositionCallback(p,l)) ...
            );
    end
    
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'On')
end
