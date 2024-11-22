function [Wx,Wy] = computeGMap2(IN, sigma1, sigma2)
    
    if(~exist('alpha', 'var'))
        alpha1 = 2;
    end
    if(~exist('sigma1', 'var'))
        sigma1 = 0.2;
    end
    if(~exist('sigma2', 'var'))
        sigma2 = 1;
    end
    fin = double(IN);
    S = fin;
    
    h_input = [diff(S,1,2), S(:,1,:) - S(:,end,:)];
    v_input = [diff(S,1,1); S(1,:,:) - S(end,:,:)];

    tt1 = (abs(h_input)>=sigma2);
    tt2 = (abs(v_input)>=sigma2);
    
    hh_input = h_input(tt1);
    hv_input = v_input(tt2);
    

    t1 = (abs(h_input)<=sigma1);
    t2 = (abs(v_input)<=sigma1);

    h_input = h_input.*exp(-1 .* (abs(h_input)/sigma2).^alpha1);
    v_input = v_input.*exp(-1 .* (abs(v_input)/sigma2).^alpha1);

    h_input(tt1) = hh_input;
    v_input(tt2) = hv_input;
    
    h_input(t1) = 0;
    v_input(t2) = 0;
    
    h_input(:, end, :) = S(:,1,:) - S(:,end,:);
    v_input(end, :, :) = S(1,:,:) - S(end,:,:);
    
    Wx = h_input;
    Wy = v_input;
end

