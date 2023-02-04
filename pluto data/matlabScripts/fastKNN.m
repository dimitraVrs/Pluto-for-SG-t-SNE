function [I, Dist] = fastKNN(X,n,k)
%     build_params.algorithm='kdtree';
% %     build_params.trees=8;
%     build_params.trees=2;
    build_params.algorithm='autotuned';
    build_params.target_precision=0.98;
    build_params.memory_weight=1; % middle ground between 
                                  % case where memory usage is not a concern
                                  % and case where is the dominant concern
    build_params.sample_fraction=1; % use the whole dataset in algorithm for
                                    % the parameters' configuration for
                                    % accurate parameters

    index=flann_build_index(X,build_params);
    flann_set_distance_type('euclidean');

    parameters.ckecks=100; % number of times trees will be traversed
    [I, Dist] = flann_search(index, X, k, parameters);

    I=I';
%     for i=1:n
%         for j=1:n-k
%             D(i,I(i,j))=0;
%         end
%     end

    Dist=Dist';
    Dsp=zeros(n,n);
    for i=1:n
        for j=1:k
            Dsp(i,I(i,j))=Dist(i,j);
        end
    end

end