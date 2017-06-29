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

% Last Modified by GUIDE v2.5 28-Jun-2017 21:04:25

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
global username
global image_size

active_region_type = '';

% Initialize labels and regions as empty cell arrays
labels = cell(0);
regions = cell(0);
region_texts = cell(0);

% Load parasite types
config_values = loadjson('config.json');
parasite_types = config_values.parasite_types;
parasite_colours = config_values.parasite_colours;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % DEV OPTION - COMMENT WHEN FINISHED!!!!             %
% img_file_path = './data/img/BCN877_72h_x20bf_3.jpg'; %
% username = 'albert';                                 %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose default command line output for region_selection
handles.output = hObject;

% Set image file path as the window title
set(hObject, 'Name', [img_file_path, ' - ', username, ' - Labeling App']);

% Save original window size for when restoring the its size
set(hObject,'Units', 'normalized');
handles.original_size = get(hObject, 'outerposition');

% Plot the selected image
myImage = imread(img_file_path);
s = size(myImage);
image_size = s(1:2);
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
global last_username                       %
global username                            %
last_username = username;                  %
                                           %
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
    set(get(hObject, 'Parent'),'Units', 'normalized', ...
        'outerposition', handles.original_size);
    
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
        cellfun(@(text) set(text, 'Visible', 'off'), region_texts);
        
        set(hObject, 'String', 'Show labels');
    else
        % Show labels
        cellfun(@(text) set(text, 'Visible', 'on'), region_texts);
        
        set(hObject, 'String', 'Hide labels');
    end
    
catch MException
    warndlg(MException.message,MException.identifier)
    set(hObject, 'Value', 0);
end

% --- Executes on button press in save_labels.
function save_labels_Callback(~, ~, ~)
% hObject    handle to save_labels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

img_name = gui_utils.save_labels;

helpdlg(['Regions have been saved in ', img_name],'Save success')


% --- Executes on button press in load_data.
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_file_path
global username
global labels

% Check if there are already loaded labels
if numel(labels) > 0
    % There are labels. Ask user what to do
    save_choice = questdlg('Do you want to save present labels before closing?',...
        'Save labels?',...
        'Yes', 'No', 'Cancel', 'Cancel');
    
    % Handle response
    switch save_choice
        case 'Yes'
            % Save labels, then clear and load new labels
            gui_utils.save_labels
            gui_utils.clear_regions
            
        case 'No'
            % Clear labels, then load new labels
            gui_utils.clear_regions
            
        case 'Cancel'
            return
    end
end

% Divide img_file_path in path, filename and extension
[path, filename, ~] = fileparts(img_file_path);

% Change image path for labels path
path = regexprep(path, 'img', ['regions/', username]);

% Get path of labels file (chosen by the user)
[filename, path] = uigetfile(...
    {'*.json', 'JSON Files'}, ...
    'Select labels file to load', ...
    [path,'/',[filename,'.json']]...
    );

data_filepath = [path,'/',filename];

labels = loadjson(data_filepath);

% Show regions and labels
cellfun(@(region) load_region(handles, region), labels);

helpdlg('Labels have been loaded','Load successful')

% --- Executes on data load --- %
function load_region(handles, region)
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
        
        % Load region
        gui_utils.load_rectangle_ellipse_text(l, region, region_data)
    case 'ellipse'
        fcn = makeConstrainToRectFcn( ...
            'imellipse', ...
            handles.image_axes.XLim, ...
            handles.image_axes.YLim ...
            );
        regions{l, 1} = imellipse(handles.image_axes, region.Position);
        
        % Load region
        gui_utils.load_rectangle_ellipse_text(l, region, region_data)
    case 'polygon'
        fcn = makeConstrainToRectFcn( ...
            'impoly', ...
            handles.image_axes.XLim, ...
            handles.image_axes.YLim ...
            );
        regions{l, 1} = impoly(handles.image_axes, region.Position);
        
        % Load region
        gui_utils.load_polygon_freehand_text(l, region, region_data)
    case 'freehand'
        fcn = makeConstrainToRectFcn( ...
            'imfreehand', ...
            handles.image_axes.XLim, ...
            handles.image_axes.YLim ...
            );
        regions{l, 1} = imfreehand(handles.image_axes, region.Position);
        
        % Load region
        gui_utils.load_polygon_freehand_text(l, region, region_data)
    otherwise
        errordlg('Invalid region type')
end

api = iptgetapi(regions{l, 1});
api.setPositionConstraintFcn(fcn);

% Set colour according to parasite type
setRegionColour(api, region.parasite_type)


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

function setRegionColour(region_api, parasite_type)
global parasite_colours
colour = parasite_colours{parasite_type};

region_api.setColor(colour);

% --- Executes on button press in rectangle_region.
function rectangle_region_Callback(hObject, eventdata, handles)
% hObject    handle to rectangle_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rectangle_region
if get(hObject, 'Value') == 0
    gui_utils.emulate_ESC_key
end

global regions
global active_region_type

active_region_type = 'rectangle';

fcn = makeConstrainToRectFcn( ...
    'imrect', ...
    handles.image_axes.XLim, ...
    handles.image_axes.YLim ...
    );

region_names = gui_utils.get_region_fields(handles);
to_disable = region_names(~strcmp(region_names,[active_region_type,'_region']));

for idx = 1:numel(to_disable)
    set(handles.(to_disable{idx}),'Enable','off')
end

while get(hObject,'Value')
    l = numel(regions) + 1;
    h = imrect;
    
    if numel(h) == 1
        api = iptgetapi(h);
        api.setPositionConstraintFcn(fcn);
        
        recursiveRegionConfirm(handles, active_region_type, h, api, l)
    end
end

for idx = 1:numel(to_disable)
    set(handles.(to_disable{idx}),'Enable','on')
end


% --- Executes on button press in ellipse_region.
function ellipse_region_Callback(hObject, eventdata, handles)
% hObject    handle to ellipse_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of elliptical_region
if get(hObject, 'Value') == 0
    gui_utils.emulate_ESC_key
end

global regions
global active_region_type

active_region_type = 'ellipse';

fcn = makeConstrainToRectFcn( ...
    'imellipse', ...
    handles.image_axes.XLim, ...
    handles.image_axes.YLim ...
    );

region_names = gui_utils.get_region_fields(handles);
to_disable = region_names(~strcmp(region_names,[active_region_type,'_region']));

for idx = 1:numel(to_disable)
    set(handles.(to_disable{idx}),'Enable','off')
end

while get(hObject,'Value')
    l = numel(regions) + 1;
    h = imellipse;
    
    if numel(h) == 1
        api = iptgetapi(h);
        api.setResizable(true);
        api.setPositionConstraintFcn(fcn);
        
        recursiveRegionConfirm(handles, active_region_type, h, api, l)
    end
end

for idx = 1:numel(to_disable)
    set(handles.(to_disable{idx}),'Enable','on')
end


% --- Executes on button press in polygon_region.
function polygon_region_Callback(hObject, eventdata, handles)
% hObject    handle to polygon_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_polygon
if get(hObject, 'Value') == 0
    gui_utils.emulate_ESC_key
end

global regions
global active_region_type

active_region_type = 'polygon';

fcn = makeConstrainToRectFcn( ...
    'impoly', ...
    handles.image_axes.XLim, ...
    handles.image_axes.YLim ...
    );

region_names = gui_utils.get_region_fields(handles);
to_disable = region_names(~strcmp(region_names,[active_region_type,'_region']));

for idx = 1:numel(to_disable)
    set(handles.(to_disable{idx}),'Enable','off')
end

while get(hObject,'Value')
    l = numel(regions) + 1;
    h = impoly('Closed',true);
    
    if numel(h) == 1
        api = iptgetapi(h);
        api.setPositionConstraintFcn(fcn);
        
        recursiveRegionConfirm(handles, active_region_type, h, api, l)
    end
end

for idx = 1:numel(to_disable)
    set(handles.(to_disable{idx}),'Enable','on')
end


% --- Executes on button press in freehand_region.
function freehand_region_Callback(hObject, eventdata, handles)
% hObject    handle to freehand_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of freehand_region
if get(hObject, 'Value') == 0
    gui_utils.emulate_ESC_key
end

global regions
global active_region_type

active_region_type = 'freehand';

fcn = makeConstrainToRectFcn( ...
    'imfreehand', ...
    handles.image_axes.XLim, ...
    handles.image_axes.YLim ...
    );

region_names = gui_utils.get_region_fields(handles);
to_disable = region_names(~strcmp(region_names,[active_region_type,'_region']));

for idx = 1:numel(to_disable)
    set(handles.(to_disable{idx}),'Enable','off')
end

while get(hObject,'Value')
    l = numel(regions) + 1;
    h = imfreehand('Closed',true);
    
    if numel(h) == 1
        api = iptgetapi(h);
        api.setPositionConstraintFcn(fcn);
        
        recursiveRegionConfirm(handles, active_region_type, h, api, l)
    end
end

for idx = 1:numel(to_disable)
    set(handles.(to_disable{idx}),'Enable','on')
end

function recursiveRegionConfirm(handles, region_type, h, api, l)
global region_data
global regions
global labels
global did_select_label

w = wait(h);

if numel(w) > 0
    regions{l, 1} = h;
    
    region_data = getPosition(regions{end,1});
    
    % Launch label_selection
    RegionSelectCallback(handles.image_axes)
    
    if did_select_label
        % Set region colour
        setRegionColour(api, labels{l}.parasite_type)
        
        switch region_type
            case {'rectangle', 'ellipse'}
                gui_utils.load_rectangle_ellipse_text(l, labels{l}, region_data)
            case{'polygon', 'freehand'}
                gui_utils.load_polygon_freehand_text(l, labels{l}, region_data)
            otherwise
                errordlg('Error: Invalid region type', 'Invalid region type')
        end
    else
        % Call recursiveRegionConfirm again to let user re-confirm the region
        recursiveRegionConfirm(handles, region_type, h, api, l)
    end
else
    delete(h)
    
    % Delete the region because it is not wanted by the user
    regions = regions(1:end-1);
end


% --- Executes on button press in exportregions_button.
function exportregions_button_Callback(hObject, eventdata, handles)
% hObject    handle to exportregions_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global parasite_types
global image_size

% Initialize empty cell array to store the binary masks for each parasite type
binary_masks = zeros([8, image_size]);

% Iterate over all parasite types
for i=1:size(parasite_types,2)
    % TODO Figure out what to do with 'Background' regions
    %   Multiply by zero?
    
    % Export each parasite's binary mask
    % Multiply each mask for its hierarchy value
    binary_masks(i,:,:) = gui_utils.create_labels(i) * i;
end

% Pixel-wise max to obtain result hierarchical labels
image_labels = max(binary_masks,[],1);

% Save labels to CSV file to be read in Python
labels_path = gui_utils.construct_save_path('.csv','labels');

csvwrite(labels_path,squeeze(image_labels))

helpdlg(['Labels have been saved in ', labels_path],'Save success')
