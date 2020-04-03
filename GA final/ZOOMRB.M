function zoomrb(action)
% ZOOMRB - Graphical 2D Axis Zoom with history (rubberband version).
%
% To use, simply type 'zoomrb' at the command prompt.
%   You can then resize (zoom) the current 2D figure
%   by clicking with the left mouse button, then dragging the
%   box until you get the desired area.
%   If you don't like that zoom, or want to retrace
%   your steps, simply click with the RIGHT mouse
%   button (extended press) and your previous axis will be
%   restored. Currently the depth of zooming is 10 units.
%
%   When you want to exit the zoom function (turn off resize),
%   press the <RETURN> key in the figure window.
%
%  Optionally, called as zoomrb('aspect') will keep the original
%  figure's aspect ratio, resizing to the LONGEST side.
%
%   (c) 1994 Dean Redelinghuys
%       Opti-Num Solutions
%       Matlab Reseller in South Africa
%       e-mail: redel@odie.ee.wits.ac.za

%   This Version 19-07-94
%   For Grant, without whom....

% ACTIONS:
%   Start - default for zero input
%   Down - button gone down, perform the zoom with rbbox.

% Notes from MBS, 8/94.  On the macintosh there is only one mouse button.  The
% zoom out command is completed by holding the shift key and clicking the mouse.
% I have found that the zoom out with the keyboard mouse is kind of finicky ... 
% you must click the button quickly and hard...It may of course just be my 
% keyboard mouse!
% 

maxax=10;                       % Maximum remembered axes
if nargin<1, action='start'; end;

if (strcmp(action,'start')|strcmp(action,'aspect'));
    % The user has called the routine from the command line
    if strcmp(action,'aspect'), aspect=1; else aspect=0; end;
    axhist=zeros(maxax,4);
    axnum=1;
    axhist(axnum,:)=axis;   % remember the first axis
    kpf = ['set(gcf,''pointer'',''arrow'',', ...
           ' ''WindowButtonDownFcn'','''',''UserData'','''',', ...
           ' ''KeyPressFcn'','''');'];
    set(gcf,'UserData',[axnum aspect axhist(:)'], ...
            'pointer','crosshair', ...
            'WindowButtonDownFcn','zoomrb(''down'');', ...
            'KeyPressFcn',kpf);
    % Now the figure will trap the buttondown, and zooming will happen
elseif strcmp(action,'down');
    % User has pressed down the mouse button.
    h=get(gcf,'UserData');
    axnum=h(1);
    aspect=h(2);
    axhist=zeros(maxax,4);
    axhist(:)=h(3:length(h));
    % We now have the original variables.
    mousebtn = get(gcf,'SelectionType');
    if strcmp(mousebtn, 'normal');
        % user wants to zoom IN
        if axnum<maxax,
            axnum = axnum+1;
            cpa=get(gca,'CurrentPoint');
            x1=cpa(1,1);y1=cpa(1,2);
            % We've got the first point, now the rbbox
            % We have to jump through hoops here, since the
            % RBBOX function returns nothing and updates
            % only the root object's PointerLocation.
            ax=axis;    % get the extents of the current axis
            CurUnitsA=get(gca,'Units');     % store for later
            set(gca, 'Units', 'pixels');    % Want axis pos iin pixels
            fpa=get(gca, 'Position');       % Got it
            set(gca, 'Units', CurUnitsA);   % Reset axis units
            CurUnitsF=get(gcf,'Units');     % Same thing for figure.
            set(gcf, 'Units', 'pixels');
            fpf=get(gcf, 'Position');
            ppux=fpa(3)/(ax(2)-ax(1));      % Pixels per unit x-axis
            ppuy=fpa(4)/(ax(4)-ax(3));      % Pixels per unit y-axis
            cpf=get(gcf, 'CurrentPoint');   % Original zoom box
            set(gcf, 'Units', CurUnitsF);   % Restore figure units
            cp0=get(0, 'PointerLocation');  % Always in pixels
            rbbox([cpf 0 0], [cpf]);        % Call the RBBOX
            cp0fin=get(0, 'PointerLocation');   % get other box extent
            dyfin=cp0fin(2)-fpf(2)-fpa(2);  
            dxfin=cp0fin(1)-fpf(1)-fpa(1);
            y2=dyfin ./ ppuy + ax(3);
            x2=dxfin ./ ppux + ax(1);
            x=[x1 x2];x1=min(x);x2=max(x);  % sort in min / max order
            y=[y1 y2];y1=min(y);y2=max(y);
            if aspect,
               % We need to preserve the aspect ratio,
               % So we use the LONGEST side
               if abs(x2-x1)>abs(y2-y1),
                  y2=y1+(x2-x1)*(ax(4)-ax(3))/(ax(2)-ax(1));
               else
                  x2=x1+(y2-y1)*(ax(2)-ax(1))/(ax(4)-ax(3));
               end;
            end;
            axhist(axnum,:)=[x1 x2 y1 y2];  % Store it
            axis(axhist(axnum,:));          % Set it
            set(gcf,'UserData',[axnum aspect axhist(:)']);
        end;
    else
        % The user wants to zoom OUT
        if axnum>1,  % if you have zoomed in at all
            axhist(axnum,:)=ones(1,4).*NaN;
            axnum = axnum-1;
            axis(axhist(axnum,:));
            set(gcf,'UserData',[axnum aspect axhist(:)']);
        end;
    end;
end;    
