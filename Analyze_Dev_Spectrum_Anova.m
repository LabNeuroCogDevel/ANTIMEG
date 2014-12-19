% This is the script to plot and test age differences for full TFR.
% Can be used to generate figure 4 and figure 5 in the adolescent paper.
% last update 11.21.2014

clear all
close all
load Dev_Spectrum.mat;
%load Adult_Power_Spectrum;
%load surrog.mat;
%load test_mat.mat;

% pull data
%D1 = Adult_AS_FEF_TFR;
%D2 = Teen_AS_FEF_TFR;

%smooth data to facilitate group comparison
spm_smooth(Adult_AS_FEF_TFR,Adult_AS_FEF_TFR,[0,2,1],0);
spm_smooth(Teen_AS_FEF_TFR,Teen_AS_FEF_TFR,[0,2,1],0);

spm_smooth(Adult_AS_RFEF_TFR,Adult_AS_RFEF_TFR,[0,2,1],0);
spm_smooth(Teen_AS_RFEF_TFR,Teen_AS_RFEF_TFR,[0,2,1],0);

spm_smooth(Adult_AS_LFEF_TFR,Adult_AS_LFEF_TFR,[0,2,1],0);
spm_smooth(Teen_AS_LFEF_TFR,Teen_AS_LFEF_TFR,[0,2,1],0);

spm_smooth(Adult_AS_RDLPFC_TFR,Adult_AS_RDLPFC_TFR,[0,2,1],0);
spm_smooth(Teen_AS_RDLPFC_TFR,Teen_AS_RDLPFC_TFR,[0,2,1],0);

spm_smooth(Adult_AS_RVLPFC_TFR,Adult_AS_RVLPFC_TFR,[0,2,1],0);
spm_smooth(Teen_AS_RVLPFC_TFR,Teen_AS_RVLPFC_TFR,[0,2,1],0);

spm_smooth(Adult_PS_FEF_TFR,Adult_PS_FEF_TFR,[0,2,1],0);
spm_smooth(Teen_PS_FEF_TFR,Teen_PS_FEF_TFR,[0,2,1],0);

spm_smooth(Adult_PS_RFEF_TFR,Adult_PS_RFEF_TFR,[0,2,1],0);
spm_smooth(Teen_PS_RFEF_TFR,Teen_PS_RFEF_TFR,[0,2,1],0);

spm_smooth(Adult_PS_LFEF_TFR,Adult_PS_LFEF_TFR,[0,2,1],0);
spm_smooth(Teen_PS_LFEF_TFR,Teen_PS_LFEF_TFR,[0,2,1],0);

spm_smooth(Adult_PS_RDLPFC_TFR,Adult_PS_RDLPFC_TFR,[0,2,1],0);
spm_smooth(Teen_PS_RDLPFC_TFR,Teen_PS_RDLPFC_TFR,[0,2,1],0);

spm_smooth(Adult_PS_RVLPFC_TFR,Adult_PS_RVLPFC_TFR,[0,2,1],0); 
spm_smooth(Teen_PS_RVLPFC_TFR,Teen_PS_RVLPFC_TFR,[0,2,1],0);


%compile data structure
Adult_AS_TFR(1,:,:,:) = Adult_AS_RFEF_TFR;
Adult_AS_TFR(2,:,:,:) = Adult_AS_LFEF_TFR;
Adult_AS_TFR(3,:,:,:) = Adult_AS_RDLPFC_TFR;
Adult_AS_TFR(4,:,:,:) = Adult_AS_RVLPFC_TFR;

Adult_PS_TFR(1,:,:,:) = Adult_PS_RFEF_TFR;
Adult_PS_TFR(2,:,:,:) = Adult_PS_LFEF_TFR;
Adult_PS_TFR(3,:,:,:) = Adult_PS_RDLPFC_TFR;
Adult_PS_TFR(4,:,:,:) = Adult_PS_RVLPFC_TFR;

Teen_AS_TFR(1,:,:,:) = Teen_AS_RFEF_TFR;
Teen_AS_TFR(2,:,:,:) = Teen_AS_LFEF_TFR;
Teen_AS_TFR(3,:,:,:) = Teen_AS_RDLPFC_TFR;
Teen_AS_TFR(4,:,:,:) = Teen_AS_RVLPFC_TFR;

Teen_PS_TFR(1,:,:,:) = Teen_PS_RFEF_TFR;
Teen_PS_TFR(2,:,:,:) = Teen_PS_LFEF_TFR;
Teen_PS_TFR(3,:,:,:) = Teen_PS_RDLPFC_TFR;
Teen_PS_TFR(4,:,:,:) = Teen_PS_RVLPFC_TFR;

%stats....
nPerm = 4000;
criticalP = 0.05/12;

D1 = Adult_AS_RDLPFC_TFR;
D2 = Adult_PS_RDLPFC_TFR;
D3 = Teen_AS_RDLPFC_TFR;
D4 = Teen_PS_RDLPFC_TFR;

[Stats, df, ps, surrog] ...
    =statcond({D1, D2 ; D3, D4}, ...
    'mode','bootstrap','naccu',nPerm);

for contrasts = 1:3
    
    null_data = surrog{contrasts}; %reshape(surrog,30,20000);
    
    Null_clusts_mass = zeros(size(null_data,1),length(null_data));
    
    %Null_clusts_mass = zeros(length(null_data),1);
    tVal = icdf('f',0.975,df{contrasts}(1),df{contrasts}(2));
    
    % for roi = 1:size(null_data,1)
    %     for n = 1:length(null_data)
    %         nd = squeeze(null_data(roi,:,:,n));
    %         null_clusts = bwlabeln(abs(nd)>tVal);
    %         null_clust_mass = sum(abs(nd(null_clusts==1)));
    %
    %         for j = 2:max(null_clusts)
    %             curr_clust_mass = sum(abs(nd(null_clusts==j)));
    %             if curr_clust_mass > null_clust_mass
    %                 null_clust_mass = curr_clust_mass;
    %             end
    %         end
    %         Null_clusts_mass(roi,n) = null_clust_mass;
    %     end
    % end
    
    
    
    for n = 1:length(null_data)
        nd = squeeze(null_data(:,:,n));
        null_clusts = bwlabeln(abs(nd)>tVal);
        null_clust_mass = sum(abs(nd(null_clusts==1)));
        
        for j = 2:max(null_clusts)
            curr_clust_mass = sum(abs(nd(null_clusts==j)));
            if curr_clust_mass > null_clust_mass
                null_clust_mass = curr_clust_mass;
            end
        end
        Null_clusts_mass(n) = null_clust_mass;
    end
    Null_clusts_mass(Null_clusts_mass==0) = [];%
    Null_clusts_mass = Null_clusts_mass(:);
    clust_stat_threshold = quantile(Null_clusts_mass,1-criticalP)
    
    % cluster statistic test
    
    %D1 = Adult_AS_FEF_TFR;
    %D2 = Adult_PS_FEF_TFR;
    
    %[Stats, df, ~, ~]=statcond({D1 D2},'mode','perm','naccu',nPerm);
    
    test_clusts = bwlabeln(abs(Stats{contrasts})>tVal);
    Test_stat_clusts_mass = zeros(max(max(test_clusts)),1);
    for j = 1:max(max(test_clusts))
        Test_stat_clusts_mass(j) = sum(abs(Stats{contrasts}(test_clusts==j)));
        %if curr_clust_mass>test_clusts_mass
        %    test_clusts_mass = curr_clust_mass
        %end
    end
    %Test_stat_clusts_mass
    
    Ps=[];
    for n =1:length(Test_stat_clusts_mass)
        Ps(n)=1-sum(Test_stat_clusts_mass(n) > Null_clusts_mass)/length(Null_clusts_mass);
        
    end
    %Ps%
    %Ps > Test_stat_clusts_mass
    
    sig_clust_num = find(Ps<criticalP)
    Ps(sig_clust_num)
    %if any(sig_clust_num)
    CM=zeros(size(Stats{contrasts}));
    for i=1:length(sig_clust_num)
        tempclust = test_clusts==sig_clust_num(i);
        CM=CM+tempclust;
        
    end
    figure;
    Data=Stats{contrasts}.*(CM);
    pcolor(CTime,FOIs,double(Data));colormap summer; ...
        caxis([0 25]); shading flat; y=colorbar; ylabel(y, '\itF', 'FontSize', 20);
    line([-1.5,-1.5],[2,60],'LineStyle', '-','LineWidth',2,'Color','w');
    line([0,0],[2,60],'LineStyle', '--','LineWidth',2,'Color','w');
    set(gca,'FontSize',20,'box','on','XGrid','off','YGrid','off');
    set(gcf,'Renderer','openGL');
    ylabel('Hz','FontSize',20);
    axis square;
    set(gca, 'LooseInset', [0,0,0,0]);
    set(gca, 'Color', 'white');
    %export_fig Interac_RFEF.tiff -m4 -transparent
    %end
end
%[S, C, ~, SM, CP, SP, ~] = MEG_Cluster_Stats_th(D1,D2,1000,.0021); % bonferonni corrected
%[~, ~, ~, ~, ~, ~, Surog1] = MEG_Cluster_Stats_th(Adult_AS_FEF_TFR,Teen_AS_FEF_TFR,1000,.0021); % bonferonni corrected
%[~, ~, ~, ~, ~, ~, Surog2] = MEG_Cluster_Stats_th(D1,D2,1000,.0021); % bonferonni corrected
%[~, ~, ~, ~, ~, ~, Surog3] = MEG_Cluster_Stats_th(D1,D2,1000,.0021); % bonferonni corrected

alpha = 5:9;
beta = 10:16; 
figure;
H1=shadedErrorBar(CTime,squeeze(mean(D1(beta,:,:)))',{@mean,@ste},{'-','LineWidth',4,'Color',rgb('red')},1);
hold on
H2=shadedErrorBar(CTime,squeeze(mean(D2(beta,:,:)))',{@mean,@ste},{'-','LineWidth',4,'Color',rgb('blue')},1);
H3=shadedErrorBar(CTime,squeeze(mean(D3(beta,:,:)))',{@mean,@ste},{'--','LineWidth',4,'Color',rgb('red')},1);
H4=shadedErrorBar(CTime,squeeze(mean(D4(beta,:,:)))',{@mean,@ste},{'--','LineWidth',4,'Color',rgb('blue')},1);
%hl=legend([H1.mainLine,H2.mainLine,H3.mainLine, H4.mainLine ],'Adult AS ','Adult PS', 'Adolescent AS','Adolescent PS','Location','North' );
%set(hl,'FontSize', 24, 'Box','off');
%legend boxoff
set(gca,'FontSize',20,'box','off','XGrid','off','YGrid','off')
set(gcf,'Renderer','openGL')
xlim([-1.66, 0.176])
ylim([-15 60])
%line([-1.5,-1.5],[-10,80],'LineStyle', '-','LineWidth',2,'Color','k');
%line([0,0],[-10,80],'LineStyle', '--','LineWidth',2,'Color','k');

%xlabel(' \bTime ','FontSize',20)
ylabel('% signal change from baseline','FontSize',20)
%set(hl,'FontSize', 24, 'Box','off');
set(gca,'linewidth',2);
axis square


%do stats
[ Stats, Clusters, Clust_Masks, Sig_Mask, Clust_Pvals,Sig_Pvals, Null_clusts_mass ]...
    = MEG_Cluster_Stats_th( squeeze(mean(D1(beta,:,:))), squeeze(mean(D2(beta,:,:))), 1000, .05);
%
if any(Sig_Pvals)
    [si,ei] = find_con(Sig_Mask);
    for i=1:length(si)
        line([CTime(si(i)),CTime(ei(i))],[45 45],'LineStyle', '-','LineWidth',2,'Color',rgb('gray'));
    end
    
end

[ Stats, Clusters, Clust_Masks, Sig_Mask, Clust_Pvals,Sig_Pvals, Null_clusts_mass ]...
    = MEG_Cluster_Stats_th( squeeze(mean(D1(beta,:,:))), squeeze(mean(D3(beta,:,:))), 1000, .05);
%
if any(Sig_Pvals)
    [si,ei] = find_con(Sig_Mask);
    for i=1:length(si)
        line([CTime(si(i)),CTime(ei(i))],[50 50],'LineStyle', '-','LineWidth',2,'Color',rgb('black'));
    end
    
end

[ Stats, Clusters, Clust_Masks, Sig_Mask, Clust_Pvals,Sig_Pvals, Null_clusts_mass ]...
    = MEG_Cluster_Stats_th( squeeze(mean(D3(beta,:,:))), squeeze(mean(D4(beta,:,:))), 1000, .05);
%
if any(Sig_Pvals)
    [si,ei] = find_con(Sig_Mask);
    for i=1:length(si)
        line([CTime(si(i)),CTime(ei(i))],[40 40],'LineStyle', '-','LineWidth',2,'Color',rgb('light gray'));
    end
    
end
%set(gca, 'LooseInset', [0,0,0,0]);
set(gca, 'Color', 'white');
%export_fig('test.png', '-r600,''-opengl');
%export_fig alpha_ts_RFEF.tiff -m4 -transparent
%export_fig legend.tiff -m4 -transparent
%% plot data
%
%
%
% M1 = mean(D1,3);
% M2 = mean(D2,3);
%
% %FigTitle = [cell2mat(ROIS(r)), ' AS Power'];
% h = figure('visible','on');
% pcolor(CTime,FOIs,M1);caxis([-40 40]);
% %colorbar
% shading flat;
% %title(FigTitle, 'FontSize', 24)
% line([-1.5,-1.5],[2,60],'LineStyle', '-','LineWidth',1.5,'Color','k');
% line([0,0],[2,60],'LineStyle', '--','LineWidth',1.5,'Color','k');%saveas(h, FigTitle, 'jpg');close all;
% set(gca,'FontSize',24,'box','on','XGrid','off','YGrid','off');
% xlabel('Time (seconds)','FontSize',24);
% ylabel('Hz','FontSize',24);
% %set(gca,'color','none','yticklabel','')
% %set(gca,'color','none','xticklabel','')
% axis square;
% %set(gca,'color','none')
% set(gca, 'LooseInset', [0,0,0,0]);
% set(gca, 'Color', 'none');
% %export_fig A_RVLPFC.tiff -m4 -transparent
%
%
% %FigTitle = [cell2mat(ROIS(r)), ' PS Power'];;
% h = figure('visible','on');
% pcolor(CTime,FOIs,M2);caxis([-40 40]);
%
% shading flat;
% %title(FigTitle, 'FontSize', 24)
% line([-1.5,-1.5],[2,60],'LineStyle', '-','LineWidth',1.5,'Color','k');
% line([0,0],[2,60],'LineStyle', '--','LineWidth',1.5,'Color','k');%saveas(h, FigTitle, 'jpg');close all;
% set(gca,'FontSize',24,'box','on','XGrid','off','YGrid','off');
% xlabel('Time (seconds)','FontSize',24);
% ylabel('Hz','FontSize',24);
% axis square;
% %set(gca,'color','none','yticklabel','')
% %set(gca,'color','none','xticklabel','')
% c=colorbar;
% % Modify Colorbar to a manual setting
% set(c,'location','manual','ActivePositionProperty','OuterPosition');
% hbarPos = get(c,'OuterPosition');
% set(c,'fontsize',24, 'OuterPosition',[hbarPos(1)+0.065 hbarPos(2) hbarPos(3)+0.065 hbarPos(4) ]);
% set(gca, 'LooseInset', [0,0,0,0]);
% set(gca, 'Color', 'none');
% %export_fig T_VLPFC.tiff -m4 -transparent
%
% %FigTitle = ['FEF Correct-InCorrect'];
% h = figure('visible','on');
% pcolor(CTime,FOIs,S.*(SM));caxis([-5 5]);
% colorbar;
% shading flat;
% shading flat;
% %title(FigTitle, 'FontSize', 24)
% line([-1.5,-1.5],[2,60],'LineStyle', '-','LineWidth',1.5,'Color','k');
% line([0,0],[2,60],'LineStyle', '--','LineWidth',1.5,'Color','k');%saveas(h, FigTitle, 'jpg');%close all;
% set(gca,'FontSize',24,'box','on','XGrid','off','YGrid','off');
% xlabel('Time (seconds)','FontSize',24);
% ylabel('Hz','FontSize',24);
% axis square;
% c=colorbar;
% set(gca,'color','none');
% set(c,'location','manual','ActivePositionProperty','OuterPosition');
% hbarPos = get(c,'OuterPosition');
% set(c,'fontsize',24, 'OuterPosition',[hbarPos(1)+0.075 hbarPos(2) hbarPos(3)+0.075 hbarPos(4) ]);
% set(gca, 'LooseInset', [0,0,0,0]);
% set(gca, 'Color', 'none');
% %export_fig AvT_RVLPFC.tiff -m4 -transparent

