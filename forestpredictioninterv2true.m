function[P1,P2,AVG,CTG,ffinalAVG,ffinalCAT]= forestpredictioninterv2true(forest,ntree,newinstance,x,y,x_eval,y_eval)
%us=zeros(1,ntree);%usedsampleslog(n,:);%since we accept all predictions of the trees
prec=forest{1,1}.precendence;
fin_ens=forest{1,1}.crf;
ntree=1;
P1=cell(1,1);
P2=cell(1,1);
ynew_eval=y_eval;%cellfun(@isnumeric, y);
newinstance_=newinstance;
X_eval=x_eval;%cellfun(@isnumeric, x);
% if ~all(X_eval)
%     inx=find(~X_eval);
%     for g=1:size(inx,2)
%         [cnt groups]=hist(nominal(x{1,inx(1,g)}));
%         for t=1:size(groups,2)
%             if nominal(newinstance{1,inx(1,g)})==groups(1,t)
%                 newinstance_{1,inx(1,g)}=t;
%             end
%             
%         end%convert to classes
%         % metaX{1,inx(1,g)}=cell2mat(metaX{1,inx(1,g)});
%     end
% end
savednewinstmat=newinstance_;%newinstmat=[newinstance];
savednewinstance=newinstance;

newinstance=savednewinstance;
precedence=prec;
%  [crf]=buildevaltrees(x,y,usedsamps,testsamples,k,usedsampleslog);
%if isfield(forest{k,1},'crf')
fin_crfs=fin_ens;
%for c=1:size(fin_crfs,2)%scan permutations
xx=savednewinstance;
xxx=savednewinstance;
for cc=1:size(precedence,2)%scan targets
   % X_eval=cellfun(@isnumeric, xx);
    %xmat'i uygun sekilde genislet
   % if ~all(X_eval)%there exists a cat to handle
        %inx=find(~X_eval);%where is this cat?returns all of the cats, handles multiple cat case
        %%replcament stuff
%         for g=1:size(inx,2)
%             [cnt groups]=hist(nominal(xx{1,inx(1,g)}));
%             for t=1:size(groups,2)
%                 for tt=1:size(xx{1,inx(1,g)},1)
%                     if nominal(xx{1,inx(1,g)}{tt,1})==groups(1,t)
%                         xxx{1,inx(1,g)}{tt,1}=t;
%                     end
%                 end
%             end%convert to classes
%             xxx{1,inx(1,g)}=cell2mat(xxx{1,inx(1,g)});
%         end
        % X{1,inx}=cell2mat(X{1,inx});
        xx1=xxx;
        % [yfit,yfitscores]=predict(fin_crfs{1,cc}, xx1);
       %if isequal(fin_crfs{1,cc}.Method,'classification')
        if isequal(fin_crfs{1,cc}.ModelParams.Type,'classification')
            [yfit,yfitscores]=predict(fin_crfs{1,cc}, xx1);
            for p=1:size(yfitscores,2)
                xx(1,end+1)=yfitscores(:,p);
                restrg{1,1}{1,precedence(1,cc)}=yfit;
            end
        else
            yfit=predict(fin_crfs{1,cc}, xx1);
            xx(1,end+1)=yfit;
            restrg{1,1}{1,precedence(1,cc)}=yfit;
        end
   
    
    xxx=xx;
    
end
% end
xfitnew=savednewinstance;
for n=1:size(restrg{1,1},2)
    yfitt={};rrr=[];rr=[];
%     if isnumeric(restrg{1,1}{1,n})
%         %             for d=1:size(restrg{1,1}{1,1},1)
%         %                 for dd=1:size(restrg,2)
%         rrr=restrg{1,1}{1,n}(1,1);
%         %                 end
%         %             end
%         % rr=mean(rrr,2);
%         yfitt=rrr;
%     else
%         %             for d=1:size(restrg{1,1}{1,1},1)
%         %                 for dd=1:size(restrg,2)
%         rrr{1,1}=restrg{1,1}{1,n}{1,1};
%         %                 end
%         %             end
%         rr=nominal(rrr);
%         yfitt=char(rrr);
%         
%     end
   rrr=restrg{1,1}{1,n}(1,1);
        %                 end
        %             end
        % rr=mean(rrr,2);
        yfitt=rrr;
    xfitnew(1,end+1)=yfitt;
end

newinstance=xfitnew;
ggg=1;
for gg=size(x,2)+1:size(newinstance,2)
    newys(1,ggg)=newinstance(1,gg);
    ggg=ggg+1;
end
y1_a=[];loccat=[];y2_t={};
for h=1:size(ynew_eval,2)
    if ynew_eval(1,h)%is it numeric
        y1_a=[y1_a;newys(1,h)];
    else
        loccat=[loccat,h];%collects the locations of the cats
    end
end

if ~isempty(loccat)
    for f=1:size(loccat,2)
        y2_t{f,1}=newys(1,loccat(1,f));
    end
end
y1_avg.avg=y1_a;
y2_type.type=y2_t;
% end%isfield if's end
%[y1_avg, y2_type]=sendleaf5ext(forest{k,1},newinstance,x,y,2);
P1{1,1}=y1_avg;
P2{1,1}=y2_type;

%newinstmat=savednewinstmat;

finalavgs={};
for i1=1:size(P1{1,1}.avg,1)
    ff=[];
    for j1=1:size(P1,2)
        ff=[ff P1{1,j1}.avg(i1,1)];
    end
    finalavgs{i1}=ff;
end
ffinalAVG=finalavgs;
AVG=[];
%ss=[];
%tss={};

for k1=1:size(finalavgs,2)
    AVG=[AVG,finalavgs{1,k1}];
end


finalavgs2={};
for i1=1:size(P2{1,1}.type,1)
    ff2=[];
    for j1=1:size(P2,2)
        ff2=[ff2 P2{1,j1}.type(i1,1)];
    end
    finalavgs2{i1}=ff2;
end
ffinalCAT=finalavgs2;
%s=nominal;
%finalavgs2'yi duzenlemek gerek, kimleri kabul ediyoruz?
finalavgs2_=ffinalCAT;
% for l=1:size(finalavgs2,2)
%     s=nominal;
%     s=[s, nominal(finalavgs2{1,l}(1,1))];
%     finalavgs2_{1,l}=s;
% end
%finalavgs2{1,1}=s;
CTG=[];
for k2=1:size(finalavgs2_,2)
    % finav=sort(finalavgs2_(1,k2));
     %[z1,z2,z3]=myhistnumeric(finav');
      %  [c cindex]=max(z2);
   %CTG_=cindex-1;
   CTG(k2)=finalavgs2_{1,k2}{1,1};%CTG_;
end


end