classdef App_V1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        GridLayout             matlab.ui.container.GridLayout
        LeftPanel              matlab.ui.container.Panel
        NCyclesEditField       matlab.ui.control.NumericEditField
        NCyclesEditFieldLabel  matlab.ui.control.Label
        VitesseSlider          matlab.ui.control.Slider
        VitesseSliderLabel     matlab.ui.control.Label
        DmarrerButton          matlab.ui.control.Button
        RightPanel             matlab.ui.container.Panel
        UIAxes                 matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end



    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: DmarrerButton
        function DmarrerButtonPushed(app, event)
            
t = 0:0.1:2*pi;
y = sin(t);
h = plot(app.UIAxes,nan,nan); 
hold(app.UIAxes, 'on')
grid(app.UIAxes, 'on')
xlim(app.UIAxes, [0 2*pi])
ylim(app.UIAxes, [-1.5 1.5])

Amplitude_1 = -10:10;
Amplitude_2 = flip(Amplitude_1);
Cycle = [Amplitude_1 Amplitude_2];
%Cycle = [Cycle Cycle];
N_times = app.NCyclesEditField.Value;
Anim = repmat(Cycle,1,N_times);
for k = Anim
    y = k/10*sin(t);
    set(h,'XData',t, 'YData', y)   
    drawnow(); pause(app.VitesseSlider.Value)
end
pause(1)
cla(app.UIAxes) 
        end

        % Value changed function: VitesseSlider
        function VitesseSliderValueChanged(app, event)
            value = app.VitesseSlider.Value;
            
        end

        % Value changed function: NCyclesEditField
        function NCyclesEditFieldValueChanged(app, event)
            value = app.NCyclesEditField.Value;
            
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create DmarrerButton
            app.DmarrerButton = uibutton(app.LeftPanel, 'push');
            app.DmarrerButton.ButtonPushedFcn = createCallbackFcn(app, @DmarrerButtonPushed, true);
            app.DmarrerButton.Position = [60 302 100 23];
            app.DmarrerButton.Text = 'Démarrer';

            % Create VitesseSliderLabel
            app.VitesseSliderLabel = uilabel(app.LeftPanel);
            app.VitesseSliderLabel.HorizontalAlignment = 'right';
            app.VitesseSliderLabel.Position = [-5 164 44 22];
            app.VitesseSliderLabel.Text = 'Vitesse';

            % Create VitesseSlider
            app.VitesseSlider = uislider(app.LeftPanel);
            app.VitesseSlider.Limits = [0 5];
            app.VitesseSlider.ValueChangedFcn = createCallbackFcn(app, @VitesseSliderValueChanged, true);
            app.VitesseSlider.Position = [60 173 150 3];

            % Create NCyclesEditFieldLabel
            app.NCyclesEditFieldLabel = uilabel(app.LeftPanel);
            app.NCyclesEditFieldLabel.HorizontalAlignment = 'right';
            app.NCyclesEditFieldLabel.Position = [26 68 54 22];
            app.NCyclesEditFieldLabel.Text = 'N Cycles';

            % Create NCyclesEditField
            app.NCyclesEditField = uieditfield(app.LeftPanel, 'numeric');
            app.NCyclesEditField.RoundFractionalValues = 'on';
            app.NCyclesEditField.ValueChangedFcn = createCallbackFcn(app, @NCyclesEditFieldValueChanged, true);
            app.NCyclesEditField.Position = [95 68 100 22];
            app.NCyclesEditField.Value = 2;

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'Test animation')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [20 120 358 268];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = App_V1_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end