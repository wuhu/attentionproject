%% [hImage hSaliency hFamiliarity] = init_figure
% Method for setting up the figure for display of the process

function [hImage hSaliency hFamiliarity] = init_figure
    figure(1); clf;
    set(gcf,'DefaultAxesTickLength',[0.005 0.01]);
    set(gcf,'DefaultAxesTickDir','out')
    set(gcf,'DefaultAxesbox','off')
    set(gcf,'DefaultAxesLayer','top')
    set(gcf,'DefaultAxesFontSize',10)
    xSize = 25;
    ySize = 15;
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'PaperUnits','centimeters','PaperPosition',[xLeft yTop xSize ySize],'Position',[1000-xSize*30 700-ySize*30 xSize*40 ySize*40])

    colormap(gray(255))

    hImage = axes('position',[0.05 0.05 0.6 0.8]);
    hSaliency = axes('position',[0.7 0.05 0.25 0.425]);
    hFamiliarity = axes('position',[0.7 0.55 0.25 0.425]);
end