% This is the script to analyze cross frequency coupling and generate figures.
% The procedure is the same for AS v PS or Adults v Adolescents, just swap
% variable names.
% last update 6.12.2014

%load data
%load PowPow_Corr_Data.mat;

%% Run TFR to extract single trial power timecourses
% Note, for connectivity analysis, we did not use wavelet instead using a
% hannig tapper to control for temporal smoothing across frequency. Below
% is the somewhat messy code of how this was done. This was done using
% the filedtrip package.

% cfg =[];
% cfg.output ='pow';
% cfg.method ='mtmconvol';
% cfg.taper = 'hanning';
% %cfg.pad = 6;
% cfg.foi = 2:2:60;
% cfg.t_ftimwin = ones(length(cfg.foi),1).*0.2;
% cfg.toi = -2.3:0.05:0.6;
% cfg.keeptrials = 'yes';
% 
% 
% for n =1:length(ANTISubData)
%     TFR_ANTI{n}=ft_freqanalysis(cfg,ANTISubData{n});
%     TFR_VGS{n}=ft_freqanalysis(cfg,VGSSubData{n});
% end
% 
% cfg=[];
% cfg.baseline=[-2.0 -1.7];
% cfg.baselinetype='relchange';
% 
% for n =1:length(ANTISubData)
%     TFR_ANTI{n}=ft_freqbaseline(cfg,TFR_ANTI{n});
%     TFR_VGS{n}=ft_freqbaseline(cfg,TFR_VGS{n});
% end


%% correlate trial averaged power timecourses across frequencies
%clear Adult_AS_mCORR Adult_PS_mCORR Teen_AS_mCORR Teen_PS_mCORR;
%
% %adults
% i=1;
% for s = 1:20
%     v = find(ANTISubData{s}.trialinfo==1);
%     it=sort(v(randsample(length(v),47))); %adults 85 trials, group comparison 47
%     for r1 = 1:10
%         for r2=1:10
%             
%             t1= squeeze(nanmean(TFR_ANTI{s}.powspctrm(it,r1,:,17:47))); %only extracting prep timecourses
%             t2= squeeze(nanmean(TFR_ANTI{s}.powspctrm(it,r2,:,17:47)));
%             Adult_AS_mCORR{i}(r1,r2,:,:)=corr(t1',t2');
%             
%         end
%     end
%     i=i+1;
% end
% 
% i=1;
% for s = 1:20
%     v = find(VGSSubData{s}.trialinfo==1);
%     it=sort(v(randsample(length(v),47)));
%     for r1 = 1:10
%         for r2=1:10
%             
%             t1= squeeze(nanmean(TFR_VGS{s}.powspctrm(it,r1,:,17:47)));
%             t2= squeeze(nanmean(TFR_VGS{s}.powspctrm(it,r2,:,17:47)));
%             Adult_PS_mCORR{i}(r1,r2,:,:)=corr(t1',t2');
%             
%         end
%     end
%     i=i+1;
%     
% end
% 
% i=1;
% %adolescents
% for s = 21:37
%     v = find(ANTISubData{s}.trialinfo==1);
%     it=sort(v(randsample(length(v),47))); %adults 85 trials, group comparison 47
%     for r1 = 1:10
%         for r2=1:10
%             
%             t1= squeeze(nanmean(TFR_ANTI{s}.powspctrm(it,r1,:,17:47))); %only extracting prep timecourses
%             t2= squeeze(nanmean(TFR_ANTI{s}.powspctrm(it,r2,:,17:47)));
%             Teen_AS_mCORR{i}(r1,r2,:,:)=corr(t1',t2');
%             
%         end
%     end
%     i=i+1;
% end
% 
% i=1;
% for s = 21:37
%     v = find(VGSSubData{s}.trialinfo==1);
%     it=sort(v(randsample(length(v),47)));
%     for r1 = 1:10
%         for r2=1:10
%             
%             t1= squeeze(nanmean(TFR_VGS{s}.powspctrm(it,r1,:,17:47)));
%             t2= squeeze(nanmean(TFR_VGS{s}.powspctrm(it,r2,:,17:47)));
%             Teen_PS_mCORR{i}(r1,r2,:,:)=corr(t1',t2');
%             
%         end
%     end
%     i=i+1;
%     
% end
% 
% %extract correlation matrices
% Adult_AS_CORR=[];
% Adult_PS_CORR=[];
% Teen_AS_CORR=[];
% Teen_PS_CORR=[];
% 
% %adult
% i=1;
% for s = 1:20
%     Adult_AS_CORR(i,:,:,:,:)=squeeze((Adult_AS_mCORR{s}(:,:,:,:))); %this is to pool r matrix from each subject, where r was calcuated by time averaged power TS
%     Adult_PS_CORR(i,:,:,:,:)=squeeze((Adult_PS_mCORR{s}(:,:,:,:)));
%     i=i+1;
% end
% %adolescent
% i=1;
% for s = 1:17
%     Teen_AS_CORR(i,:,:,:,:)=squeeze((Teen_AS_mCORR{s}(:,:,:,:))); %this is to pool r matrix from each subject, where r was calcuated by time averaged power TS
%     Teen_PS_CORR(i,:,:,:,:)=squeeze((Teen_PS_mCORR{s}(:,:,:,:)));
%     i=i+1;
% end

%% stats and plot

FOIs=2:2:60;
for r1=9 %DLPFC
    for r2=6 %FEF
        A=squeeze(Adult_AS_CORR(:,r1,r2,1:30,1:30)); %select matrices to plot and run stats on
        V=squeeze(Teen_AS_CORR(:,r1,r2,1:30,1:30));  
        
        AAA=shiftdim(A,1); %the dimension to be permuted has to be at the end.
        VVV=shiftdim(V,1);
        [ Stats, Clusters, Clust_Masks, Sig_Mask, Clust_Pvals, Sig_Pvals, Null_clusts_mass ] = MEG_Cluster_Stats_th( AAA, VVV, 1000, .05);
        
        if any(Sig_Pvals);
        figure;
        pcolor(FOIs(1:30),FOIs(1:30),squeeze(mean(A(:,1:30,1:30))));
        caxis([-.3 .3]);
        shading flat;
        %colorbar;
        title('Adults AS','FontSize', 24);
        axis xy;
        set(gca,'FontSize',18,'box','on','XGrid','off','YGrid','off');
        axis square;
        xlabel('DLPFC Hz','FontSize',24);
        ylabel('FEF Hz','FontSize',24);
        set(gca,'color','none');
        set(gca, 'LooseInset', [0,0,0,0]);
        %print(gcf, 'PowPowCorr_AS_Adult', '-dpng  ', '-r300')
        set(gca, 'Color', 'none');
        export_fig A_PPCorr.tiff -m4 -painters
        
        figure;
        pcolor(FOIs(1:30),FOIs(1:30),squeeze(mean(V(:,1:30,1:30))));
        caxis([-.3 .3]);
        shading flat;
        c=colorbar;
        title('Adolescents AS','FontSize', 24);
        axis xy;
        set(gca,'FontSize',18,'box','on','XGrid','off','YGrid','off');
        xlabel('DLPFC Hz','FontSize',24);
        ylabel('FEF Hz','FontSize',24);
        axis square;
        set(gca,'color','none');
        set(c,'location','manual','ActivePositionProperty','OuterPosition');
        hbarPos = get(c,'OuterPosition');
        set(c,'fontsize',22, 'OuterPosition',[hbarPos(1)+0.075 hbarPos(2) hbarPos(3)+0.008 hbarPos(4) ]);
        set(gca, 'LooseInset', [0,0,0,0]);
        %print(gcf, 'PowPowCorr_AS_Teen', '-dpng  ', '-r300');
        set(gca, 'Color', 'none');
        export_fig T_PPCorr.tiff -m4 -painters
        
        figure;
        pcolor(FOIs(1:30),FOIs(1:30),Stats.*Sig_Mask);
        caxis([-3 3]);
        shading flat;
        c=colorbar;
        title('Adults-Adolescents','FontSize', 24');
        axis xy;
        set(gca,'FontSize',18,'box','on','XGrid','off','YGrid','off');
        xlabel('DLPFC Hz','FontSize',24);
        ylabel('FEF Hz','FontSize',24);
        axis square;
        set(gca,'color','none');
        set(c,'location','manual','ActivePositionProperty','OuterPosition');
        hbarPos = get(c,'OuterPosition');
        set(c,'fontsize',24, 'OuterPosition',[hbarPos(1)+0.075 hbarPos(2) hbarPos(3)+0.008 hbarPos(4) ]);
        set(gca, 'LooseInset', [0,0,0,0]);
        %print(gcf, 'PowPowCorr_AvT', '-dpng  ', '-r300');
        set(gca, 'Color', 'none');
        export_fig AvT_PPCorr.tiff -m4 -painters
        
        end
        
        
    end
end


