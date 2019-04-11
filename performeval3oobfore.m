function [performancematAVG,performancematCAT,indtreeoobAVG,indtreeoobCAT]=performeval3oobfore(forest,ntree,x,testsamples,y,ytrains,settest,y_eval,x_eval,cattrg)%ytrains=ytrainset{1,j}
indtreeoobAVG=[];indtreeoobCAT=[];
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
testset=x(:,:);
 ts=logical(testsamples);
[averagess, categories,P1,P2]=multipletest2oob(forest,ntree,x,testset,y,x_eval,y_eval,cattrg,ts);%%predictions of our mob forest
%build realizations


%compare predictions with their realizations
performancematAVG=[];
%averages=cell2mat(averages);
performancematCAT=[];
CC={};
%averages=reshape(averages,size(averages,1),1);
%averages=averages';
for LL=1:ntree%foreach instance
    qw=[];
    for LLL=1:size(testset,1)
    qw=[qw;P1{1,LLL}(LL,:)];
    end
    averages=qw;%LL. agacin train set icin tahminleri
    control=isnan(averages);
    realizedavgs=[];realizedcats=[];
for g=1:size(y,2)
    if y_eval(1,g)
    %for gg=1:size(testsamples,1)
    realizedavgs=[realizedavgs,y(~settest,g)];%1st tree's test set(arbitrary)
    %end
    else
        %for gg=1:size(testsamples,1)
    realizedcats=[realizedcats,y(~settest,g)];%1st tree's test set
    %end
    end
end
%if y_eval(1,g)%%%%Buray? düzenle!!!!hatal? buras?
 %  realizedavgs=realizedavgs(~ts(:,LL),:);
%else
%    realizedcats=realizedcats(~ts(:,LL),:);
%end
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
            sumdeviation_(:,h)=sumdeviation(~ts(:,LL),h);
            sumdeviation2_(:,h)=sumdeviation2(~ts(:,LL),h);
            performancematAVG(1,h)=sqrt(sum(sumdeviation_(:,h))/sum(sumdeviation2_(:,h)));%bu sum olmayacak yenide
            %performancematAVG(1,h)=mean(sumdeviation(:,h));
        end
    end
    indtreeoobAVG(LL,:)=performancematAVG;%individual tree error
end
if ~isempty(realizedcats)
for LL=1:ntree
    qwc=[];
     for LLL=1:size(testset,1)
    qwc=[qwc;P2{1,LLL}(LL,:)];
    end
    categories=qwc;%LL. agacin train set icin tahminleri
    control=isnan(categories);
  % realizedcats=[];
    for s=1:size(categories,1)
        for ss=1:size(categories,2)
            CC{s,ss}=categories(s,ss);
        end
    end
    realizedcats=num2cell(realizedcats);
    control=cellfun(@isempty,CC);%isnan does not work for
    if ~isempty(realizedcats)
        realizedcats=realizedcats(~control(:,1),:);
        CC=CC(~control(:,1),:);
        for h=1:size(realizedcats,2)
            acc(:,h)=cellfun(@isequal, CC{:,h},realizedcats{:,h});
            performancematCAT(1,h)=mean(acc(~ts(LL,:),h));
        end
    end
    indtreeoobCAT(LL,:)=performancematCAT;
    
end
end

end