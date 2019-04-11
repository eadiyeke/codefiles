function [y1_avg, y2_type]=sendleaf5(tree, newinstance,x,y,x_eval,y_eval)

 x_eval1=x_eval;
 %x_eval=[x_eval1 y_eval];%extended version. if you do not want to work with extended version simply delete row 4 and row5
 if tree.split<=size(x_eval1,2)
     if x_eval(tree.split)%is it numeric
         if newinstance(1,tree.split)<=tree.thr
             next=tree.lchild;
         else
             next=tree.rchild;
         end
     else
         groups2=unique(x(:,tree.split));%output is column matrix
         if newinstance(1,tree.split)==groups2(tree.thr,1);%%burada groups2{} þeklinde idi duzelttim
             next=tree.rchild;
         else
             next=tree.lchild;
         end
     end
 else
      if x_eval(tree.split)%is it numeric
         if newinstance(1,tree.split)<=tree.thr
             next=tree.lchild;
         else
             next=tree.rchild;
         end
     else
         groups2=unique(y(:,tree.split-size(x_eval1,2)));%output is column matrix
         if newinstance(1,tree.split)==groups2(tree.thr,1);%%burada groups2{} þeklinde idi duzelttim
             next=tree.rchild;
         else
             next=tree.lchild;
         end
     end 
 end
if ~next.terminal
   y1_avg.avg=next.avg;
   y2_type.type=next.category;
else
    [y1_avg,y2_type]=sendleaf5(next, newinstance, x,y,x_eval,y_eval);
end
end