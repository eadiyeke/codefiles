function CD= CCD2(FFindx,y,u,qq,y_eval)
y_evals=y_eval;%cellfun(@isnumeric, y);
nobj=qq;%size(y_evals,2);
%nF=numel(F);%number of frontiers
nF=1;%consider only first frontier
for k=1:nF%for each frontier calculate crowd dist. of its members
    costs=[];
    for kk=1:size(FFindx,2)
        costs=[costs;u(FFindx(1,kk),:)];  %collect costs of that frontier
    end
    n=size(FFindx,2);
    d=zeros(n,nobj);
    for j=1:nobj
        [cj,so]=sort(costs(:,j));
        d(so(1),j)=inf;
        if n>=3%count numel of the  frontier
        for i=2:n-1
            if (cj(end)-cj(1))~=0%burayi sor!!!
            d(so(i),j)=abs(cj(i+1,1)-cj(i-1,1))/abs(cj(end,1)-cj(1,1));
            else
             d(so(i),j)=-inf; %burayi sor!!!  
            end
        end
        end
        d(so(end),j)=inf;
    end
    for i=1:n
        CD(1,i)=sum(d(i,:),2);
    end
    
end
