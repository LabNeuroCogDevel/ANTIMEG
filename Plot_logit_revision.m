% Script to plot logistic regression results.

load Adult_logit_revision.mat

figure

topedge=-90;
botedge=90;
numBins=8;
%binEdges=linspace(botedge,topedge,numBins+1);
binEdges=linspace(topedge,botedge,numBins+1);
[h,whichBin]=histc(Contra_FEF_alpha,binEdges);
binMean=[];
for i=1:numBins
    flagBinMembers=(whichBin==i);
    binMembers = Accu_Contra_FEF_alpha(flagBinMembers);
    binMean(i)=mean(binMembers);
end
xv=[];
for i =1:length(binEdges)-1
    xv = [xv,mean(binEdges(i:i+1))];
end
hold on
plot(xv,binMean(1:end),'ok','MarkerSize',15,'LineWidth',2)
xlim([-60 60])
ylim([0.6 1])

clear x y s
x=-60:1:60;
for s=1:length(x)
    y(s) = (exp( 1.575033+0.006644*x(s)))/(1+exp(1.575033+0.006644*x(s)));
end

plot(x,y,'-k','LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k',...
    'MarkerSize',1)



topedge=-90;
botedge=90;
numBins=8;
binEdges=linspace(topedge,botedge,numBins+1);
[h,whichBin]=histc(Ipsi_FEF_alpha,binEdges);
binMean=[];
for i=1:numBins
    flagBinMembers=(whichBin==i);
    binMembers = Accu_Ipsi_FEF_alpha(flagBinMembers);
    binMean(i)=mean(binMembers);
end
xv=[];
for i =1:length(binEdges)-1
    xv = [xv,mean(binEdges(i:i+1))];
end
hold on
plot(xv,binMean(1:end),'xk','MarkerSize',15,'LineWidth',2)
xlim([-60 60])
ylim([0.6 1])

clear x y s
x=-60:1:60;
for s=1:length(x)
    y(s) = (exp( 1.564707+0.004675*x(s)))/(1+exp(1.564707+0.004675*x(s)));
end
plot(x,y,'--k','LineWidth',4,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k',...
    'MarkerSize',5)

xlabel('% signal change','FontSize',25)
ylabel('Accuracy','FontSize',25)
%set(gca,'FontSize', 12, 'Box','off');
%legend('contralateral', '', 'ipsilateral')

set(gca,'FontSize',24)
set(gca,'linewidth',2);
hold off
%print(gcf, 'FEF_logit', '-dtiff  ', '-r600')
