%% Organize and run stats on evoke waveforms
% last update 06102014
% This script is used to organize and generate Evoke response data. The
% output figure here is the FEF evoke response from both adolescents and
% adults (e.g., figure 4 in the paper). You can change it up to generate
% evoke responses of other regions or a single group (ie adult only). 

%% setup

%load data
load AllSubs_Source_phase_data2.mat
ROIS=ANTISubData{1}.label;

%filter data with fieldtrip
cfg.dftfilter ='yes';
cfg.dftfreq = [60 120 180];
cfg.lpfilter = 'yes';
cfg.demean='yes';
cfg.baselinewindow = [-2.3 -1.5];
cfg.detrend='yes';
cfg.lpfreq = 4;

%cfg.rectify='yes';
%stupid vectors for selecting subject


%% preprocess adult data
i=1;
for n=1:20
    AData{i} = ft_preprocessing(cfg, ANTISubData{n});
    VData{i} = ft_preprocessing(cfg, VGSSubData{n});
    i=i+1;
end
%% extract trial data
%fix number of usable trials at the lowest avaible number, which is 47
AANTIEvoke = [];
for roi=1:10
    for s =1:20
        n = sort(randsample(find(AData{s}.trialinfo==1),47));
        data =AData{s}.trial(n);
        z=0;
        for t = 1:length(data)
            z = [z+detrend(abs(data{t}(roi,401:1000)))];
        end
        z=z/t;
        %z=smooth(z,30);
        AANTIEvoke(roi,:,s)=[z];
    end
end

AVGSEvoke = [];
for roi=1:10
    for s =1:20
        n = sort(randsample(find(VData{s}.trialinfo==1),47));
        data =VData{s}.trial(n);
        z=0;
        for t = 1:length(data)
            z = [z+detrend(abs(data{t}(roi,401:1000)))];
        end
        z=z/t;
        %z=smooth(z,30);
        AVGSEvoke(roi,:,s)=[z];
    end
end


%% preprocess adolescent data
AData=[];
VData=[];
i=1;
for n=21:37
    AData{i} = ft_preprocessing(cfg, ANTISubData{n});
    VData{i} = ft_preprocessing(cfg, VGSSubData{n});
    i=i+1;
end

%% extract trial data for adolescents
TANTIEvoke = [];
for roi=1:10
    for s =1:17
        n = sort(randsample(find(AData{s}.trialinfo==1),47));
        data =AData{s}.trial(n);
        z=0;
        for t = 1:length(data)
            z = [z+detrend(abs(data{t}(roi,401:1000)))];
        end
        z=z/t;
        z=smooth(z,30);
        TANTIEvoke(roi,:,s)=[z];
    end
end

TAVGSEvoke = [];
for roi=1:10
    for s =1:17
        n = sort(randsample(find(VData{s}.trialinfo==1),47));
        data =VData{s}.trial(n);
        z=0;
        for t = 1:length(data)
            z = [z+detrend(abs(data{t}(roi,401:1000)))];
        end
        z=z/t;
        z=smooth(z,30);
        TAVGSEvoke(roi,:,s)=[z];
    end
end


%% plot evoke responses

time=-1.9:0.004:0.4960;

figure
D1=10^12*(squeeze((AANTIEvoke(2,:,:)))); %roi number 2 is right FEF
D2=10^12*(squeeze((AVGSEvoke(2,:,:))));
D3=10^12*(squeeze((TANTIEvoke(2,:,:))));
D4=10^12*(squeeze((TAVGSEvoke(2,:,:))));

D5=10^12*(squeeze((AANTIEvoke(6,:,:)))); %6 is left FEF
D6=10^12*(squeeze((AVGSEvoke(6,:,:))));
D7=10^12*(squeeze((TANTIEvoke(6,:,:))));
D8=10^12*(squeeze((TAVGSEvoke(6,:,:))));

D1 = (D1+D5)/2;
D2 = (D2+D6)/2;
D3 = (D3+D7)/2;
D4 = (D4+D8)/2;

H1=shadedErrorBar(time,D1',{@mean,@ste},{'-','LineWidth',4,'Color',rgb('Red')},1);
hold on
H2=shadedErrorBar(time,D2',{@mean,@ste},{'-','LineWidth',4,'Color',rgb('Blue')},1);
H3=shadedErrorBar(time,D3',{@mean,@ste},{'--','LineWidth',4,'Color',rgb('Red')},1);
H4=shadedErrorBar(time,D4',{@mean,@ste},{'--','LineWidth',4,'Color',rgb('Blue')},1);

hl=legend([H1.mainLine,H2.mainLine,H3.mainLine,H4.mainLine],'Adult:AS ','Adult:PS','Adolescent:AS','Adolescent:PS','Location',[0.4 0.5 0.2 0.5] );
line([-1.5,-1.5],[-0.5,1.5],'LineStyle', '-','LineWidth',2,'Color','k')
line([0,0],[-0.5,1.5],'LineStyle', '--','LineWidth',2,'Color','k')
ylim([-0.5 1.5])
xlim([-1.7 0.5])
axis square
set(gca,'FontSize',24,'box','off','XGrid','off','YGrid','off')
set(gca,'FontSize', 24, 'Box','off');
set(hl,'FontSize', 24, 'Box','off');
xlabel('Time (seconds)','FontSize', 24)
ylabel('Current Estimate (nAm)','FontSize', 24)
set(gca,'linewidth',2);
%title(strcat(ROIS(r)))
export_fig AvT_evoke_fef.tiff -m4 -transparent


%% Here we have scripts for testing statistical significance, in general no task or developmental effect was ever found
%     [ Stats, Clusters, Clust_Masks, Sig_Mask, Clust_Pvals,Sig_Pvals, Null_clusts_mass ] = MEG_Cluster_Stats( D1, D2, 1000);
%     if any(Sig_Pvals)
%         [si,ei] = find_con(Sig_Mask);
%         for i=1:length(si)
%             line([time(si(i)),time(ei(i))],[8e-13 8e-13],'LineStyle', '-','LineWidth',6,'Color','k');
%         end
%
%
%     end



