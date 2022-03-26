function [] = make_variant_map_background(varargin)

p = inputParser;
addParameter(p, 'bg', [0.25, 0.25, 0.25]);
addParameter(p, 'tickOff', true);

parse(p, varargin{:});
bg_color = p.Results.bg;
tickOff = p.Results.tickOff;

colors = parula(7);
colors(1,:) = bg_color;
colormap(colors);

a = findall(gcf,'type','Axes');
if tickOff
    set(a,'xTick',[], 'yTick',[], 'fontsize',16);
end
title('');

caxis([-0.5, 6.5]);
c = findall(gcf,'type','Colorbar');
set(c, 'limits', [0.5,6.5]);

