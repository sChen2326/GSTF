function [retx, rety] = computeTextureWeights(fin, sigma)
   vareps = 0.001;
   fbin = lpfilter(fin, sigma);
   [gfx,gfy] = computeGMap2(fbin, sigma * 0, sigma * 2);
   wtbx = max(sum(abs(gfx), 3) / size(fin, 3),vareps).^(-1); 
   wtby = max(sum(abs(gfy), 3) / size(fin, 3),vareps).^(-1);
   
   retx = wtbx;
   rety = wtby;

   retx(:,end) = 0;
   rety(end,:) = 0;

end

function ret = conv2_sep(im, sigma)
  ksize = bitor(round(5*sigma),1); 
  g = fspecial('gaussian', [1,ksize], sigma); 
  ret = conv2(im,g,'same');
  ret = conv2(ret,g','same');  
end

function FBImg = lpfilter(FImg, sigma)     
    FBImg = FImg;
    for ic = 1:size(FBImg,3)
        FBImg(:,:,ic) = conv2_sep(FImg(:,:,ic), sigma);
    end   
end


