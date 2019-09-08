function [cImg1,cImg2,cImg3,cImg4] = fftClean(img1,img2,img3,img4)

% clean first image 
fftImg1 = fft2(img1);
fftshiftImg1 = fftshift(fftImg1);

fftshiftImg1(253, 213) = 0;
fftshiftImg1(281, 229) = 0;

cImg1 = ifft2(ifftshift(fftshiftImg1));

% clean second image 
fftImg2 = fft2(img2);
fftshiftImg2 = fftshift(fftImg2);

fftshiftImg2(231, 175) = 0;
fftshiftImg2(251, 157) = 0;

cImg2 = ifft2(ifftshift(fftshiftImg2));

% clean third image 
fftImg3 = fft2(img3);
fftshiftImg3 = fftshift(fftImg3);

fftshiftImg3(174, 112) = 0;
fftshiftImg3(174, 125) = 0;
fftshiftImg3(174, 138) = 0;

fftshiftImg3(190, 138) = 0;
fftshiftImg3(190, 112) = 0;

fftshiftImg3(206, 125) = 0;
fftshiftImg3(206, 112) = 0;

fftshiftImg3(206, 138) = 0;

cImg3 = ifft2(ifftshift(fftshiftImg3));

% clean fourth image 
fftImg4 = fft2(img4);
fftshiftImg4 = fftshift(fftImg4);

fftshiftImg4(289, 252) = 0;
fftshiftImg4(311, 252) = 0;

fftshiftImg4(300, 234) = 0;
fftshiftImg4(300, 270) = 0;

cImg4 = ifft2(ifftshift(fftshiftImg4));
end

