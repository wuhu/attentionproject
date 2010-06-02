function displayMap(img, salMap)

figure;
set(gcf, 'pos', [100 100 1000 800]);
subplot(211)
imshow(img,'XData', [0 384])
subplot(212)
image(salMap)
colormap(gray(255))

