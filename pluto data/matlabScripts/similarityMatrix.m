function D = similarityMatrix(X,n)
    D = squareform(pdist(X));  % all-to-all distance matrix

    D = 1 ./ D;                % inverse distance as similarity
    for i=1:n; D(i,i) = 0; end % set Inf to zero on the diagonal
    D = D ./ sum(D,1);         % make column stochastic
end