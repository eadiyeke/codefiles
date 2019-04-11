function[P1,P2,AVG,CTG,ffinalAVG,ffinalCAT]= forestprediction3exttrue(forest,ntree,newinstance,x,y,x_eval,y_eval)
%nofpredict=size(testset{1},1);
%  newinstance={};
% for b=1:nofpredict
%  for c=1:size(x,2)
%        newinstance{b,1}=testset{1,c}(b,1);
%  end
% end
us=zeros(1,ntree);%usedsampleslog(n,:);%since we accept all predictions of the trees
%y_eval=cellfun(@isnumeric, y);
P1=cell(1,1);
P2=cell(1,1);
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
newinstmat=newinstance_;%newinstmat=[newinstance];
savednewinstmat=newinstance_;%newinstmat=[newinstance];
savednewinstance=newinstance;
for k=1:ntree
    newinstance=savednewinstance;
    %  [crf]=buildevaltrees(x,y,usedsamps,testsamples,k,usedsampleslog);
    if isfield(forest{k,1},'crf')
        crf=forest{k,1}.crf;
        for c=1:size(crf,2)
            %if isequal(crf{c}.Method,'classification') 
            if isequal(crf{c}.ModelParams.Type,'classification')
                 [yfit,yfitscores]=predict(crf{c},newinstmat);
             else
                 yfit=predict(crf{c},newinstmat);
             end
           % if isequal(crf{c}.Method,'regression') 
           if  isequal(crf{c}.ModelParams.Type,'regression')
                newinstance(1,end+1)=yfit;
                newinstmat=[newinstmat yfit];
            else
%                 [cnt groups]=hist(nominal(y{1,forest{k,1}.precendence(1,c)}));
%                 for t=1:size(groups,2)
%                     if nominal(yfit)==groups(1,t)
%                         yfitmat=t;
%                     end
%                 end%convert to classes
             newinstmat=[newinstmat yfit];               
%newinstmat=[newinstmat yfitscores];
               % for q=1:size(yfitscores,2)
                    newinstance(1,end+1)=yfit;%yfitscores(:,q);
                %end
                
            end
            
            
        end
    end
    [y1_avg, y2_type]=sendleaf5ext(forest{k,1},newinstance,x,y,1,x_eval,y_eval);
    P1{1,k}=y1_avg;
    P2{1,k}=y2_type;
    newinstmat=savednewinstmat;
end
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
tss={};
for l=1:size(finalavgs,2)
    ss=[];
    for a=1:ntree
        if us(a)==0
            ss=[ss, finalavgs{1,l}(1,a)];
        end
    end
    tss{1,l}=ss;
end
for k1=1:size(finalavgs,2)
    AVG=[AVG,mean(tss{1,k1})];
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
%     for a=1:ntree
%         if us(a)==0
%             s=[s, nominal(finalavgs2{1,l}(1,a))];
%         end
%     end
%     finalavgs2_{1,l}=s;
% end
%finalavgs2{1,1}=s;
CTG=[];
for k2=1:size(finalavgs2_,2)
    finav=sort(finalavgs2_{1,k2});
     [z1,z2,z3]=myhistnumeric(finav');
        [c cindex]=max(z2);
   CTG_=cindex-1;
   CTG(k2)=CTG_;
end


end