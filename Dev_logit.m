%% Script to plotlogistic regression result. Fig 7 in the dev paper.
%%adult

load R_Data_for_Dev_Logit.mat

clear x y s

%create fitted logistic regression line
x=-60:5:60;
for s=1:length(x)
    y(s) = (exp( 1.497436+0.004477*x(s)))/(1+exp(1.497436+0.004477*x(s)));
end

%plot 
figure('visible','on');
plot(x,y,'-k','LineWidth',4,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k',...
    'MarkerSize',1)
set(gca,'FontSize',24)

xlabel('Alpha Power (% signal change)','FontSize',24)
ylabel('Probability of correct AS response','FontSize',24)
%title('Right inferior FEF')
%legend({'Adults','Adolescents'})
%legend({'Adults'})

hold on

clear x y s
x=-60:5:60;
for s=1:length(x)
    y(s) = (exp( 0.619664+0.000998*x(s)))/(1+exp(0.619664+0.000998*x(s)));
end
%figure('visible','on');
plot(x,y,':k','LineWidth',4,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k',...
    'MarkerSize',1)
set(gca,'FontSize',24)

hold on

%bin and then plot real data
topedge=-60;
botedge=60;
numBins=8;
%binEdges=linspace(botedge,topedge,numBins+1);
binEdges=linspace(topedge,botedge,numBins+1);
[h,whichBin]=histc(Adult_FEF_alpha,binEdges);
binMean=[];
for i=1:numBins
    flagBinMembers=(whichBin==i);
    binMembers = Adult_Accuracy(flagBinMembers);
    binMean(i)=mean(binMembers);
end
xv=[];
for i =1:length(binEdges)-1
    xv = [xv,mean(binEdges(i:i+1))];
end
hold on
h1=plot(xv,binMean(1:end),'ok','MarkerSize',15,'LineWidth',2,'MarkerFaceColor', 'black');
xlim([-60 60])
%print(gcf, 'FEF_Alpha_Brain_Behavior', '-dtiff  ', '-r600')


%binEdges=linspace(botedge,topedge,numBins+1);
binEdges=linspace(topedge,botedge,numBins+1);
[h,whichBin]=histc(Teen_FEF_alpha,binEdges);
binMean=[];
for i=1:numBins
    flagBinMembers=(whichBin==i);
    binMembers = Teen_Accuracy(flagBinMembers);
    binMean(i)=mean(binMembers);
end
xv=[];
for i =1:length(binEdges)-1
    xv = [xv,mean(binEdges(i:i+1))];
end
hold on
h2=plot(xv,binMean(1:end),'ok','MarkerSize',15,'LineWidth',2);
xlim([-60 60])
ylim([.5 1])
xlabel('alpha power % signal change','FontSize',25)
ylabel('Accuracy','FontSize',25)
%set(gca,'FontSize', 12, 'Box','off');
%legend('contralateral', '', 'ipsilateral')

set(gca,'FontSize',24)
set(gca,'linewidth',2);
legend([h1,h2],'Adult','Adolescent','Location','Best');
legend BOXOFF
set(gca, 'Box','off');
hold off
set(gcf, 'Color', 'white');
set(gcf,'Renderer','openGL');
%export_fig Dev_Logit.tiff -m4 -painters

