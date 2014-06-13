% This is the script to plot power power amplitude coupling.

load Adult_PowPower_Coupling_data.mat

%% stats and plot
FOIs=2:2:40;

AAA=shiftdim(Adult_AS_PowerCoupling_DLPFC_FEF,1);
VVV=shiftdim(Adult_PS_PowerCoupling_DLPFC_FEF,1);
[ Stats, Clusters, Clust_Masks, Sig_Mask, Clust_Pvals, Sig_Pvals, Null_clusts_mass ] = MEG_Cluster_Stats_th( AAA, VVV, 1000, .1);

if any(Sig_Pvals)
    figure
    pcolor(FOIs(1:20),FOIs(1:20),squeeze(mean(Adult_AS_PowerCoupling_DLPFC_FEF(:,1:20,1:20))));
    caxis([-.3 .3]);
    shading flat
    %colorbar
    title('AS','FontSize', 24)
    axis xy
    set(gca,'FontSize',18,'box','on','XGrid','off','YGrid','off')
    axis square
    xlabel('DLPFC Hz','FontSize',24)
    ylabel('FEF Hz','FontSize',24)
    set(gca,'color','none')
    set(gca, 'LooseInset', [0,0,0,0]);
    %print(gcf, 'PowPowCorr_AS_Adult', '-dpng  ', '-r300')
    set(gca, 'Color', 'none');
    %export_fig A_PPCorr.png -r300 -transparent
    
    figure
    pcolor(FOIs(1:20),FOIs(1:20),squeeze(mean(Adult_PS_PowerCoupling_DLPFC_FEF(:,1:20,1:20))));
    caxis([-.3 .3]);
    shading flat
    c=colorbar
    title('PS','FontSize', 24)
    axis xy
    set(gca,'FontSize',18,'box','on','XGrid','off','YGrid','off')
    xlabel('DLPFC Hz','FontSize',24)
    ylabel('FEF Hz','FontSize',24)
    axis square
    set(gca,'color','none')
    set(c,'location','manual','ActivePositionProperty','OuterPosition');
    hbarPos = get(c,'OuterPosition')
    set(c,'fontsize',22, 'OuterPosition',[hbarPos(1)+0.075 hbarPos(2) hbarPos(3)+0.008 hbarPos(4) ]);
    set(gca, 'LooseInset', [0,0,0,0]);
    %print(gcf, 'PowPowCorr_AS_Teen', '-dpng  ', '-r300')
    set(gca, 'Color', 'none');
    %export_fig T_PPCorr.png -r300 -transparent
    
    figure
    pcolor(FOIs(1:20),FOIs(1:20),Stats.*Sig_Mask);
    caxis([-3 3]);
    shading flat
    c=colorbar
    title('AS-PS','FontSize', 24')
    axis xy
    set(gca,'FontSize',18,'box','on','XGrid','off','YGrid','off')
    xlabel('DLPFC Hz','FontSize',24)
    ylabel('FEF Hz','FontSize',24)
    axis square
    set(gca,'color','none')
    set(c,'location','manual','ActivePositionProperty','OuterPosition');
    hbarPos = get(c,'OuterPosition')
    set(c,'fontsize',24, 'OuterPosition',[hbarPos(1)+0.075 hbarPos(2) hbarPos(3)+0.008 hbarPos(4) ]);
    set(gca, 'LooseInset', [0,0,0,0]);
    %print(gcf, 'PowPowCorr_AvT', '-dpng  ', '-r300')
    set(gca, 'Color', 'none');
    %export_fig AvT_PPCorr.png -r300 -transparent
    
end





