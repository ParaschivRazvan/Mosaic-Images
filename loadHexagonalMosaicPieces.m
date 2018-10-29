function params = loadHexagonalMosaicPieces(params)

mosaicPieceDimensions = size(params.mosaicPieces(:,:,:,1));
alphaMask = ones(mosaicPieceDimensions(1),mosaicPieceDimensions(2));
%creates a hexagonal mask for the image
%modify alpha chanel
for i = 1:mosaicPieceDimensions(1)/2
   for j = 1:int32(mosaicPieceDimensions(2)/3)- i + 1
       alphaMask(i,j,:) = 0;
       alphaMask(i,mosaicPieceDimensions(2)-j+1,:) = 0;
       alphaMask(mosaicPieceDimensions(1)-i+1,j,:) = 0;
       alphaMask(mosaicPieceDimensions(1)-i+1,mosaicPieceDimensions(2)-j+1,:) = 0;
   end
end
%writes all the resulting images into a new folder
piecesArrayDimensions = size(params.mosaicPieces);
for i = 1:piecesArrayDimensions(4)
imwrite(params.mosaicPieces(:,:,:,i),['../data/hexa/' num2str(i) '.png'],'Alpha',alphaMask);
end
%reads the hexagonal images and puts them into a new array
fileList =  dir(['../data/hexa/' '*.' params.imageType]);
dim =  size(imresize(imread([params.directorName fileList(1).name]),[28,39]));
hexaPiecesMosaic =  uint8(zeros ([dim length(fileList)]));

for i = 1:length(fileList)
    imgPath = ['../data/hexa/' fileList(i).name];
    img = imread(imgPath);
    hexaPiecesMosaic(:, :, :, i) = img;
end

params.hexaPiecesMosaic = hexaPiecesMosaic;


