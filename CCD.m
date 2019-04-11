function CD= CCD(FFindx,y,u,y_eval)
y_evals=y_eval;
nobj=size(y_evals,2);
%nF=numel(F);%number of frontiers
nF=1;%consider only first frontier
n=size(FFindx,2);
if n==1
  %we don't need to calculate CD hence 
   costs=[];
    for kk=1:size(FFindx,2)
        costs=[costs;u(FFindx(1,kk),:)];  %collect costs of that frontier
    end
  CD=sum(costs,2);
elseif n==2
    %randomly select one of them
    costs=[];
    for kk=1:size(FFindx,2)
        costs=[costs;u(FFindx(1,kk),:)];  %collect costs of that frontier
    end
    %ew=unidrnd(2,1,1);
    CD=sum(costs,2);
    CD=CD';
else
for k=1:nF%for each frontier calculate crowd dist. of its members
    costs=[];
    for kk=1:size(FFindx,2)
        costs=[costs;u(FFindx(1,kk),:)];  %collect costs of that frontier
    end
    
    d=zeros(n,nobj);
    for j=1:nobj
        [cj,so]=sort(costs(:,j));
         %normalize costs
    cjj=(cj-min(cj))/(max(cj)-min(cj)); %lets hope max!=min :(
    
          %
        d(so(1),j)=cjj(2,1);%inf;min is set to 0!
        if n>=3%count numel of the  frontier
        for i=2:n-1
            if (cjj(end)-cjj(1))~=0%burayi sor!!!
            d(so(i),j)=abs(cjj(i+1,1)-cjj(i-1,1))/abs(cjj(end,1)-cjj(1,1));
            else
             d(so(i),j)=-inf; %burayi sor!!!  
            end
        end
        end
        d(so(end),j)=1-d(so(end-1),j);%inf;
    end
    for i=1:n
        CD(1,i)=sum(d(i,:),2);
    end
end  
end
