% function [f,a,c] = myplot(varargin)
% format example: myplot(e1),myplot(e1,boundaryTF),myplot(x,y,e1),myplot(x,y,e1,boundaryTF)
%
% 2015-12-2 revised
%
% chenzhe, 2018-02-08, based on myplot(). Add a slider to adjust upper limit.
% chenzhe, 2018-02-10. Looks like surf() cannot interpolate color well.
% So, try to use imagesc.
%
% chenzhe, 2018-02-10. Built-in to select points
%
% chenzhe, 2018-09-01, update to correct a few errors on coarsening.

function [f,a,c,s,v] = myplotm(M,varargin)

p = inputParser;

addRequired(p,'M');
addOptional(p,'TF',zeros(size(M))*NaN);
addParameter(p,'X',repmat(1:size(M,2),size(M,1),1));
addParameter(p,'Y',repmat([1:size(M,1)]',1,size(M,2)));
addParameter(p,'alpha',1,@(x) isnumeric(x)||islogical(x));
addParameter(p,'handle',-1,@ishandle);
addParameter(p,'r',0);
addParameter(p,'PN',-1);
parse(p,M,varargin{:});

M = p.Results.M;
TF = abs(p.Results.TF)>0;
X = p.Results.X;
Y = p.Results.Y;
f = p.Results.handle;
Malpha = p.Results.alpha;
ratio = p.Results.r;   % reduce ratio
PN = p.Results.PN;  % make boundary +inf or -inf

if length(Malpha)==1
    Malpha = ones(size(M)) * Malpha;
end
if 0==ratio
    ratio = ceil(length(M)/3000);    % reduce ratio if necessary
end
if ratio > 1
    display(['matrix is big, use reduced ratio = ',num2str(ratio)]);
    M = M(1:ratio:end,1:ratio:end);
    TF = TF(1:ratio:end,1:ratio:end);
    X = X(1:ratio:end,1:ratio:end);
    Y = Y(1:ratio:end,1:ratio:end);
    Malpha = Malpha(1:ratio:end,1:ratio:end);
end

limit_x_low = min(X(:));
limit_x_high = max(X(:));
limit_y_low = min(Y(:));
limit_y_high = max(Y(:));

if ~isempty(M(isinf(M)))
    M(isinf(M)) = nan;
end

limit_x_low = min(X(:));
limit_x_high = max(X(:));
limit_y_low = min(Y(:));
limit_y_high = max(Y(:));

if f==-1
    f=figure;
end

clim = quantile(M(:),[0.005, 0.995]);
rmin = nanmin(M(:));

% Modify M to make grainboundary as -inf.
M(1==TF) = PN * inf;
% Let the alpha of nan points to be 0.
% Malpha = ones(size(M));
Malpha(isnan(M)) = 0;
% modify the colormap to make smallest black, biggest white.
colormap([0 0 0; colormap; 1 1 1]);


hold on;
set(f,'position',[50,50,800,600]);
title(strrep(inputname(1),'_','\_'));

imagesc([X(1),X(end)],[Y(1),Y(end)],M,'alphadata',Malpha);
try
    caxis(gca, [clim(1), clim(2)]);
end
c = colorbar;

axis equal;
a=gca;
set(a,'ydir','reverse','xLim',[limit_x_low,limit_x_high],'yLim',[limit_y_low,limit_y_high]);
cStep = (clim(2)-clim(1))/size(colormap,1);
try
    set(c,'Limits',[clim(1)+cStep,clim(2)-cStep]);
end
% % the following handles slider. Can turn off
% s = uicontrol('Parent',f,...
%     'Style','slider',...
%     'Units','normalized',...
%     'Position',[c.Position(1) + 2*c.Position(3), c.Position(2), c.Position(3), c.Position(4)],...
%     'Min',clim(1),'Max',clim(2),'Value',mean(clim),'SliderStep',[1/500, 1/500]);
% 
% set(s,'Units','pixels');
% v = uicontrol('Parent',f,'Style','text','Units','pixels','Position',[s.Position(1), s.Position(2)+s.Position(4)+5, s.Position(3)+30, 20],'String',num2str(s.Value));
% b_enable = uicontrol('Parent',f,'Style','pushbutton','String','Enable Twin','Units','pixels','Position',[s.Position(1)+s.Position(3)+5, s.Position(2), 25, 25]);
% set(b_enable,'Units','normalized');
% b_disable = uicontrol('Parent',f,'Style','pushbutton','String','Disable Twin','Units','pixels','Position',[s.Position(1)+s.Position(3)+5, s.Position(2)+50, 25, 25]);
% set(b_disable,'Units','normalized');
% set(s,'Units','normalized');
% % v = uicontrol('Parent',f,'Style','text','Units','normalized','Position',[c.Position(1) + 2*c.Position(3), c.Position(2)+c.Position(4), c.Position(3)+0.05, 0.05],'String',num2str(s.Value));
% 
% s.Callback = {@callback_slider,f,a,c,v};
% b_enable.Callback = {@callback_enable_twin,f,a};
% b_disable.Callback = {@callback_disable_twin,f,a};

end

function callback_slider(source,event,f,a,c,v)
% get value of the slider
clim = caxis;
value = source.Value;
if value == source.Min
    value = clim(1) + (clim(2)-clim(1))/5; % at most, reduce 5 times scale
elseif value == source.Max
    value = clim(1) + (clim(2)-clim(1))*5;
end

temp = colormap;
n = size(temp,1);
% set clim for the image axis
set(a,'clim', [clim(1),clim(1)+(value-clim(1))/(n-1)*n]); % this is to handle the error might be caused by interpolation !!!


% reset the slider limit based on new value
set(source,'Position',[c.Position(1) + 2*c.Position(3), c.Position(2), c.Position(3), c.Position(4)],...
    'Min',clim(1),'Max',clim(1)+2*(value-clim(1)),'Value',value,'SliderStep',[1/500, 1/500]);

set(source,'Units','pixels');
set(v,'Position',[source.Position(1), source.Position(2)+source.Position(4)+5, source.Position(3)+30, 20],'String',num2str(source.Value));
set(source,'Units','normalized');
%     set(v,'Units','normalized','Position',[c.Position(1) + 2*c.Position(3), c.Position(2)+c.Position(4), c.Position(3)+0.05, 0.05],'String',num2str(source.Value));

% disp('---------');
% disp(['c limits: ',num2str(clim)]);
% disp(['value: ',num2str(source.Value)]);
end

function callback_enable_twin(source, event, f,a)
try
    X = evalin('base','X');
    Y = evalin('base','Y');
    ID = evalin('base','ID');
    clusterNumMap = evalin('base','clusterNumMap');
catch
    disp('requires variables: X, Y, ID, clusterNumMap in base workspace');
end

set(f,'currentaxes',a);
[x,y] = getpts;

for ii = 1:size(x,1)
    [~,subx] = min(abs(X(1,:)-x(ii)));
    [~,suby] = min(abs(Y(:,1)-y(ii)));
    idNum(ii) = ID(suby,subx);
    cNum(ii) = clusterNumMap(suby,subx);
end

try
    tNote = evalin('base','tNote');
catch
    tNote.enable = [0 0];
    tNote.disable = [0 0];
end
tNote.enable = [tNote.enable;[idNum(:),cNum(:)]];

% if accidentally enabled, can disable
for ii=1:size(tNote.enable,1)
    idx = ismember(tNote.disable,tNote.enable(ii,:),'rows');
    if sum(idx)>0
        tNote.disable(idx,:) = [0 0];
        tNote.enable(ii,:) = [0 0];
    end
end

tNote.enable = unique(tNote.enable,'rows');
tNote.disable = unique(tNote.disable,'rows');

assignin('base','tNote',tNote);
end

function callback_disable_twin(source, event, f,a)
try
    X = evalin('base','X');
    Y = evalin('base','Y');
    ID = evalin('base','ID');
    clusterNumMap = evalin('base','clusterNumMap');
catch
    disp('requires variables: X, Y, ID, clusterNumMap in base workspace');
end

set(f,'currentaxes',a);
[x,y] = getpts;

for ii = 1:size(x,1)
    [~,subx] = min(abs(X(1,:)-x(ii)));
    [~,suby] = min(abs(Y(:,1)-y(ii)));
    idNum(ii) = ID(suby,subx);
    cNum(ii) = clusterNumMap(suby,subx);
end

try
    tNote = evalin('base','tNote');
catch
    tNote.enable = [0 0];
    tNote.disable = [0 0];
end
tNote.disable = [tNote.disable;[idNum(:),cNum(:)]];

% if accidentally enabled, can disable
for ii=1:size(tNote.disable,1)
    idx = ismember(tNote.enable,tNote.disable(ii,:),'rows');
    if sum(idx)>0
        tNote.enable(idx,:) = [0 0]; 
        tNote.disable(ii,:) = [0 0];
    end
end

tNote.disable = unique(tNote.disable,'rows');
tNote.enable = unique(tNote.enable,'rows');

assignin('base','tNote',tNote);
end



