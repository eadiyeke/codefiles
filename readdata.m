%filename= 'abc.txt', 
%lastposcatout: index of the last categoric output, count the last cat variable from left to right,use this number  
%lastposcatin: index of the last categoric in, count the last cat variable
%from left to right, use this number
% xcat=x contains cat?(0 or1)
%ycat=c contains cat?(0 or 1)
%numely=number of y's=3,5 vs, 
%pos: right or left part contains the targets--> pos='l' or 'r'
%example: [x,y]= readdata('cancer.txt',1,0,0,1, 2,'l');
%example:[x,y]= readdata('slump.txt',0,0,0,0,3,'r');
%example: [x,y]= readdata('enbshuffle.txt',0,0,0,0,2,'r');
%example:[x,y]= readdata('edm.txt',0,0,0,0,2,'r');
%example:  [x,y]= readdata('jura.txt',0,9,1,0,3,'r');
%example: [x,y]= readdata('nbrd.txt',7,11,1,1,7,'l');
%example: [x,y]= readdata('sf1.txt',0,10,1,0, 3,'r');
%dataset should not contain ? if the value is missing. leave it blank


function [x,y]= readdata(filename,lastposcatout,lastposcatin,xcat,ycat, numely,pos)
rawdata=importdata(filename);
if xcat==0&&ycat==1
     if pos=='l'%outputs stacked at LHS
    for i=1:lastposcatout
        y{i}=rawdata.textdata(:,i);
        [a b]=str2num(y{1,i}{1,1});%check if the elements are type of num or cat
        if b
           y{i}=cellfun(@str2num,y{1,i});
        else
            y{i}=y{1,i}(:,1);
        end
    end
    
    if lastposcatout<numely
        for j=1:numely-lastposcatout
            y{end+1}=rawdata.data(:,j);
       end
    end
    for k=numely-lastposcatout+1:size(rawdata.data,2)
        x{k-numely+lastposcatout}=rawdata.data(:,k);
    end
     else%outputs stacked at RHS
       for i=1:lastposcatout
        y{i}=rawdata.textdata(:,end-i+1);
        [a b]=str2num(y{1,i}{1,1});%check if the elements are type of num or cat
        if b
           y{i}=cellfun(@str2num,y{1,i});
        else
            y{i}=y{1,i}(:,1);
        end
       end  
     if lastposcatout<numely
        for j=1:numely-lastposcatout
            y{end+1}=rawdata.data(:,j);
       end
     end
    for k=1:size(rawdata.textdata,2)-lastposcatout
       x{k}= rawdata.textdata(:,k);
       x{k}=cellfun(@str2num,x{1,k});
    end
        
     end
end%case 1

if xcat==1&&ycat==0
    if pos=='l'
     for i=1:numely
        y{i}=rawdata.textdata(:,i);
        y{i}=cellfun(@str2num,y{1,i}); 
     end  
    for j=numely+1:size(rawdata.textdata,2)
         x{j-numely}=rawdata.textdata(:,j);
        [a b]=str2num(x{1,j-numely}{1,1});%check if the elements are type of num or cat
        if b
           x{j-numely}=cellfun(@str2num,x{1,j-numely});
        else
            x{j-numely}=x{1,j-numely}(:,1);
        end
    end
    if lastposcatin<size(rawdata.textdata,2)+size(rawdata.data,2)-numely
        for k=1:size(rawdata.data,2)
            x{end+1}=rawdata.data(:,k);
        end
    end
    else
       for i=1:size(rawdata.textdata,2)
        x{i}=rawdata.textdata(:,i);
        inx=1;
        while(isempty(x{1,i}{inx,1}))
            inx=inx+1;
        end
        [a b]=str2num(x{1,i}{inx,1});%check if the elements are type of num or cat
        if b
            w={};
           w=cellfun(@str2double,x{1,i},'UniformOutput', 0);
           x{i}=cell2mat(w);
           %disp(i)
        else
            x{i}=x{1,i}(:,1);
        end
       end
       if lastposcatin<size(rawdata.textdata,2)+size(rawdata.data,2)-numely
           for k=1:size(rawdata.data,2)-numely
               x{end+1}=rawdata.data(:,k);
           end
       end
      for m=size(rawdata.data,2)-numely+1:size(rawdata.data,2)
        y{m-size(rawdata.data,2)+numely}=rawdata.data(:,m);
    end 
    
        
    end
    
end%case 2


if xcat==1 && ycat==1
    if pos=='l'
          for i=1:numely
        y{i}=rawdata.textdata(:,i);
        [a b]=str2num(y{1,i}{1,1});%check if the elements are type of num or cat
        if b
           y{i}=cellfun(@str2num,y{1,i});
        else
            y{i}=y{1,i}(:,1);
        end
          end
          for i=numely+1:size(rawdata.textdata,2)
            x{i-numely}=rawdata.textdata(:,i);
            [a b]=str2num(x{1,i-numely}{1,1});%check if the elements are type of num or cat
            if b
               x{i-numely}=cellfun(@str2num,x{1,i-numely});
            else
                x{i-numely}=x{1,i-numely}(:,1);
            end
          end     
          if lastposcatin<size(rawdata.textdata,2)+size(rawdata.data,2)-numely
              for k=1:size(rawdata.data,2)
                  x{end+1}=rawdata.data(:,k);
              end
          end
    else
        for i=1:size(rawdata.textdata,2)-lastposcatout
            x{i}=rawdata.textdata(:,i);
            [a b]=str2num(x{1,i}{1,1});%check if the elements are type of num or cat
            if b
                x{i}=cellfun(@str2num,x{1,i});
            else
                x{i}=x{1,i}(:,1);
            end
        end
        for i=size(rawdata.textdata,2)-lastposcatout+1:size(rawdata.textdata,2)
            y{i-size(rawdata.textdata,2)+lastposcatout}=rawdata.textdata(:,i);
            [a b]=str2num(y{1,i-size(rawdata.textdata,2)+lastposcatout}{1,1});%check if the elements are type of num or cat
            if b
                y{i-size(rawdata.textdata,2)+lastposcatout}=cellfun(@str2num,y{1,i-size(rawdata.textdata,2)+lastposcatout});
            else
                y{i-size(rawdata.textdata,2)+lastposcatout}=y{1,i-size(rawdata.textdata,2)+lastposcatout}(:,1);
            end
        end
        if lastposcatout<numely
            for j=1:numely-lastposcatout
                y{end+1}=rawdata.data(:,j);
            end
        end
        
    end
    
end%case 3

if xcat==0 && ycat==0
    if pos=='l'
        for i=1:numely
            y{i}=rawdata(:,i);
        end
        for j=numely+1:size(rawdata,2)
            x{j-numely}=rawdata(:,j);
        end
    else
         for i=1:size(rawdata,2)-numely
            x{i}=rawdata(:,i);
        end
        for j=size(rawdata,2)-numely+1:size(rawdata,2)
            y{j-size(x,2)}=rawdata(:,j);
        end
    end
end%case 4

end