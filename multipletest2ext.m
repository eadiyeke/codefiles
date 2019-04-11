function [averages, categories]=multipletest2ext(forest,ntree,x,testset,y,slct,x_eval,y_eval,cattrg)
%testset=gentest(x,testfactor);
ninst=size(testset,1);
averages=[];categories=[];
%FF={};FFcat={};
for n=1:ninst
    if slct==1
    [P1,P2,AVG,CTG,ffinalCAT,ffinalAVG]= forestprediction3ext(forest,ntree,testset(n,:),x,y,x_eval,y_eval);%selective
    elseif slct==3
    [P1,P2,AVG,CTG,ffinalAVG,ffinalCAT]= forestpredictioninter(forest,ntree,testset(n,:),x,y,x_eval,y_eval);
     elseif slct==4
    [P1,P2,AVG,CTG,ffinalAVG,ffinalCAT]= forestpredictioninterv2(forest,ntree,testset(n,:),x,y,x_eval,y_eval);%pureexpansion no mob split error
    else
    [P1,P2,AVG,CTG,ffinalCAT,ffinalAVG]= forestprediction4ext(forest,ntree,testset(n,:),x,y,x_eval,y_eval);%paper version   
    end
    averages=[averages;AVG];
    if cattrg==1
    categories=[categories;CTG];
    end
    %categories{n,1}=Categories{n,1}{1,1};
     %FF{n,1}=ffinalAVG;
    %FFcat{n,1}=ffinalCAT;
    %display(n)
end

end