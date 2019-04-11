function [performancematAVG,performancematCAT]=performeval3(forest,ntree,x,testsamples,y,ytrains,settest,y_eval,x_eval,cattrg)%ytrains=ytrainset{1,j}

%generate a test sample: pick a group of instance from the unseen set
travg=ytrains;
%y_eval=cellfun(@isnumeric, y);
trmean=[];
for l=1:size(y_eval,2)
    if y_eval(1,l)==1
        trmean=[trmean,mean(travg(:,l))];
    end
end

testset=[];
testset=x(testsamples,:);
 
[averages, categories]=multipletest2(forest,ntree,x,testset,y,x_eval,y_eval,cattrg);%%predictions of our mob forest
%build realizations
realizedavgs=[];realizedcats=[];
for g=1:size(y,2)
    if y_eval(1,g)
    %for gg=1:size(testsamples,1)
    realizedavgs=[realizedavgs,y(settest,g)];%1st tree's test set(arbitrary)
    %end
    else
        %for gg=1:size(testsamples,1)
    realizedcats=[realizedcats,y(settest,g)];%1st tree's test set
    %end
    end
end
%compare predictions with their realizations
performancematAVG=[];
%averages=cell2mat(averages);
control=isnan(averages);
%averages=reshape(averages,size(averages,1),1);
%averages=averages';
if ~isempty(averages)
averages=averages(~control(:,1),:);
realizedavgs=realizedavgs(~control(:,1),:);
sumdeviation=[];
for h=1:size(realizedavgs,2)
        for hh=1:size(realizedavgs,1)
             sumdeviation(hh,h)=(averages(hh,h)-realizedavgs(hh,h))^2;
             sumdeviation2(hh,h)=(trmean(1,h)-realizedavgs(hh,h))^2; 
        %sumdeviation(hh,h)=(averages(hh,h)-realizedavgs(hh,h))^2;   
        end
        performancematAVG(1,h)=sqrt(sum(sumdeviation(:,h))/sum(sumdeviation2(:,h)));
        %performancematAVG(1,h)=mean(sumdeviation(:,h));
end
end
performancematCAT=[];
CC={};
for s=1:size(categories,1)
    for ss=1:size(categories,2)
    CC{s,ss}=categories(s,ss);
    end
end
realizedcats=num2cell(realizedcats);
control=cellfun(@isempty,CC);%isnan do not work for
if ~isempty(realizedcats)
    realizedcats=realizedcats(~control(:,1),:);
    CC=CC(~control(:,1),:);
    for h=1:size(realizedcats,2)
        acc=cellfun(@isequal, CC,realizedcats);
        performancematCAT=mean(acc);
    end
end
















end