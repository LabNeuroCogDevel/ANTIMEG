% This is the script to plot and test age differences for full TFR.
% Can be used to generate figure 4 and figure 5 in the adolescent paper.
% last update 6.12.2014

load Dev_Spectrum_Data.mat;

% pull data
D1 = Adult_AS_RVLPFC_TFR;
D2 = Teen_AS_RVLPFC_TFR;

%smooth data to facilitate group comparison
spm_smooth(D1,D1,[2,4,0],0); %make sure not to smooth across z dimension (subjects)
spm_smooth(D2,D2,[2,4,0],0);

% cluster statistic test
[S, C, ~, SM, CP, SP, ~] = MEG_Cluster_Stats_th(D1,D2,1000,.0165); % bonferonni corrected


%% plot data
M1 = mean(D1,3);
M2 = mean(D2,3);

%FigTitle = [cell2mat(ROIS(r)), ' AS Power'];
h = figure('visible','on');
pcolor(CTime,FOIs,M1);caxis([-40 40]);
%colorbar
shading flat;
%title(FigTitle, 'FontSize', 24)
line([-1.5,-1.5],[2,60],'LineStyle', '-','LineWidth',1.5,'Color','k');
line([0,0],[2,60],'LineStyle', '--','LineWidth',1.5,'Color','k');%saveas(h, FigTitle, 'jpg');close all;
set(gca,'FontSize',24,'box','on','XGrid','off','YGrid','off');
xlabel('Time (seconds)','FontSize',24);
ylabel('Hz','FontSize',24);
%set(gca,'color','none','yticklabel','')
%set(gca,'color','none','xticklabel','')
axis square;
%set(gca,'color','none')
set(gca, 'LooseInset', [0,0,0,0]);
set(gca, 'Color', 'none');
export_fig A_RVLPFC.tiff -m4 -transparent


%FigTitle = [cell2mat(ROIS(r)), ' PS Power'];;
h = figure('visible','on');
pcolor(CTime,FOIs,M2);caxis([-40 40]);

shading flat;
%title(FigTitle, 'FontSize', 24)
line([-1.5,-1.5],[2,60],'LineStyle', '-','LineWidth',1.5,'Color','k');
line([0,0],[2,60],'LineStyle', '--','LineWidth',1.5,'Color','k');%saveas(h, FigTitle, 'jpg');close all;
set(gca,'FontSize',24,'box','on','XGrid','off','YGrid','off');
xlabel('Time (seconds)','FontSize',24);
ylabel('Hz','FontSize',24);
axis square;
%set(gca,'color','none','yticklabel','')
%set(gca,'color','none','xticklabel','')
c=colorbar;
% Modify Colorbar to a manual setting
set(c,'location','manual','ActivePositionProperty','OuterPosition');
hbarPos = get(c,'OuterPosition');
set(c,'fontsize',24, 'OuterPosition',[hbarPos(1)+0.065 hbarPos(2) hbarPos(3)+0.065 hbarPos(4) ]);
set(gca, 'LooseInset', [0,0,0,0]);
set(gca, 'Color', 'none');
export_fig T_VLPFC.tiff -m4 -transparent

%FigTitle = ['FEF Correct-InCorrect'];
h = figure('visible','on');
pcolor(CTime,FOIs,S.*(SM));caxis([-5 5]);
colorbar;
shading flat;
shading flat;
%title(FigTitle, 'FontSize', 24)
line([-1.5,-1.5],[2,60],'LineStyle', '-','LineWidth',1.5,'Color','k');
line([0,0],[2,60],'LineStyle', '--','LineWidth',1.5,'Color','k');%saveas(h, FigTitle, 'jpg');%close all;
set(gca,'FontSize',24,'box','on','XGrid','off','YGrid','off');
xlabel('Time (seconds)','FontSize',24);
ylabel('Hz','FontSize',24);
axis square;
c=colorbar;
set(gca,'color','none');
set(c,'location','manual','ActivePositionProperty','OuterPosition');
hbarPos = get(c,'OuterPosition');
set(c,'fontsize',24, 'OuterPosition',[hbarPos(1)+0.075 hbarPos(2) hbarPos(3)+0.075 hbarPos(4) ]);
set(gca, 'LooseInset', [0,0,0,0]);
set(gca, 'Color', 'none');
export_fig AvT_RVLPFC.tiff -m4 -transparent

