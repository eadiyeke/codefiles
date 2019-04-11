function [averages, categories,P1all,P2all]=multipletest2oob(forest,ntree,x,testset,y,x_eval,y_eval,cattrg,ts)
%testset=gentest(x,testfactor);
ninst=size(testset,1);
averages=[];categories=[];
P1all={};P2all={};
%FFavg=[];FFcat=[];
for n=1:ninst
    P1all1=[];
    [P1,P2,AVG,CTG,ffinalCAT,ffinalAVG]= forestprediction3oobe(forest,ntree,testset(n,:),x,y,x_eval,y_eval,ts(n,:));
    averages(n,:)=AVG;
    for L=1:ntree
        P1all1=[P1all1; P1{1,L}.avg'];
    end
    P1all{1,n}=P1all1;
    if cattrg~=0
        categories(n,:)=CTG;
    end
    %categories{n,1}=Categories{n,1}{1,1};
    %FF(n,1)=ffinalAVG;
    %FFcat(n,1)=ffinalCAT;
end

end