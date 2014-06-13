% This is the script to plot and test full TFR.
% Note the power values were derived from the script MEG_Power.m
% last update 06.10.2014

load Adult_Power_Spectrum.mat

%select the data to plot
D1 = Adult_AS_RDLPFC_TFR;
D2 = Adult_PS_RDLPFC_TFR;

%script for time frequency grid smoothing
% note only for developmental comparison we did smoothing.
% for n = 1:size(D1,3)
%     %         temp=squeeze(D1(:,:,n));
%     %         spm_smooth(temp,temp,[2,3,1],0);
%     %         D1(:,:,n)= temp;
%     %         temp=squeeze(D2(:,:,n));
%     %         spm_smooth(temp,temp,[2,3,1],0);
%     %         D2(:,:,n)= temp;
% end


% cluster statistic test
[S, C, ~, SM, CP, SP, ~] = MEG_Cluster_Stats_th(D1,D2,1000,.05);

M1 = mean(D1,3);
M2 = mean(D2,3);

%plotting
FigTitle = [cell2mat(ROIS(r)), ' AS Power'];
h = figure('visible','on')
pcolor(CTime,FOIs,M1);caxis([-40 40])
%colorbar
shading flat
%title(FigTitle, 'FontSize', 24)
line([-1.5,-1.5],[2,60],'LineStyle', '-','LineWidth',1.5,'Color','k')
line([0,0],[2,60],'LineStyle', '--','LineWidth',1.5,'Color','k');%saveas(h, FigTitle, 'jpg');close all;
set(gca,'FontSize',24,'box','on','XGrid','off','YGrid','off')
xlabel('Time (seconds)','FontSize',24)
ylabel('Hz','FontSize',24)
%set(gca,'color','none','yticklabel','')
%set(gca,'color','none','xticklabel','')
axis square
%set(gca,'color','none')
set(gca, 'LooseInset', [0,0,0,0]);
set(gca, 'Color', 'none');
%export_fig A_IFG.tiff -m4 -transparent
%print(gcf, strcat('Adult_C_TFR_FEF'), '-dtiff  ', '-r300')


FigTitle = [cell2mat(ROIS(r)), ' PS Power'];;
h = figure('visible','on')
pcolor(CTime,FOIs,M2);caxis([-40 40])

shading flat
%title(FigTitle, 'FontSize', 24)
line([-1.5,-1.5],[2,60],'LineStyle', '-','LineWidth',1.5,'Color','k')
line([0,0],[2,60],'LineStyle', '--','LineWidth',1.5,'Color','k');%saveas(h, FigTitle, 'jpg');close all;
set(gca,'FontSize',24,'box','on','XGrid','off','YGrid','off')
xlabel('Time (seconds)','FontSize',24)
ylabel('Hz','FontSize',24)
axis square
%set(gca,'color','none','yticklabel','')
%set(gca,'color','none','xticklabel','')
c=colorbar;
% Modify Colorbar to a manual setting
set(c,'location','manual','ActivePositionProperty','OuterPosition');
hbarPos = get(c,'OuterPosition')
set(c,'fontsize',24, 'OuterPosition',[hbarPos(1)+0.065 hbarPos(2) hbarPos(3)+0.065 hbarPos(4) ]);
set(gca, 'LooseInset', [0,0,0,0]);
set(gca, 'Color', 'none');
export_fig T_MFG.tiff -m4 -transparent
%print(gcf, strcat('Adult_IC_TFR_FEF'), '-dtiff  ', '-r300')

%FigTitle = ['FEF Correct-InCorrect'];
h = figure('visible','on')
pcolor(CTime,FOIs,S.*(SM));caxis([-5 5])
colorbar
shading flat
shading flat
%title(FigTitle, 'FontSize', 24)
line([-1.5,-1.5],[2,60],'LineStyle', '-','LineWidth',1.5,'Color','k')
line([0,0],[2,60],'LineStyle', '--','LineWidth',1.5,'Color','k');%saveas(h, FigTitle, 'jpg');%close all;
set(gca,'FontSize',24,'box','on','XGrid','off','YGrid','off')
xlabel('Time (seconds)','FontSize',24)
ylabel('Hz','FontSize',24)
axis square
c=colorbar;
set(gca,'color','none');
set(c,'location','manual','ActivePositionProperty','OuterPosition');
hbarPos = get(c,'OuterPosition')
set(c,'fontsize',24, 'OuterPosition',[hbarPos(1)+0.075 hbarPos(2) hbarPos(3)+0.075 hbarPos(4) ]);
set(gca, 'LooseInset', [0,0,0,0]);
set(gca, 'Color', 'none');
%export_fig AvT_IFG.tiff -m4 -transparent
%print(gcf, strcat('Adult_C-IC_TFR_rFEF'), '-dtiff  ', '-r300')

