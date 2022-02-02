% use this as 'caxis' to set caxis for plot made by 'myplotm'

function [] = caxism(clim)
    cmap = colormap();
    step = (clim(2)-clim(1))/(size(cmap,1)-2);
    caxis(clim + [-step, step]);
end