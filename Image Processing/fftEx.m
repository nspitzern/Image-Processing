function [] = fftEx()
a = imread('house.tiff');
b = double(a)/255;
c = fft2(b);
fftShow(c);

d=fftshift(c);
figure;fftShow(d);
d(145:149,224:228)

e = ifft2(c);
figure;imshow(e);

f = ifftshift(d);
f = ifft2(f);
figure;imshow(f);

[rows cols] = size(d);
mask = ones(size(d));
fh = int32(rows/10);
fw = int32(cols/10);
mask((147-fh):(147+fh),(226-fw):(226+fw)) = 0;
figure;imshow(mask);
g = d.*mask;
figure;fftShow(g);
figure;imshow(ifft2(ifftshift(g)));

mask1 = 1-mask;
g = d.*mask1;
figure;imshow(ifft2(ifftshift(g)));

mask(147,226) = 1;
g = d.*mask; 
figure;imshow(ifft2(ifftshift(g)));
end