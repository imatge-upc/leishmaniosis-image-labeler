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

% Last Modified by GUIDE v2.5 20-Feb-2017 10:35:34

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
global region_texts
global parasite_types
global parasite_colours

active_region_type = '';

% Initialize labels and regions as empty cell arrays
labels = cell(0);
regions = cell(0);
region_texts = cell(0);

% Load parasite types
config_values = loadjson('config.json');
parasite_types = config_values.parasite_types;
parasite_colours = config_values.parasite_colours;

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
main_menu                                  %
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

% --- Executes on button press in show_hide_labels.
function show_hide_labels_Callback(hObject, eventdata, handles)
% hObject    handle to show_hide_labels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_hide_labels
global region_texts

try
    assert(numel(region_texts) > 0,...
        'MATLAB:Hide:Error',...
        'There are no labels to hide/show')
    
    if get(hObject, 'Value') == 1
        % Hide labels
        cellfun(@(text) hide_text_callback(text), region_texts);
        
        set(hObject, 'String', 'Show labels');
    else
        % Show labels
        cellfun(@(text) show_text_callback(text), region_texts);
        
        set(hObject, 'String', 'Hide labels');
    end
    
catch MException
    warndlg(MException.message,MException.identifier)
    set(hObject, 'Value', 0);
end

function hide_text_callback(text)
text.Visible = 'off';

function show_text_callback(text)
text.Visible = 'on';

% --- Executes on button press in save_labels.
function save_labels_Callback(hObject, eventdata, handles)
% hObject    handle to save_labels (see GCBO)
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


% --- Executes on button press in load_data.
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_file_path
global labels

% Get image path with JSON extension
pattern = '.jpg';
replacement = '_labels.json';
data_filepath = regexprep(img_file_path,pattern,replacement);

labels = loadjson(data_filepath);

% Show regions and labels
cellfun(@(region) load_region(handles, region), labels);

helpdlg('Labels have been loaded','Load success')

% --- Executes on data load --- %
function load_region(handles, region)
global region_texts
global parasite_types
global regions

region_data = region.Position;
l = region.l;

switch region.region_type
    case 'rectangle'
        fcn = makeConstrainToRectFcn( ...
            'imrect', ...
            handles.image_axes.XLim, ...
            handles.image_axes.YLim ...
            );
        regions{l, 1} = imrect(handles.image_axes, region.Position);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % TODO Move to function
        region_texts{l,1} = text(region_data(1)+(region_data(3)/2), region_data(2)+region_data(4),...
            parasite_types{region.parasite_type},...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'top'...
            );
        
        % Callback for updating rectangle info when it is moved
        addNewPositionCallback(regions{l, 1},...
            (@(p) rectangleEllipsePositionCallback(p,l,region_texts{l,1})) ...
            );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'ellipse'
        fcn = makeConstrainToRectFcn( ...
            'imellipse', ...
            handles.image_axes.XLim, ...
            handles.image_axes.YLim ...
            );
        regions{l, 1} = imellipse(handles.image_axes, region.Position);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % TODO Move to function
        region_texts{l,1} = text(region_data(1)+(region_data(3)/2), region_data(2)+region_data(4),...
            parasite_types{region.parasite_type},...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'top'...
            );
        
        % Callback for updating rectangle info when it is moved
        addNewPositionCallback(regions{l, 1},...
            (@(p) rectangleEllipsePositionCallback(p,l,region_texts{l,1})) ...
            );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'polygon'
        fcn = makeConstrainToRectFcn( ...
            'impoly', ...
            handles.image_axes.XLim, ...
            handles.image_axes.YLim ...
            );
        regions{l, 1} = impoly(handles.image_axes, region.Position);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % TODO Move to function
        max_h = max(region_data(:,1));
        min_h = min(region_data(:,1));
        text_v = max(region_data(:,2));
        
        region_texts{l,1} = text((min_h+max_h)/2, text_v,...
            parasite_types{region.parasite_type},...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'top'...
            );
        
        % Callback for updating region info when it is moved
        addNewPositionCallback(regions{l, 1},...
            (@(p) regionPositionCallback(p,l,region_texts{l,1})) ...
            );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'freehand'
        fcn = makeConstrainToRectFcn( ...
            'imfreehand', ...
            handles.image_axes.XLim, ...
            handles.image_axes.YLim ...
            );
        regions{l, 1} = imfreehand(handles.image_axes, region.Position);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % TODO Move to function
        max_h = max(region_data(:,1));
        min_h = min(region_data(:,1));
        text_v = max(region_data(:,2));
        
        region_texts{l,1} = text((min_h+max_h)/2, text_v,...
            parasite_types{region.parasite_type},...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'top'...
            );
        
        % Callback for updating region info when it is moved
        addNewPositionCallback(regions{l, 1},...
            (@(p) regionPositionCallback(p,l,region_texts{l,1})) ...
            );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    otherwise
        errordlg('Invalid region type')
end

api = iptgetapi(regions{l, 1});
api.setPositionConstraintFcn(fcn);

api.setColor('green');


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
global labels
global parasite_types
global region_texts

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
    
    api = iptgetapi(regions{end,1});
    api.setPositionConstraintFcn(fcn);
    
    wait(regions{end,1});
    
    region_data = getPosition(regions{end,1});
    
    % Launch label_selection
    RegionSelectCallback(handles.image_axes)
    
    if ~isempty(region_data)
        % Set region colour
        setRegionColour(api, labels{l}.parasite_type)
        
        region_texts{l,1} = text(region_data(1)+(region_data(3)/2), region_data(2)+region_data(4),...
            parasite_types{labels{l}.parasite_type},...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'top'...
            );
        
        % Callback for updating rectangle info when it is moved
        addNewPositionCallback(regions{end, 1},...
            (@(p) rectangleEllipsePositionCallback(p,l,region_texts{l,1})) ...
            );
    end
    
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'On')
end

function setRegionColour(region_api, parasite_type)
    global parasite_colours
    colour = parasite_colours{parasite_type};
    
    region_api.setColor(colour);

% --- Executes on when the user moves a rectangle.
function rectangleEllipsePositionCallback(region_data, l, text)

global labels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO Move to function
% Update position of the color rectangle
text.Position = [region_data(1)+(region_data(3)/2), region_data(2)+region_data(4)];

% Update rectangle position in labels cell array
labels{l}.Position = region_data;

% --- Executes on when the user moves a non-rectangular region.
function regionPositionCallback(region_data, l, text)

global labels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO Move to function
max_h = max(region_data(:,1));
min_h = min(region_data(:,1));
text_v = max(region_data(:,2));

text.Position = [(min_h+max_h)/2, text_v];

% Update region position in labels cell array
labels{l}.Position = region_data;


% --- Executes on button press in ellipse_region.
function ellipse_region_Callback(hObject, eventdata, handles)
% hObject    handle to ellipse_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of elliptical_region

global region_data
global regions
global active_region_type
global parasite_types
global labels
global region_texts

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
        % Set region colour
        setRegionColour(api, labels{l}.parasite_type)
        
        region_texts{l,1} = text(region_data(1)+(region_data(3)/2), region_data(2)+region_data(4),...
            parasite_types{labels{l}.parasite_type},...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'top'...
            );
        
        % Callback for updating region info when it is moved
        addNewPositionCallback(regions{end, 1},...
            (@(p) rectangleEllipsePositionCallback(p,l,region_texts{l,1})) ...
            );
    end
    
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'On')
end


% --- Executes on button press in polygon_region.
function polygon_region_Callback(hObject, eventdata, handles)
% hObject    handle to polygon_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_polygon

global region_data
global regions
global active_region_type
global labels
global parasite_types
global region_texts

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
        setRegionColour(api, labels{l}.parasite_type)
        
        max_h = max(region_data(:,1));
        min_h = min(region_data(:,1));
        text_v = max(region_data(:,2));
        
        region_texts{l,1} = text((min_h+max_h)/2, text_v,...
            parasite_types{labels{l}.parasite_type},...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'top'...
            );
        
        % Callback for updating region info when it is moved
        addNewPositionCallback(regions{end, 1},...
            (@(p) regionPositionCallback(p,l,region_texts{l,1})) ...
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
global labels
global parasite_types
global region_texts

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
        % Set region colour
        setRegionColour(api, labels{l}.parasite_type)
        
        max_h = max(region_data(:,1));
        min_h = min(region_data(:,1));
        text_v = max(region_data(:,2));
        
        region_texts{l,1} = text((min_h+max_h)/2, text_v,...
            parasite_types{labels{l}.parasite_type},...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'top'...
            );
        
        % Callback for updating region info when it is moved
        addNewPositionCallback(regions{end, 1},...
            (@(p) regionPositionCallback(p,l,region_texts{l,1})) ...
            );
    end
    
    % TODO Check that this is correct
    set(hObject, 'Interruptible', 'On')
end
