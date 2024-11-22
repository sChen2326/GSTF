function [Wx, Wy] = weight(fin, wx, wy)
    [r,c,ch] = size(fin);
    k = r*c;
    dx = wx(:);
    dy = wy(:);
    Wx = spdiags(dx,0,k,k);
    Wy = spdiags(dy,0,k,k);
    
end

