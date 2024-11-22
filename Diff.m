function [Cx,Cy] = Diff(I)
    [r,c,ch] = size(I);
    x = ones(r,c);
    k = r*c;
    x = x(:);
    y = -1*x(:);
    B(:,1) = y;
    B(:,2) = x;
    B(:,3) = y;
    Cy = spdiags(B,[-k+1,0,1],k,k);
   
    D(:,1) = y;
    D(:,2) = x;
    D(:,3) = y;
    Cx = spdiags(D,[r-k,0,r],k,k);

end

