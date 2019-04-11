function [xtrainset,ytrainset,r,T]= cvsets(x,y,nf)
%control  
residue=mod(size(x{1},1),nf);
%---
if residue~=0
for t=1:size(x,2)
   xmat{1,t}=x{1,t}(1:end-residue,:); 
end
for tt=1:size(y,2)
   ymat{1,tt}=y{1,tt}(1:end-residue,:); 
end
else
  xmat=x;ymat=y;  
end
%----------------------
%prepare testsets

ninst=size(xmat{1,1},1);
partlength=ninst/nf;
xtests={};ytests={};
f=1:ninst;
r=reshape(f,partlength,nf);
T=[];
for i=1:nf
 rr=ismember(f,r(:,i));
T=[T,rr'];
end
T=logical(T);
for i=1:nf
    xm={};
    p=T(:,i);
   for s=1:size(x,2)
   xm{1,s}= xmat{1,s}(p,:);
   %disp(s)
   end
   xtests{i}=xm;
 
end

for i=1:nf
    ym={};
    p=T(:,i);
   for s=1:size(y,2)
   ym{1,s}= ymat{1,s}(p,:);
   end
   ytests{i}=ym;
 
end

%-------------------
%prepare training sets

for i=1:nf
    xtr={};
    p=~T(:,i);
   for s=1:size(x,2)
   xtrm{1,s}= xmat{1,s}(p,:);
   end
   xtrainset{i}=xtrm;
 
end

for i=1:nf
    ytr={};
    p=~T(:,i);
   for s=1:size(y,2)
   ytrm{1,s}= ymat{1,s}(p,:);
   end
   ytrainset{i}=ytrm;
 
end
end