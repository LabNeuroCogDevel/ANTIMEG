% Script to plot averaged alpha and beta-band timecourses from FEF and
% DLPFC, and calculate cross correlation. As seen in Figure 6.
%last update 6.11.2014.


load alpha_beta_averaged_timecourses.mat

%plot timecourses
%plot beta timecourses
beta_ts = squeeze(Adult_AS_C_Power_TS(2,8:15,:,:)); 
beta_ts = mean(mean(beta_ts,3));
[beta_ts,~,~]=cca_rm_temporalmean(beta_ts,1);

%plot alpha timecourses
alpha_ts = squeeze(Adult_AS_C_Power_TS(2,4:7,:,:));
alpha_ts = mean(mean(alpha_ts,3));
[alpha_ts,~,~]=cca_rm_temporalmean(alpha_ts,1);

figure
plot(Time(201:626-50),zscore(beta_ts(201:626-50)),'k','linewidth', 2)
hold on
plot(Time(201:626-50),zscore(alpha_ts(201:626-50)),'k--','linewidth', 5)
legend('beta','alpha','Location','Northeast','boxoff' );
legend boxoff
ylim([-3 3])
axis square
set(gca,'FontSize',24,'box','off','XGrid','off','YGrid','off')
xlabel('Time (seconds)','FontSize',24)
ylabel('Normalized Power','FontSize',24)
set(gca,'FontSize', 24, 'Box','off');
set(gca,'linewidth',2);
%print(gcf, 'Pow_TS', '-dtiff  ', '-r300')

%% Cross correlation
beta_ts = squeeze(Adult_AS_C_Power_TS(2,8:15,:,:));
beta_ts = mean(mean(beta_ts,3));
[beta_ts,~,~]=cca_rm_temporalmean(beta_ts,1);

alpha_ts = squeeze(Adult_AS_C_Power_TS(2,4:7,:,:));
alpha_ts = mean(mean(alpha_ts,3));
[alpha_ts,~,~]=cca_rm_temporalmean(alpha_ts,1);

[c,lag]=xcorr(alpha_ts,beta_ts,125,'coef');
figure
plot(lag*0.004,c,'k','linewidth', 2)
%legend('beta','alpha','Location','Northeast','boxoff' );
%legend boxoff
%ylim([-3 3])
axis square
set(gca,'FontSize',24,'box','off','XGrid','off','YGrid','off')
line([0.08,0.08],[-0.2 0.8],'LineStyle', '--','LineWidth',3,'Color','k');
xlabel('Time lag (seconds)','FontSize',24)
ylabel('Correlation Coefficient','FontSize',24)
set(gca,'FontSize', 24, 'Box','off');
set(gca,'linewidth',2);
%print(gcf, 'TS_xcorr', '-dtiff  ', '-r300')



