function [forest,usedsamps,testsamples,usedsampleslog]=dtforest3(x_eval,y_eval,ntree,sampfactor,x,y,maxleafsize,maxdepth,prf,tarpref)
forest=cell(ntree,1);
nseries=size(x,1);
d=1:nseries;
usedsamps=[];
testsamples=[];
usedsampleslog=[];
%y_eval=cellfun(@isnumeric, y);
%x_eval=cellfun(@isnumeric, x);
% for i=1:size(y_eval,2)
%     if y_eval(1,i)==0%do we have categorical target?
%         y{i}=nominal(y{i});%replace strings with nominal versions
%         %Y{i}=char(Y{i});
%     end
% end
%profile on
for itree=1:ntree
    % tic
    depth=0;
    pnode=0;
    pnodep=1;
    use=randsample(nseries, floor(sampfactor*nseries));
    testsamples=[testsamples, setdiff(d',use)];
    usedsamps=[usedsamps, use];
    us=ismember(d,use);
    usedsampleslog=[usedsampleslog, us'];
    xx=x(use,:);
    yy=y(use,:);
%     for i=1:size(x_eval,2)
%         if x_eval(1,i)==0%do we have categorical input?
%             xx{i}=nominal(xx{i});%replace strings with nominal versions
%         end
%     end
    [ att ,val,pnode,pnodep, tree]=findsplitdeneme16(x_eval,y_eval,xx,yy,pnode,pnodep,maxleafsize,maxdepth,depth,prf,tarpref);
    %disp(itree)
    forest{itree}=tree;
    % toc
end
%toc
%profile off
%toc
end
