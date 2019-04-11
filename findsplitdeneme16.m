function [att ,val,pnode,pnodep, tree]=findsplitdeneme16(x_eval,y_eval,x,y,pnode,pnodep,maxleafsize,maxdepth,depth,prf,tarpref)
dbstop if error;
%gscatter(x{1},x{2},y{2})%valid for only this example
%hold all;
% x_eval=cellfun(@isnumeric, x);
% y_eval=cellfun(@isnumeric, y);
% Y=y;%copy y for char conversion purpose
Y_s=sort(y,1);%keep sorted version for myhist func.
X_s=sort(x);
% for i=1:size(y_eval,2)
%     if y_eval(1,i)==0%do we have categorical target?
%         % y{i}=nominal(y{i});%replace strings with nominal versions
%         Y{i}=char(Y{i});
%         Y_s{i}=sort(Y{i});
%     end
% end

% for i=1:size(x_eval,2)
%     if x_eval(1,i)==0%do we have categorical input?
%         x{i}=nominal(x{i});%replace strings with nominal versions
%     end
% end
%burada nominal'e cevirmeyi tamamen cell'i alarak yapiyor, row by row degil.

att=0;val=0;
depth=depth+1;
entcell=[];
tree.node=pnode;
tree.depth=depth;
tree.predictor=x;
tree.target=y;
avgs=[];cats=[];
for i=1:size(y_eval,2)
    if y_eval(i)%is type of numeric
        if size(y(:,i),1)==1
            avgs=[avgs;y(1,i)];
        else
             avgs=[avgs; mymean(y(:,i))];
        end
       
    else
         if size(Y_s(:,i),1)==1
            cats=[cats;Y_s(1,i)];
        else
             [z1,z2,z3]=myhistnumeric(Y_s(:,i));
        [c cindex]=max(z2);
        z11=z1(1,1:z3);
        grr=Y_s(z11,i);
        cats=[cats;grr(cindex,1)];
        end
        
%         [cnt groups]=hist(y(:,i));% cnt=[ # g1 #g2..], groups=[cats1 cats2.. ];
%         [c cindex]=max(cnt);
%         cats=[cats;groups(cindex)];%nominal val
        %Groups=char(groups);
    end
end

tree.avg=avgs;
tree.category=cats;
% e1=unique(double(y_eval));%output 0 1
% nels=hist(double(y_eval),e1);
% nels1=hist(double(y_eval),0);%nels=[#of categoric, # of numeric]
% nels2=hist(double(y_eval),1);%nels=[#of categoric, # of numeric]
%control phase-start
nels=size(y,2);
if size(y,1)<=maxleafsize
        entcell=[entcell; zeros(1,nels) 0 0 pnode 0 pnodep depth];
        tree.terminal=0;
    return
end
if tree.depth>=maxdepth
     entcell=[entcell; zeros(1,nels) 0 0 pnode 0 pnodep depth];
        tree.terminal=0;
    return
end
%m=randsample(size(x,2),floor(size(x,2)/2));
infr=[];
for a=1:size(x_eval,2)
    if x_eval(1,a)~=1%identify cat inputs
        %[c1,groups1]=hist(x(:,m(a)));% c1=[ # g1 #g2..], groups=[cat1 cat2.. ];
        [h1,h2,h3]=myhistnumeric(X_s(:,a));
        if h3==1
            infr=[infr, 0];%collect noninfromative features, ie homogenous
        else
            infr=[infr,1];
        end
    else
        infr=[infr,1];
    end
end
 infr=logical(infr);
sm=1:size(x,2);
selset=sm(infr);
if isempty(selset)
     entcell=[entcell; zeros(1,nels) 0 0 pnode 0 pnodep depth];
        tree.terminal=0;
    return
end
if ~isempty(selset)
    if size(selset,2)<2
        m=selset(1,1);
    elseif size(selset,2)==2
        m=selset;  
    else
        if size(selset,2)<floor(sqrt(size(x,2)))
            m=selset;
        else
            m=randsample(selset,floor(sqrt(size(x,2))));
        end
        
    end

end
m=m;
picknums=[];
for a=1:size(m,2)
    if x_eval(m(1,a))==1%identify numeric inputs
        picknums=[picknums m(1,a)];
    end
end
%  for a=1:size(m,2)
%     if x_eval(m(1,a))~=1%identify cat inputs
%          %[c1,groups1]=hist(x(:,m(a)));% c1=[ # g1 #g2..], groups=[cat1 cat2.. ];
%         
%             while numel(unique(x(:,m(a))))==1
%                   updt=randsample(size(x,2),1);
%                 m(a)=updt;
%             end
%          
%      end
%  end

if ~isempty(picknums)
    for ss=1:size(picknums,2)
        differences(1,ss)=max(x(:,picknums(1,ss)))-min(x(:,picknums(1,ss)));
    end
    cmat=zeros(1,size(picknums,2));
    if isequal(differences,cmat)
        entcell=[entcell; zeros(1,nels) 0 0 pnode 0 pnodep depth];
        tree.terminal=0;
    return
    end
end
%control phase-finish
%evaluation phase- start
%tic
for i=1:size(m,2)%size(x, 2);
    %if size(x,1)
    if x_eval(m(i))%is it numeric?
        %stepsize=(max(x(:,m(i)))-min(x(:,m(i))))/10;
        %thval=min(x(:,m(i))):stepsize:max(x(:,m(i)));
        %thval=thval(:,2:size(thval,2)-1);
        %thval=thval';
        thval=[];
        fc=sort(x(:,m(i)));
        ff=unique(fc);
         for h=1:size(ff,1)-1
         thval(h,1)=(ff(h+1,1)-ff(h,1))/2+ff(h,1);
         end
        for j=1:size(thval,1)
            weightedmse=[];weightedgini=[];
            dataabove=x(:,m(i))>thval(j,1);
            databelow=x(:,m(i))<=thval(j,1);
            %check output type and calculate relevant measure
            for k=1:size(y_eval,2)
                if y_eval(k)%is it numeric
                    weightedmse= [weightedmse compmse(y(dataabove,k))+compmse(y(databelow,k))];
                else
                    %                                          [cnt groups]=hist(y{k});% cnt=[ # g1 #g2..], groups=[cats1 cats2.. ];
                    %                                          Groups=char(groups);
                    [z1,z2,z3]=myhistnumeric(Y_s(:,k));%Y_s is charified & sorted
                    z1=z1(1,1:z3);
                   % z2=z2(1,1:z3);
                    %fprintf('%d\n', z1);
                    if ~(all(z1))
                        weightedgini=[weightedgini 0];
                    else
                        Groups=Y_s(z1,k);
                        ss=(sum(dataabove, 1)+sum(databelow, 1));
                        s1=sum(dataabove);
                        y1a=sort(y(dataabove,k));
                        y1b=sort(y(databelow,k));
                        weightedgini =[weightedgini (s1/ss)*compgini4numeric(y1a,Groups)+ ...
                            ((ss-s1)/ss)*compgini4numeric(y1b,Groups)];
                    end
                    %wcoef1=wght(double(dataabove),double(databelow));
                    %weightedgini =[weightedgini wcoef1*compgini4(Y{k}(dataabove),Groups)+ ...
                    %(1-wcoef1)*compgini4(Y{k}(databelow),Groups)];
                end
            end
            finaleval=[weightedmse weightedgini thval(j) m(i) pnode 1 pnodep depth];
            entcell=[entcell;finaleval];%%buray? duzenle
        end
        
    else%x is type of categoric variable
       % [c1 groups1]=hist(x{m(i)});% c1=[ # g1 #g2..], groups=[cat1 cat2.. ];
        [zz1,zz2,zz3]=myhistnumeric(X_s(:,m(i)));
        zzz=zz1(1,1:zz3);
        groups1=X_s(zzz,m(i));
        groups1=groups1';
        if zz3==1
            continue;
        else
            
            for j=1:size(groups1,2)
                weightedmse=[];weightedgini=[];
                dataabove=x(:,m(i))==groups1(1,j);%we can do this since x is type of nominal not a cell
                databelow=x(:,m(i))~=groups1(1,j);
                for k=1:size(y_eval,2)
                    if y_eval(k)%is it numeric
                        weightedmse= [weightedmse compmse(y(dataabove,k))+compmse(y(databelow,k))];
                    else
                        [z1_,z2_,z3_]=myhistnumeric(Y_s);%Y_s is charified & sorted
                         z1_=z1_(1,1:z3_);
                         Groups=Y_s(z1_,k);
                       % [cnt groups]=hist(y{k});% cnt=[ # g1 #g2..], groups=[cats1 cats2.. ];
                       % Groups=char(groups);
                        ss=(sum(dataabove, 1)+sum(databelow, 1));
                        s1=sum(dataabove);
                        weightedgini =[weightedgini (s1/ss)*compgini4numeric(Y(dataabove,k),Groups)+ ...
                            ((ss-s1)/ss)*compgini4numeric(Y(databelow,k),Groups)];
                    end
                end
                finaleval=[weightedmse weightedgini j m(i) pnode 1 pnodep depth];
                entcell=[entcell;finaleval];
            end
        end
    end
   % end
end
%***commentle
%[pop,F]=ndsort2(entcell,y);
%pop=calcrowdingdist3(pop,F,y);
% comp=[];
% for h=1:numel(F{1,1})
% comp=[comp,pop(F{1,1}(1,h)).crowdingdistance];
% end
%[w slc]=max(CD);

if tarpref
    %random subset of random targets
    q1=size(y_eval,2);
    qq=randsample(q1,1);
    qqq=randsample(q1,qq);
    u=[];CD=[];
    u=entcell(:,qqq);%cost matrix
    %u=entcell(:,1:size(y_eval,2));%cost matrix
    FF=findfrontier(u);
    q=1:size(entcell,1);
    FFindx=q(FF<=0);
    CD=CCD2(FFindx,y,u,qq,y_eval);
else
    u=[];CD=[];
    u=entcell(:,1:size(y_eval,2));%cost matrix
    FF=findfrontier(u);
    q=1:size(entcell,1);
    FFindx=q(FF<=0);
    
    %evaluation phase- stop
    %att and val selection
    CD=CCD(FFindx,y,u,y_eval);
end




if prf==1
    [w slc]=max(CD);
    val=entcell(FFindx(1,slc),size(y,2)+1);
    att=entcell(FFindx(1,slc),size(y,2)+2);
    tree.terminal=entcell(FFindx(1,slc),size(y,2)+4);
elseif prf==2
    slc=randsample(size(FFindx,2),1);
    val=entcell(FFindx(1,slc),size(y,2)+1);
    att=entcell(FFindx(1,slc),size(y,2)+2);
    tree.terminal=entcell(FFindx(1,slc),size(y,2)+4);
elseif prf==3
   myd=entcell(FFindx,1:size(y,2));
  % myd(:,2)=1-myd(:,2);%bunu impruity'ye çevirmek için yaptým not 2: bunu
  % yapma gini zaten imp.
    [L,LL]=sort(myd);
    %de=size(FFindx,2);
    if size(FFindx,2)>1
        e=1:size(FFindx,2);
        ee=repmat(e',1,size(y,2));
        for v=1:size(y,2)
            ee(LL(:,v),v)=ee(:,v);
        end
        rnk=mean(ee,2);
        [C,I]=min(rnk);
        slc=I;
        val=entcell(FFindx(1,slc),size(y,2)+1);
    att=entcell(FFindx(1,slc),size(y,2)+2);
    tree.terminal=entcell(FFindx(1,slc),size(y,2)+4);
    else
        slc=1;
         val=entcell(FFindx(1,slc),size(y,2)+1);
    att=entcell(FFindx(1,slc),size(y,2)+2);
    tree.terminal=entcell(FFindx(1,slc),size(y,2)+4);
    end
elseif prf==5
    ddr=[];
    if size(FFindx,2)>2
for dd=1:size(FFindx,2)
    dene=[];dene1=[];
    dene=x(:,entcell(FFindx(1,dd),size(y,2)+2));
    mel=entcell(FFindx(1,dd),size(y,2)+1);
    dene=[dene;mel];
    dene1=sort(dene);
    den11=dene1>mel;
    er=find(den11);
    ddr=[ddr;(dene1(er(1,1),1)-dene1((er(1,1)-1),1))/(dene1(end,1)-dene1(1,1)), (dene1((er(1,1)-1),1)-dene1((er(1,1)-2),1))/(dene1(end,1)-dene1(1,1))];
end
myset=[];
for bb=1:size(ddr,1)
    myset=[myset;min(ddr(bb,:))];
end
[cand1, cand2]=max(myset);%ilk deger, ikinci indis
 slc=cand2;
clear cand1 
clear cand2
clear dene
clear dene1
clear den11
clear er
 val=entcell(FFindx(1,slc),size(y,2)+1);
    att=entcell(FFindx(1,slc),size(y,2)+2);
    tree.terminal=entcell(FFindx(1,slc),size(y,2)+4);  
    else 
      slc=1;
         val=entcell(FFindx(1,slc),size(y,2)+1);
    att=entcell(FFindx(1,slc),size(y,2)+2);
    tree.terminal=entcell(FFindx(1,slc),size(y,2)+4);  
    end
elseif prf==6
    p=entcell(:,1);
a=0;
b=0.5;
d=b-a;
M=max(p);
m=min(p);
for iii=1:size(p,1)
ny(iii,1)=((d*(p(iii,1)-m))/(M-m))+a;
end
normerror=[ny,entcell(:,2)];
sumoferrors=sum(normerror,2);
[mynum,mypos]=min(sumoferrors);
slc=mypos;
val=entcell(slc,size(y,2)+1);
        att=entcell(slc,size(y,2)+2);
        tree.terminal=entcell(slc,size(y,2)+4);
else
    rns=randsample(size(y_eval,2),1);
    if y_eval(1,rns)==1
        [ww,slc]=min(entcell(:,rns));
        val=entcell(slc,size(y,2)+1);
        att=entcell(slc,size(y,2)+2);
        tree.terminal=entcell(slc,size(y,2)+4);
    else
        [ww,slc]=max(entcell(:,rns));
        val=entcell(slc,size(y,2)+1);
        tree.terminal=entcell(slc,size(y,2)+4);
        att=entcell(slc,size(y,2)+2);
        tree.terminal=entcell(slc,size(y,2)+4);
    end
end

%slc=randsample(size(FFindx,2),1);%use this for random selection from 1st
%frontier
%val=entcell(FFindx(1,slc),size(y,2)+1);
%att=entcell(FFindx(1,slc),size(y,2)+2);
tree.thr=val;
tree.split=att;
%tree.terminal=entcell(FFindx(1,slc),size(y,2)+4);
%toc
%comment ac
%
% %**burayi elimine et
% slc=randsample(size(entcell,2),1);
%  val=entcell(slc,size(y,2)+1);
%  att=entcell(slc,size(y,2)+2);
%  tree.thr=val;
%  tree.split=att;
%  tree.terminal=entcell(slc,size(y,2)+4);
% %**burayi elimine et

% val=entcell(F{1,1}(1,1),size(y,2)+1);
% att=entcell(F{1,1}(1,1),size(y,2)+2);
% tree.thr=val;
% tree.split=att;
% tree.terminal=entcell(F{1,1}(1,1),size(y,2)+4);

r=1:1:20;%range of x matters actually
rr=ones(1,20);
%if att==1
% plot(rr.*tree.thr,r)
%hold all;
%else
% plot(r,rr.*tree.thr)
% hold all;
%end
if x_eval(1,att)%isa(x{att},'numeric')
    d_above=x(:,att)>=val;
    d_below=x(:,att)<val;
else
  % [cnt_ groups1_]=hist(x{1,att});
   [z1_1,z2_1,z3_1]=myhistnumeric(X_s(:,att));%Y_s is charified & sorted
                         z1_1=z1_1(1,1:z3_1);
                         groups1_=X_s(z1_1,att);
    d_above=x(:,att)==groups1_(val);
    d_below=x(:,att)~=groups1_(val);
end
pnode=pnode+1;
pnodep=pnodep+1;
x1r_=[];y1r_=[];x1l_=[];y1l_=[];
for t=1:size(x,2)
    x1l_(:,t)=x(d_below,t);
    x1r_(:,t)=x(d_above,t);
end
for tt=1:size(y,2)
    y1l_(:,tt)=y(d_below,tt);
    y1r_(:,tt)=y(d_above,tt);
end
[ att,val,pnode,pnodep,tree.lchild]=findsplitdeneme16(x_eval,y_eval,x1l_,y1l_,pnode,pnodep,maxleafsize,maxdepth,depth,prf,tarpref);
%entcell=[entcell;entcellb];
pnode=pnode+1;
pnodep=pnodep+1;
[att, val,pnode,pnodep, tree.rchild]=findsplitdeneme16(x_eval,y_eval,x1r_,y1r_,pnode,pnodep,maxleafsize,maxdepth,depth,prf,tarpref);
%entcell=[entcell;entcella];
pnode=pnode-2;
end



