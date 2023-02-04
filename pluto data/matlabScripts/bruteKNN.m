function Dsp = bruteKNN(X,n,k)

        D = similarityMatrix(X,n);
        [Dsorted,I]=sort(D,2,'descend');

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
                %Dsp(I(i,j),i)=Dsp(i,I(i,j));
            end
        end

end