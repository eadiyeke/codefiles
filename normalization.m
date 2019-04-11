p=y{1,2};
a=0;
b=0.5;
d=b-a;
M=max(p);
m=min(p);
for i=1:400
ny(i,1)=((d*(p(i,1)-m))/(M-m))+a;
end