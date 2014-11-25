% This is the script to plot and test age differences for full TFR.
% Can be used to generate figure 4 and figure 5 in the adolescent paper.
% last update 11.21.2014

clear all
close all
load Dev_Spectrum_Data.mat;
load surrog.mat;

% pull data
%D1 = Adult_AS_FEF_TFR;
%D2 = Teen_AS_FEF_TFR;

%smooth data to facilitate group comparison
spm_smooth(Adult_AS_FEF_TFR,Adult_AS_FEF_TFR,[2,4,0],0); %make sure not to smooth across z dimension (subjects)
spm_smooth(Teen_AS_FEF_TFR,Teen_AS_FEF_TFR,[2,4,0],0);

spm_smooth(Adult_AS_RDLPFC_TFR,Adult_AS_RDLPFC_TFR,[2,4,0],0); 
spm_smooth(Teen_AS_RDLPFC_TFR,Teen_AS_RDLPFC_TFR,[2,4,0],0);

spm_smooth(Adult_AS_RVLPFC_TFR,Adult_AS_RVLPFC_TFR,[2,4,0],0); 
spm_smooth(Teen_AS_RVLPFC_TFR,Teen_AS_RVLPFC_TFR,[2,4,0],0);

%compile data structure
Adult_AS_TFR(1,:,:,:) = Adult_AS_FEF_TFR;
Adult_AS_TFR(2,:,:,:) = Adult_AS_RDLPFC_TFR;
Adult_AS_TFR(3,:,:,:) = Adult_AS_RVLPFC_TFR;

Teen_AS_TFR(1,:,:,:) = Teen_AS_FEF_TFR;
Teen_AS_TFR(2,:,:,:) = Teen_AS_RDLPFC_TFR;
Teen_AS_TFR(3,:,:,:) = Teen_AS_RVLPFC_TFR;

%derive null distribution
nPerm = 1000;
%[Stats, df, ~, surrog]=statcond({Adult_AS_TFR, Teen_AS_TFR},'mode','perm','naccu',nPerm);
%null_data = reshape(surrog,30, 476, 3000);
null_data = surrog; %reshape(surrog,30,20000);

Null_clusts_mass = zeros(size(surrog,1),length(surrog));

%Null_clusts_mass = zeros(length(null_data),1);
tVal = icdf('t',0.975,35);

for roi = 1:size(null_data,1)
    for n = 1:length(null_data)
        nd = squeeze(null_data(roi,:,:,n));
        null_clusts = bwlabeln(abs(nd)>tVal);
        null_clust_mass = sum(abs(nd(null_clusts==1)));
        
        for j = 2:max(null_clusts)
            curr_clust_mass = sum(abs(nd(null_clusts==j)));
            if curr_clust_mass > null_clust_mass
                null_clust_mass = curr_clust_mass;
            end
        end
        Null_clusts_mass(roi,n) = null_clust_mass;
    end
end
Null_clusts_mass = Null_clusts_mass(:);
clust_stat_threshold = quantile(Null_clusts_mass,1-(0.05/18))

%for n = 1:length(null_data)
%    nd = squeeze(null_data(:,:,n));
%    null_clusts = bwlabeln(abs(nd)>tVal);
%    null_clust_mass = sum(abs(nd(null_clusts==1)));
%    
%    for j = 2:max(null_clusts)
%        curr_clust_mass = sum(abs(nd(null_clusts==j)));
%        if curr_clust_mass > null_clust_mass
%            null_clust_mass = curr_clust_mass;
%        end
%    end
%    Null_clusts_mass(n) = null_clust_mass;
%end


% cluster statistic test

D1 = Adult_AS_FEF_TFR;
D2 = Teen_AS_FEF_TFR;

[Stats, df, ~, ~]=statcond({D1 D2},'mode','perm','naccu',nPerm);

test_clusts = bwlabeln(abs(Stats)>tVal);
Test_stat_clusts_mass = zeros(max(max(test_clusts)),1);
for j = 1:max(max(test_clusts))
    Test_stat_clusts_mass(j) = sum(abs(Stats(test_clusts==j)));
    %if curr_clust_mass>test_clusts_mass
    %    test_clusts_mass = curr_clust_mass
    %end
end
Test_stat_clusts_mass

Ps=[];
for n =1:length(Test_stat_clusts_mass)
   Ps(n)=1-sum(Test_stat_clusts_mass(n) > Null_clusts_mass)/length(Null_clusts_mass)
    
end
%Ps > Test_stat_clusts_mass

%[S, C, ~, SM, CP, SP, ~] = MEG_Cluster_Stats_th(D1,D2,1000,.0021); % bonferonni corrected
%[~, ~, ~, ~, ~, ~, Surog1] = MEG_Cluster_Stats_th(Adult_AS_FEF_TFR,Teen_AS_FEF_TFR,1000,.0021); % bonferonni corrected
%[~, ~, ~, ~, ~, ~, Surog2] = MEG_Cluster_Stats_th(D1,D2,1000,.0021); % bonferonni corrected
%[~, ~, ~, ~, ~, ~, Surog3] = MEG_Cluster_Stats_th(D1,D2,1000,.0021); % bonferonni corrected


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
%export_fig A_RVLPFC.tiff -m4 -transparent


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
%export_fig T_VLPFC.tiff -m4 -transparent

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
%export_fig AvT_RVLPFC.tiff -m4 -transparent

