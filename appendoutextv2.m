function [forest3,xx]=appendoutextv2(x_eval,y_eval,ntree,x,y,maxleafsize,maxdepth,prf,sampfactor)
%tic
dbstop if error
forest3=cell(ntree,1);
nseries=size(x,1);
d=1:nseries;
%usedsamps=[];
%testsamples=[];
%usedsampleslog=[];
%y_eval=cellfun(@isnumeric, y);
[fin_ens,precedence]=buildevaltrees4_newv2(x_eval,y_eval,x,y);
xx=x;
xxx=x;
for c=1:size(fin_ens,2)
   % X_eval=cellfun(@isnumeric, xx);
    %xmat'i uygun sekilde genislet
    %if ~all(X_eval)%there exists a cat to handle
       % inx=find(~X_eval);%where is this cat?returns all of the cats, handles multiple cat case
        %%replcament stuff
%         for g=1:size(inx,2)
%             [cnt groups]=hist(nominal(xx{1,inx(1,g)}));
%             groups=char(groups);
%             w=char(xx{1,inx(1,g)});
%             ww=myhistv2(w,groups);
%             %                 for t=1:size(groups,2)
%             %                     for tt=1:size(xx{1,inx(1,g)},1)
%             %                         if nominal(xx{1,inx(1,g)}{tt,1})==groups(1,t)
%             %                             xxx{1,inx(1,g)}{tt,1}=t;
%             %                         end
%             %                     end
%             %                 end%convert to classes
%             %               xxx{1,inx(1,g)}=cell2mat(xxx{1,inx(1,g)});
%             xxx{1,inx(1,g)}=ww';%cell2mat(xxx{1,inx(1,g)});
%         end
        % X{1,inx}=cell2mat(X{1,inx});
        xx1=[];
%         for k=1:size(xxx,2)
%             xx1=[xx1 xxx{1,k}];%classregtreee inputu matrix olacak, categoric kabul etmiyor!!
%         end
        xx1=xxx;
          if isequal(fin_ens{1,c}.ModelParams.Type,'classification')%
                %%if isequal(fin_ens{1,c}.ModelParams.Type,'classification')%
        [yfit,yfitscores]=predict(fin_ens{1,c}, xx1);%%
          else
          yfit=predict(fin_ens{1,c}, xx1);  
          end%
    %else
%         xx1=[];
% %         for k=1:size(xxx,2)
% %             xx1=[xx1 xxx{1,k}];%classregtreee inputu matrix olacak, categoric kabul etmiyor!!
% %         end
%          xx1=xxx;
%          if isequal(fin_ens{1,c}.ModelParams.Type,'classification')%
%             [yfit,yfitscores]=predict(fin_ens{1,c}, xx1);%% 
%          else
%            yfit=predict(fin_ens{1,c}, xx1);  
%          end
   % end
   if isequal(fin_ens{1,c}.ModelParams.Type,'classification')
       for q=1:size(yfitscores,2)
           xx(:,end+1)=yfitscores(:,q);
       end
   else
       
       xx(:,end+1)=yfit;
   end
   
    xxx=xx;
end

for itree=1:ntree
    xx=xxx;
    use=randsample(nseries, floor(sampfactor*nseries));
    depth=0;
    pnode=0;
    pnodep=1;
%     for tt=1:size(xx,2)
%         xx{tt}=xx{:,tt}(use,:);
%     end
%     
%     for tt=1:size(y,2)
%         yy{tt}=y{:,tt}(use,:);
%     end
%     
%     for i=1:size(y_eval,2)
%         if y_eval(1,i)==0%do we have categorical target?
%             yy{i}=nominal(yy{i});%replace strings with nominal versions
%         end
%     end
%     xx_eval=cellfun(@isnumeric, xx);
%     for i=1:size(xx_eval,2)
%         if xx_eval(1,i)==0%do we have categorical input?
%             xx{i}=nominal(xx{i});%replace strings with nominal versions
%         end
%     end
    xx=xx(use,:);
    yy=y(use,:);
    x_eval=[x_eval ones(1,size(xx,2)-size(x_eval,2))];
    [entcell, att ,val,pnode,pnodep, tree]=findsplitdeneme15(x_eval,y_eval,precedence,xx,yy,pnode,pnodep,maxleafsize,maxdepth,depth,prf);
    tree.crf=fin_ens;%buildevaltrees(x,y,usedsamps,testsamples,itree,usedsampleslog);
    tree.precendence=precedence;
    forest3{itree}=tree;
    
end

%toc
end