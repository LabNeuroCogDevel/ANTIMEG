% This is the script to plot the timing of alpha power decrease (figure 5
% in the paper).
% last update 6.10.2014

%load data that has power timecourses in time lock to saccade onset
load All_RLPower.mat

%plot 8 to 18 hz
T1=((squeeze(mean(Adult_RLAS_C_Power(2,1:11,:,:),2)))); %this is left inferior FEF.
T2=((squeeze(mean(Adult_RLAS_C_Power(9,1:11,:,:),2)))); %this is left s FEF.
T3=((squeeze(mean(Adult_RLAS_C_Power(12,1:11,:,:),2)))); %this is right inferior FEF.
T4=((squeeze(mean(Adult_RLAS_C_Power(19,1:11,:,:),2)))); %this is right s FEF.
T=(T1+T2+T3+T4)/4;
plot(mean(T,2))

P=[]
for t =550:750
   v1 = T(t,:);
   v2 = T(t+1,:);
   [h,p]=ttest(v1,v2);
    
   P=[P,p];
    
    
end

tt=-2.7:0.004:0.3;
H1=shadedErrorBar(tt,T',{@mean,@ste},{'-','LineWidth',4,'Color',rgb('Black')},1);
xlim([-1.5 0.2])
set(gca,'FontSize',24,'box','off','XGrid','off','YGrid','off');
xlabel('Time to saccade onset (Seconds) ','FontSize',24)
ylabel('% signal change in alpha power','FontSize',24)
%set(hl,'FontSize', 24, 'Box','off');
%set(gca,'linewidth',10);
line([tt(625),tt(670)],[40 40],'LineStyle', '-','LineWidth',20,'Color','k');
line([0,0],[-10 50],'LineStyle', '--','LineWidth',10,'Color','k');
set(gca,'linewidth',10);
print(gcf, strcat('alpha_decrease'), '-dtiff  ', '-r300')