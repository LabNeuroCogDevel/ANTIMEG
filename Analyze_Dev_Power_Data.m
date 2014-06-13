% This is a plotting script to analyze the local power task modulation for
% adult subjects. This was what presented in Figure 3.
% It will make figures showing power spectrum. X is Hz, y is signal change.

% note spectrum power was calculated using MEG_power.m
%last update 6.13.2014

%load data
load Dev_Power_Data

%plot
H=figure('visible','on');

%extract data to plot
D1=Teen_AS_RVLPFC;
D2=Teen_PS_RVLPFC;

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

H1=shadedErrorBar(FOIs,D1,{@mean,@ste},{'-','LineWidth',4,'Color',rgb('Red')},1);
hold on
H2=shadedErrorBar(FOIs,D2,{@mean,@ste},{'-','LineWidth',4,'Color',rgb('Blue')},1);

hl=legend([H1.mainLine,H2.mainLine],'Adult AS ','Adult PS','Location','Northeast' );
ylim([-10 80])
set(gca,'FontSize',24,'box','off','XGrid','off','YGrid','off')
set(gcf,'Renderer','openGL')
axis square

xlabel('Hz','FontSize',24)
ylabel('% signal change from baseline','FontSize',24)
set(hl,'FontSize', 24, 'Box','off');
set(gca,'linewidth',10);
%set(gca,'xtick',[])
%set(gca,'ytick',[])
%axes('fontsize',16);
%title('Right DLPFC')
%title('Right VLPFC')
%title(ROIS{r})

%do stats
% [ Stats, Clusters, Clust_Masks, Sig_Mask, Clust_Pvals,Sig_Pvals, Null_clusts_mass ] = MEG_Cluster_Stats_th( D1', D2', 2000, .05);
% 
% if any(Sig_Pvals)
%     [si,ei] = find_con(Sig_Mask)
%     for i=1:length(si)
%         line([FOIs(si(i)),FOIs(ei(i))],[50 50],'LineStyle', '-','LineWidth',20,'Color','k');
%     end
%     
% end
set(gcf, 'Color', 'white');
%export_fig T_VLPFC.tiff -m4 -transparent
