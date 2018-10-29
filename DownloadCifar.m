% Download the CIFAR-10 dataset
%from the following address https://www.cs.toronto.edu/˜kriz/cifar.html
load('..\cod\cifar-10-batches-mat\data_batch_2');
im=zeros(32,32,3);
it = ones(10, 1);
for cpt=1:10000
R=data(cpt,1:1024);
G=data(cpt,1025:2048);
B=data(cpt,2049:3072);
k=1;
for x=1:32
for i=1:32
im(x,i,1)=R(k);
im(x,i,2)=G(k);
im(x,i,3)=B(k);
k=k+1;
end
end
im=uint8(im);
switch labels(cpt)
    case 0
        imwrite(im, ['..\data\cifar' int2str(labels(cpt)) '\' int2str(it(1)) '.png'],'png');
        it(1) = it(1) + 1;
    case 1
        imwrite(im, ['..\data\cifar' int2str(labels(cpt)) '\' int2str(it(2)) '.png'],'png');
        it(2) = it(2) + 1;
    case 2
        imwrite(im, ['..\data\cifar' int2str(labels(cpt)) '\' int2str(it(3)) '.png'],'png');
        it(3) = it(3) + 1;
    case 3
        imwrite(im, ['..\data\cifar' int2str(labels(cpt)) '\' int2str(it(4)) '.png'],'png');
        it(4) = it(4) + 1;
    case 5
        imwrite(im, ['..\data\cifar' int2str(labels(cpt)) '\' int2str(it(5)) '.png'],'png');
        it(5) = it(5) + 1;
    case 6
        imwrite(im, ['..\data\cifar' int2str(labels(cpt)) '\' int2str(it(6)) '.png'],'png');
        it(6) = it(6) + 1;
    case 7
        imwrite(im, ['..\data\cifar' int2str(labels(cpt)) '\' int2str(it(7)) '.png'],'png');
        it(7) = it(7) + 1;
    case 8
        imwrite(im, ['..\data\cifar' int2str(labels(cpt)) '\' int2str(it(8)) '.png'],'png');
        it(8) = it(8) + 1;
    case 9
        imwrite(im, ['..\data\cifar' int2str(labels(cpt)) '\' int2str(it(9)) '.png'],'png');
        it(9) = it(9) + 1;
end

end