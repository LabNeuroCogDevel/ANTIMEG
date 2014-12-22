% This is a plotting script to analyze the task modulation of power for each age group.
% It will make figures showing power spectrum. X is Hz, y is signal change.

% note spectrum power was calculated using MEG_power.m
%last update 6.13.2014
% 11.20.2014 edits to address reviewer comments. Specifically. Instead of
% permuting and testing each ROIs separately. Now we will try to do it in
% one single model. 

clear all;
close all;

%load data
load Dev_Power_Data

%smooth
spm_smooth(Adult_AS_RFEF,Adult_AS_RFEF,[1,2,0],0);
spm_smooth(Adult_AS_LFEF,Adult_AS_LFEF,[1,2,0],0);
spm_smooth(Adult_AS_RDLPFC,Adult_AS_RDLPFC,[1,2,0],0);
spm_smooth(Adult_AS_RVLPFC,Adult_AS_RVLPFC,[1,2,0],0);
spm_smooth(Adult_PS_RFEF,Adult_PS_RFEF,[1,2,0],0);
spm_smooth(Adult_PS_LFEF,Adult_PS_LFEF,[1,2,0],0);
spm_smooth(Adult_PS_RDLPFC,Adult_PS_RDLPFC,[1,2,0],0);
spm_smooth(Adult_PS_RVLPFC,Adult_PS_RVLPFC,[1,2,0],0);

spm_smooth(Teen_AS_RFEF,Teen_AS_RFEF,[1,2,0],0);
spm_smooth(Teen_AS_LFEF,Teen_AS_LFEF,[1,2,0],0);
spm_smooth(Teen_AS_RDLPFC,Teen_AS_RDLPFC,[1,2,0],0);
spm_smooth(Teen_AS_RVLPFC,Teen_AS_RVLPFC,[1,2,0],0);
spm_smooth(Teen_PS_RFEF,Teen_PS_RFEF,[1,2,0],0);
spm_smooth(Teen_PS_LFEF,Teen_PS_LFEF,[1,2,0],0);
spm_smooth(Teen_PS_RDLPFC,Teen_PS_RDLPFC,[1,2,0],0);
spm_smooth(Teen_PS_RVLPFC,Teen_PS_RVLPFC,[1,2,0],0);
%compile data into single structure for permutation
%recompile data into the following format ROIxpowerxsubject


Adult_AS_Power = [Adult_AS_RFEF, Adult_AS_LFEF, Adult_AS_RDLPFC, Adult_AS_RVLPFC ];
Adult_AS_Power = reshape(Adult_AS_Power,20,30,4);
Adult_AS_Power = permute(Adult_AS_Power,[3,2,1]);

Adult_PS_Power = [Adult_PS_RFEF, Adult_PS_LFEF, Adult_PS_RDLPFC, Adult_PS_RVLPFC];
Adult_PS_Power = reshape(Adult_PS_Power,20,30,4);
Adult_PS_Power = permute(Adult_PS_Power,[3,2,1]);

Teen_AS_Power = [Teen_AS_RFEF, Teen_AS_LFEF, Teen_AS_RDLPFC, Teen_AS_RVLPFC ];
Teen_AS_Power = reshape(Teen_AS_Power,17,30,4);
Teen_AS_Power = permute(Teen_AS_Power,[3,2,1]);

Teen_PS_Power = [Teen_PS_RFEF, Teen_PS_LFEF, Teen_PS_RDLPFC, Teen_PS_RVLPFC];
Teen_PS_Power = reshape(Teen_PS_Power,17,30,4);
Teen_PS_Power = permute(Teen_PS_Power,[3,2,1]);

%find the min cluster stat from permutation

nPerm= 5000;
[~, df, ~, surrog]=statcond({Teen_PS_Power Adult_PS_Power},'mode','perm','naccu',nPerm);
tVal = icdf('t',0.99,df);
null_data = reshape(surrog,30,20000);

Null_clusts_mass = zeros(length(null_data),1);
for n = 1:length(null_data)
    nd = squeeze(null_data(:,n));
    null_clusts = bwlabeln(abs(nd)>tVal);
    null_clust_mass = sum(abs(nd(null_clusts==1)));
    
    for j = 2:max(null_clusts)
        curr_clust_mass = sum(abs(null_data(null_clusts==j)));
        if curr_clust_mass > null_clust_mass
            null_clust_mass = curr_clust_mass;
        end
    end
    Null_clusts_mass(n) = null_clust_mass;
end

clust_stat_threshold = quantile(Null_clusts_mass,1-0.05/8)

[Stats, df, ~, ~]=statcond({Adult_AS_RFEF' Adult_PS_RFEF'},'mode','perm','naccu',nPerm);
%tVal = icdf('t',0.975,df);
test_clusts = bwlabeln(abs(Stats)>tVal)

%find the test clusters
%test_clusts_mass = sum(abs(stats(test_clusts==1)))
Test_stat_clusts_mass = zeros(max(max(test_clusts)),1);
for j = 1:max(max(test_clusts))
    Test_stat_clusts_mass(j) = sum(abs(Stats(test_clusts==j)));
    %if curr_clust_mass>test_clusts_mass
    %    test_clusts_mass = curr_clust_mass
    %end
end
Test_stat_clusts_mass

%plot

H=figure('visible','on');

%extract data to plot
D1=Teen_PS_RFEF;
D2=Adult_PS_RFEF;

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

H1=shadedErrorBar(FOIs,D1,{@mean,@ste},{'-','LineWidth',4,'Color',rgb('red')},1);
hold on
H2=shadedErrorBar(FOIs,D2,{@mean,@ste},{'-','LineWidth',4,'Color',rgb('blue')},1);

hl=legend([H1.mainLine,H2.mainLine],'Adult AS ','Adult PS','Location','Northeast' );
ylim([-10 80]);
set(gca,'FontSize',24,'box','off','XGrid','off','YGrid','off');
set(gcf,'Renderer','openGL');
axis square;

xlabel('Hz','FontSize',24);
ylabel('% signal change from baseline','FontSize',24);
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