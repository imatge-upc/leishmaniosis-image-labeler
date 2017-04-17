classdef gui_utils
    %utils Library of functions used throughout the app's code
    %   This class contains several functions that are repeatedly used in the
    %   app's code.
    
    methods (Static)
        function [region_names] = get_region_fields(handles)
            %get_region_fields Get the names of the region fields in handles
            %   This function takes from handles all fields that correspond to
            %   the available regions in the app
            %
            %   Original code by Rafael Monteiro @ StackOverflow
            %   http://stackoverflow.com/a/23415796/7390416
            %   Original License: CC-BY-SA 3.0
            %   ----------------------------------------------------------------
            %
            %   Modified by Albert Aparicio
            %   New License: GNU GPLv3+
            %
            %   The code relicensing follows the rationale exposed below:
            %   http://opensource.stackexchange.com/a/2213
            
            fields = fieldnames(handles);
            region_names = fields(contains(fields, '_region'));
        end
        
        function emulate_ESC_key
            %emulate_ESC_key Emulate programatically an ESC keystroke
            %   This function simulates via code a keystroke of the ESC key. It
            %   is used in the app to cancel a not-yet selected region
            %
            %   Code from Amirhosein Ghenaati
            %   https://mathworks.com/matlabcentral/answers/5259#answer_161442
            %   License: CC-BY-SA 3.0
            
            import java.awt.Robot
            import java.awt.event.*
            keys = Robot;
            keys.setAutoDelay(100)
            %   [...]
            keys.keyPress(java.awt.event.KeyEvent.VK_ESCAPE )
            keys.keyRelease(java.awt.event.KeyEvent.VK_ESCAPE )
            keys.waitForIdle
        end
        
        function load_rectangle_ellipse_text(l, region, region_data)
            %load_rectangle_ellipse_text Load rectangular or elliptical region text
            %   This function loads into the app the text of a rectangular or
            %   elliptical region. The code can be used for the two types of
            %   regions because they are accessed in the same way.
            %
            %   The function creates the text object, placing it centered below
            %   the region. After that, it instantiates the position callback on
            %   the region's object.
            
            global region_texts
            global parasite_types
            global regions
            
            region_texts{l,1} = text(region_data(1)+(region_data(3)/2),...
                region_data(2)+region_data(4),...
                char(parasite_types{region.parasite_type}),...
                'HorizontalAlignment', 'center',...
                'VerticalAlignment', 'top'...
                );
            
            % Callback for updating rectangle info when it is moved
            addNewPositionCallback(regions{l, 1},...
                (@(p) gui_utils.rectangleEllipsePositionCallback(p,l,region_texts{l,1})));
        end
        
        function load_polygon_freehand_text(l, region, region_data)
            %load_polygon_freehand_text Load polygonal or freehand region text
            %   This function loads into the app the text of a polygonal or
            %   freehand region. The code can be used for the two types of
            %   regions because they are accessed in the same way.
            %
            %   The function creates the text object, placing it centered below
            %   the region. The text is centered by taking the furthest point on
            %   the region on the right and on the left. The text is located
            %   below the lowest point in the region.
            %
            %   After that, it instantiates the position callback on
            %   the region's object.
            
            global region_texts
            global parasite_types
            global regions
            
            max_h = max(region_data(:,1));
            min_h = min(region_data(:,1));
            text_v = max(region_data(:,2));
            
            region_texts{l,1} = text((min_h+max_h)/2, text_v,...
                char(parasite_types{region.parasite_type}),...
                'HorizontalAlignment', 'center',...
                'VerticalAlignment', 'top'...
                );
            
            % Callback for updating region info when it is moved
            addNewPositionCallback(regions{l, 1},...
                (@(p) gui_utils.polygonFreehandPositionCallback(p,l,region_texts{l,1})));
        end
        % --- Executes on when the user moves a rectangle.
        function rectangleEllipsePositionCallback(region_data, l, text)
            
            global labels
            
            % Update position of the color rectangle
            text.Position = [region_data(1)+(region_data(3)/2), ...
                region_data(2)+region_data(4)];
            
            % Update rectangle position in labels cell array
            labels{l}.Position = region_data;
        end
        
        % --- Executes on when the user moves a non-rectangular region.
        function polygonFreehandPositionCallback(region_data, l, text)
            
            global labels
            
            max_h = max(region_data(:,1));
            min_h = min(region_data(:,1));
            text_v = max(region_data(:,2));
            
            text.Position = [(min_h+max_h)/2, text_v];
            
            % Update region position in labels cell array
            labels{l}.Position = region_data;
        end
        
        function [img_name] = save_labels()
            global labels
            global img_file_path
            global username
            
            % Divide img_file_path in path, filename and extension
            [path, filename, ~] = fileparts(img_file_path);
            
            % Change image path for labels path
            path = regexprep(path, 'img', ['labels/', username]);
            
            % Change image extension for JSON extension
            extension = '.json';
            
            c = clock;
            timestamp = [num2str(c(1), '%04.0f'),num2str(c(2:end), '%02.0f')];
            
            % Construct complete filepath
            img_name = [path,'/',filename,'-',timestamp,extension];
            
            % Make user directory
            mkdir(path);
            
            % TODO Try saving in UBJSON format
            % Save labels to JSON file
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % DEV - Activate compact when finished!!                  %
            savejson('', labels, 'FileName', img_name, 'Compact', 1); %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        
        function clear_regions()
            global labels
            global region_texts
            global regions
            
            % Delete regions and texts
            cellfun(@(region) delete(region), regions);
            cellfun(@(region_text) delete(region_text), region_texts);
            
            % Re-initialize regions and texts
            labels = cell(0);
            regions = cell(0);
            region_texts = cell(0);
        end
    end
end