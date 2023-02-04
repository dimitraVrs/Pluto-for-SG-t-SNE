function P = perplexityEqualize(D,u)
    nn=ceil(u);
    k=nn+1; % nearest neighbors

    %% For each point compute k-nn dataset
    %% For k-nn datasets perform perplexity equalization
    % prepare CSC format for sparse matrix
    nnz=n*nn;
    row=ones[nnz,1]; % row indices of non zeroes
    col=ones[n+1,1]; % col offsets of points
    val=zeros[nnz,1]; % non zeros 
    % 
    n=size(D,1);
    for i=1:n
        % for vertex perfom perplexity equalization
        val[i*nn]=equalizeVertex(D[i*k],val[i*nn],u,nn,k);
    end
    %% column-wise kNN graph
    jidx=0:n-1;
    col=jidx'*nn;

    nz=0;
    for j=1:n
        for idx=1:nn
            row[nz+idx] = I[j*(nn+1)+idx+1];
        end
        nz=nz+nn;
    end

    P.row=row;
    P.col=col;
    P.val=val;
    P.m=n;
    P.n=m;
    P.nnz=n*nn;
end