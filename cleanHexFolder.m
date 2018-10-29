function cleanHexFolder(params)
%deletes all the images contained in the ../hexa folder after the porgram ends
piecesArrayDimensions = size(params.hexaPiecesMosaic);
for i = 1:piecesArrayDimensions(4)
    delete(['../data/hexa/' num2str(i) '.png']);
end

end

