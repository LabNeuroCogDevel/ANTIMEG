% Script to plot averaged alpha and beta-band timecourses from FEF and
% DLPFC, and calculate cross correlation. As seen in Figure 6.
%last update 6.11.2014.


load alpha_beta_averaged_timecourses.mat

%plot timecourses
t1 = squeeze(Adult_AS_C_Power_TS(2,8:15,:,:));
t1 = mean(mean(t1,3));
[t1,~,~]=cca_rm_temporalmean(t1,1);

t2 = squeeze(Adult_AS_C_Power_TS(2,4:7,:,:));
t2 = mean(mean(t2,3));
[t2,~,~]=cca_rm_temporalmean(t2,1);

figure
plot(Time(201:626-50),zscore(t1(201:626-50)),'k','linewidth', 2)
hold on
plot(Time(201:626-50),zscore(t2(201:626-50)),'k--','linewidth', 5)
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
t1 = squeeze(Adult_AS_C_Power_TS(2,8:15,:,:));
t1 = mean(mean(t1,3));
[t1,~,~]=cca_rm_temporalmean(t1,1);

t2 = squeeze(Adult_AS_C_Power_TS(2,4:7,:,:));
t2 = mean(mean(t2,3));
[t2,~,~]=cca_rm_temporalmean(t2,1);

[c,lag]=xcorr(t2,t1,125,'coef');
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



