% function [f,a,c] = myplot(varargin)
% format example: myplot(e1),myplot(e1,boundaryTF),myplot(x,y,e1),myplot(x,y,e1,boundaryTF)
%
% 2015-12-2 revised

function [f,a,c] = myplot(varargin)
k = nargin;
for ii=1:k
    if iscell(varargin{ii})  % if have multiple layers
        answer = inputdlg(['Data # ',num2str(ii),' has multiple layers. Which layer to plot?'],'Choose Layer',1,{'1'});
        layer = str2num(answer{1});
        M{ii} = varargin{ii}{layer};
    else
        M{ii} = varargin{ii};
    end
end

ratio = ceil(length(M{1})/3000);    % reduce ratio if necessary
if 5==k
    ratio = M{5};
end
if ratio > 1
    display(['matrix is big, use reduced ratio = ',num2str(ratio)]);
    for ii=1:length(M)
        M{ii} = M{ii}(1:ratio:end,1:ratio:end);
    end
end
if ~isempty(M{1}(isinf(M{1})))
    M{1}(isinf(M{1})) = nan;
end
limit_y_low = 1;
limit_x_low = 1;
[limit_y_high, limit_x_high] = size(M{1});

f=figure;
switch k
    case 1
        set(f,'position',[50,50,800,600]);
        surf(double(M{1}),'edgecolor','none');
        c=colorbar;
        caxis(caxis);
        title(strrep(inputname(1),'_','\_'));
        m = M{1};
    case 2
        set(f,'position',[50,50,800,600]);
        if size(M{1},3)==3
            p = M{1};
            p = p(:,:,1);
            surf(p,double(M{1}),'edgecolor','none');
        else
            surf(double(M{1}),'edgecolor','none');
            c=colorbar;
            caxis(caxis);
        end
        hold on;
        boundaryTF = M{2};
        boundaryTF(boundaryTF==0)=NaN;
        boundaryTF = boundaryTF * max(max(M{1}(:),10000));
        surf(double(boundaryTF));
        title(strrep(inputname(1),'_','\_'));
        m = M{1};
    case 3
        x = M{1};
        y = M{2};
        limit_x_low = min(x(:));
        limit_x_high = max(x(:));
        limit_y_low = min(y(:));
        limit_y_high = max(y(:));
        set(f,'position',[50,50,800,600]);
        surf(x,y,double(M{3}),'edgecolor','none');
        c=colorbar;
        caxis(caxis); 
        title(strrep(inputname(3),'_','\_'));
        m = M{3};
    case {4,5}
        x = M{1};
        y = M{2};
        limit_x_low = min(x(:));
        limit_x_high = max(x(:));
        limit_y_low = min(y(:));
        limit_y_high = max(y(:));
        set(f,'position',[50,50,800,600]);
        surf(x,y,double(M{3}),'edgecolor','none');
        c=colorbar;
        caxis(caxis);
        hold on;
        boundaryTF = double(M{4});
        boundaryTF(boundaryTF==0)=NaN;
        boundaryTF = boundaryTF * max(max(M{3}(:),10000));
        surf(x,y,double(boundaryTF));
        title(strrep(inputname(3),'_','\_'));
        m = M{3};
end
axis equal;
a=gca;
set(a,'Ydir','reverse','xLim',[limit_x_low,limit_x_high],'yLim',[limit_y_low,limit_y_high]);
view(0,90);
m = m(~isnan(m));
try
    clim = quantile(m,[0.005,0.995]);
    caxis(clim);
end
disableDefaultInteractivity(a);
hold on;
end
