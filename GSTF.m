function [OUT] = GSTF(image, rho, sigma, lambda, itr_num)
    if (~exist('rho','var'))
       rho=0.5;
    end   
    if (~exist('sigma','var'))
       sigma=3.0;
    end 
    if (~exist('lambda','var'))
        lambda = 0.02;
    end
    if (~exist('itr_num','var'))
       itr_num=4;
    end
    p = 1; %0.8 0.6 
    [r,c,ch] = size(image);
    image = double(image);
    I = image;
    x = I;
    bx = ones(size(image));
    by = ones(size(image));
    dx = ones(size(image));
    dy = ones(size(image));
    wx = ones(r,c);
    wy = ones(r,c);
    [Cx,Cy] = Diff(I);
    
    for i = 1:itr_num
        fprintf('Iteration %d out of %d...\n',i, itr_num);
        if i ~= 1
            tx = [diff(x,1,2), x(:,1,:) - x(:,end,:)];
            ty = [diff(x,1,1); x(1,:,:) - x(end,:,:)];
            wx = ((sum(abs(tx), 3) / size(x, 3)) + 1e-5) .^ (p-1);
            wy = ((sum(abs(ty), 3) / size(x, 3)) + 1e-5) .^ (p-1);
        end
        [ux, uy] = computeTextureWeights(x, sigma);
        [Ux, Uy] = weight(x, ux, uy);
        [Wx, Wy] = weight(x, wx, wy);
        Lx = Ux * Wx * Cx;
        Ly = Uy * Wy * Cy;
        A = (rho / 2.0) * (Lx' * Lx) + (rho / 2.0) * (Ly' * Ly) + ...
                    sparse(1:r*c, 1:r*c, ones(1,r*c));   
        temp_x = I;
        temp_y = I;
        for li = 1:ch
            tin = I(:,:,li);
            tbx = bx(:,:,li);
            tby = by(:,:,li);
            tdx = dx(:,:,li);
            tdy = dy(:,:,li);
            B = tin(:) + (rho / 2.0) * (Lx' * (tdx(:) - (tbx(:) / rho))) + ...
                    (rho / 2.0) * (Ly' * (tdy(:) - (tby(:) / rho)));
            tout = A \ B;
            x(:,:,li) = reshape(tout, r, c); 
            tx = Lx * tout;
            ty = Ly * tout;
            temp_x(:,:,li) = reshape(tx, r, c);
            temp_y(:,:,li) = reshape(ty, r, c);
        end
                  
        
        dx = shrink(temp_x + (bx /  rho), (1.0 .* lambda) / rho);
        dy = shrink(temp_y + (by /  rho), (1.0 .* lambda) / rho);
        bx = bx + temp_x - dx;
        by = by + temp_y - dy;
        
        sigma = sigma/2;
         if sigma <= 0.5
            sigma = 0.5;
        end
    end
    OUT = uint8(x);
end



function d = shrink(v, lambda)
    index = find(v < 0);
    d = max(abs(v) - lambda, 0);
    d(index) = -1 * d(index);
end