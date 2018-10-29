function params = loadMosaicPieces(params)
%reads all the N pieces used to create the mosaic
%all the images have the same dimensions: H x W x C, where:
%H = height, W = width, C = no of chanels (C=1  grey, C=3 color)
%function returns mosaicPieces = matrix H x W x C x N in params
%mosaicPieces(:,:,:,i) represents piece number i 

fprintf('Loading the mosaic pieces from the given directory \n');

fileList =  dir([params.directorName '*.' params.imageType]);
dim =  size(imresize(imread([params.directorName fileList(1).name]),[28,39])); % the image is resized for later hexagonal use
mosaicPieces =  zeros ([dim length(fileList)]);

for i = 1:length(fileList)
    imgPath = [params.directorName fileList(i).name];
    img = imread(imgPath);
    mosaicPieces(:, :, :, i) = imresize(img,[28,39]);
end

mosaicPieces = uint8(mosaicPieces);
    
if params.showMosaicPieces
%displays the first 100 images from the collection
    figure,
    title('The first 100 images are:');
    idxImg = 0;
    
    for i = 1:10
        for j = 1:10
            idxImg = idxImg + 1;
            subplot(10,10,idxImg);
            imshow(mosaicPieces(:,:,:,idxImg));
        end
     end
drawnow;
pause(2);
end

params.mosaicPieces = mosaicPieces;