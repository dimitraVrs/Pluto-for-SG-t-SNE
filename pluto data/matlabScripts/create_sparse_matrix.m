clear

problem = {'grid', 'twoRings', 'sameDistance','differentSizes','differentDistances', ...
    'trefoil','concentricCircles','noise','ellipse','parallelLines','circle','randomCircle', ...
    'orthogonalSteps','randomWalk','randomJump','simplex','uniform','linkedRings','unlinkedRings'}; %

msg = '';
for i=1:length(problem)
  msg = sprintf('%s%d. %s\n',msg,i,problem{i});
end

pid = input(sprintf('%s\nSelect test case (1-%d): ',msg,length(problem)));

u=input('\nGive a perplexity value (5-50): ');

fprintf('Processing %s\n',problem{pid})

eps = 100;

switch problem{pid}
  case 'twoRings'
    n0 = 700;
    n = 2 * n0; % total number of points
    a = linspace(0,2*pi,n0)';

    X = [0.5 * (cos(a + randn(n0,1)*2^-4)), ...
         0.5 * (sin(a + randn(n0,1)*2^-4));
         0.7 * (cos(a + randn(n0,1)*2^-4)), ...
         0.7 * (sin(a + randn(n0,1)*2^-4))];
    % cluster ids
%     L = [ones(n0,1); 2*ones(n0,1)];

    figure(pid)
    scatter(X(1:n0,1),X(1:n0,2),eps,[0 0.4470 0.7410],'.')
    hold on
    scatter(X(n0+1:2*n0,1),X(n0+1:2*n0,2),eps,[0.8500 0.3250 0.0980],'.');
    axis equal off
    title('Original space')
    legend('cluster 1','cluster 2')
    imgName=sprintf('%s.png',problem{pid});
    saveas(gcf,imgName)

    D = similarityMatrix(X,n);

    % sparse stochastic matrix
    Dsp=zeros(n,n);
    Dsp(1:n0,1:n0)=D(1:n0,1:n0);
    Dsp(n0+1:2*n0,n0+1:2*n0)=D(n0+1:2*n0,n0+1:2*n0);

    case 'sameDistance'
    n0 = 200;
    n = 3 * n0; % total number of points

    X = [randn(n0,2); randn(n0,2)+[5,0]; randn(n0,2) + [0, 5]];
    % cluster ids
    L = [ones(n0,1); 2*ones(n0,1); 3*ones(n0,1)];

    figure(pid)
    scatter(X(1:n0,1),X(1:n0,2),eps,[0 0.4470 0.7410],'.')
    hold on
    scatter(X(n0+1:2*n0,1),X(n0+1:2*n0,2),eps,[0.8500 0.3250 0.0980],'.');
    scatter(X(2*n0+1:3*n0,1),X(2*n0+1:3*n0,2),eps,[0.4660 0.6740 0.1880],'.');
    axis equal off
    title('Original space')
    legend('cluster 1','cluster 2','cluster 3')
    imgName=sprintf('%s.png',problem{pid});
    saveas(gcf,imgName)
    
    D = similarityMatrix(X,n);

    % sparse stochastic matrix
    Dsp=zeros(n,n);
    Dsp(1:n0,1:n0)=D(1:n0,1:n0);
    Dsp(n0+1:2*n0,n0+1:2*n0)=D(n0+1:2*n0,n0+1:2*n0);
    Dsp(2*n0+1:3*n0,2*n0+1:3*n0)=D(2*n0+1:3*n0,2*n0+1:3*n0);

  case 'grid'
    n0 = 25;
    n = n0^2;
    v = linspace(0,1,n0);
    [xx,yy] = meshgrid(v,v);

    X = [xx(:) yy(:)];

    % use these labels for gradual linear rainbow change
    a = linspace(0,pi,n+1)'; a = a(1:n);
    L = [(1+cos(a))/2 sin(a) (1-cos(a))/2];

    figure(pid)
    scatter(X(:,1),X(:,2),eps,L,'.');
%     colormap(parula(n))
    axis equal off
    title('Original space of grid')
    imgName=sprintf('%s.png',problem{pid});
    saveas(gcf,imgName)

    % write colormap in txt file to use the same in Julia
%     txtName=sprintf('%s.txt',problem{pid});
%     cmap=colormap;
%     writematrix(cmap,txtName);

    D = similarityMatrix(X,n);

    nn=ceil(3*u);
    k=nn;

    [Dsorted,I]=sort(D,2,'descend');

    Dsp=zeros(n,n);
    for i=1:n
        for j=1:k
            Dsp(i,I(i,j))=D(i,I(i,j));
        end
    end

    case 'differentSizes'
        n0=200;
        n=2*n0;
        muSize=zeros(n,n);
        muSize(n0+1:n,1)=100;
        sigmaSize=ones(n,n);
        sigmaSize(1:n0,:)=10;

        X=normrnd(muSize,sigmaSize,n,n);

        L = [ones(n0,1); 2*ones(n0,1);];

        figure(pid)
        scatter(X(1:n0,1),X(1:n0,2),eps,[0 0.4470 0.7410],'.')
        hold on
        scatter(X(n0+1:n,1),X(n0+1:n,2),eps,[0.8500 0.3250 0.0980],'.');
        axis equal off
        title('Original space')
        legend('\sigma1=10','\sigma2=1')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        % sparse matrix
        D = similarityMatrix(X,n);

        nn=ceil(3*u);
        k=nn;

        [Dsorted,I]=sort(D,2,'descend');

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

%         Dsp=zeros(n,n);
%         Dsp(1:n0,1:n0)=D(1:n0,1:n0);
%         Dsp(n0+1:n,n0+1:n)=D(n0+1:n,n0+1:n);

    case 'differentDistances'
        n0=200;
        n=3*n0;

        muD=zeros(n0,n0);
        sigmaD=ones(n0,n0);

        cluster1D=normrnd(muD,sigmaD,n0,n0);

        cluster2D=cluster1D; 
        cluster2D(:,1)=cluster2D(:,1)+10;
        cluster3D=cluster1D;
        cluster3D(:,1)=cluster3D(:,1)+40; % cluster 1 & 2 have distance 10
        % cluster 1 & 3 have distance 40

        X=[cluster1D; cluster2D; cluster3D];

        L = [ones(n0,1); 2*ones(n0,1); 3*ones(n0,1)];

        figure(pid)
        scatter(X(1:n0,1),X(1:n0,2),eps,[0 0.4470 0.7410],'.')
        hold on
        scatter(X(n0+1:2*n0,1),X(n0+1:2*n0,2),eps,[0.8500 0.3250 0.0980],'.');
        scatter(X(2*n0+1:3*n0,1),X(2*n0+1:3*n0,2),eps,[0.4660 0.6740 0.1880],'.');
        axis equal off
        title('Original space')
        legend('cluster 1','cluster 2','cluster 3')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        % sparse matrix
        D = similarityMatrix(X,n);

        nn=ceil(3*u);
        k=nn;

        [Dsorted,I]=sort(D,2,'descend');

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

%         Dsp=zeros(n,n);
%         Dsp(1:n0,1:n0)=D(1:n0,1:n0);
%         Dsp(n0+1:2*n0,n0+1:2*n0)=D(n0+1:2*n0,n0+1:2*n0);
%         Dsp(2*n0+1:3*n0,2*n0+1:3*n0)=D(2*n0+1:3*n0,2*n0+1:3*n0);

    case 'trefoil'

        n=200;

        X=zeros(n,n);
        L=zeros(n,1);
        for i=1:n
            t=i*2*pi/n;
            X(i,1)=sin(t)+2*sin(2*t);
            X(i,2)=cos(t)-2*cos(2*t);
            X(i,3)=-sin(3*t);
            L(i,1)=t;
        end

        figure(pid)
        scatter3(X(:,1),X(:,2),X(:,3),eps,L,'.');
        colormap(parula(n))
        axis equal off
        title('Original space of trefoil knot')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        % write colormap in txt file to use the same in Julia
        txtName=sprintf('%s.txt',problem{pid});
        cmap=colormap;
        writematrix(cmap,txtName);

        copyfile(txtName,'../')

        figure(100)
        scatter(X(:,1),X(:,2),eps,L,'.');
        axis equal off
        title('Original space of trefoil knot')
        imgName2D=sprintf('%s2D.png',problem{pid});
        saveas(gcf,imgName2D)

        D = similarityMatrix(X,n);

        nn=ceil(3*u);
        k=nn;

        [Dsorted,I]=sort(D,2,'descend');

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
                %Dsp(I(i,j),i)=Dsp(i,I(i,j));
            end
        end

%         % brute k-nn search
%         Dsp = bruteKNN(X,n,k);
% 
%         % time execution of brute k-nn search
%         f1=@()bruteKNN(X,n,k);
%         t_br=timeit(f1);
%         t_br_2=sprintf('%10e',t_br);
%         
%         % fast k-nn search
%         Dsp = fastKNN(X',n,k);
% 
%         % time execution of fast k-nn search
%         f2=@()fastKNN(X',n,k);
%         t_fast=timeit(f2);
%         t_fast_2=sprintf('%10e',t_fast);
% 
%         diff=t_br-t_fast;
%         diff_2=sprintf('%10e',diff);
        

%         colSum=sum(Dsp,1);
%         Dsp(colSum~=0) = Dsp(colSum~=0) ./ colSum(colSum~=0);         % make column stochastic

    case 'concentricCircles'
        n0=200;
        n=2*n0;

        X=zeros(n,n);

        muCC=zeros(n0,n0);
        sigmaCC=ones(n0,n0);

        cluster1CC=normrnd(muCC,sigmaCC,n0,n0);
        cluster2CC=normrnd(muCC,50*sigmaCC,n0,n0);

        X=[cluster1CC; cluster2CC;];

        figure(pid)
        scatter(X(1:n0,1),X(1:n0,2),eps,[0 0.4470 0.7410],'.')
        hold on
        scatter(X(n0+1:2*n0,1),X(n0+1:2*n0,2),eps,[0.8500 0.3250 0.0980],'.');
        axis equal off
        title('Original space')
        legend('\sigma1=1','\sigma2=50')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        D = similarityMatrix(X,n);

        % sparse matrix
        [Dsorted,I]=sort(D,2,'descend');

        nn=ceil(3*u);
        k=nn;

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

%         % sparse stochastic matrix
%         Dsp=zeros(n,n);
%         % cluster 1
%         Dsp(n0/2+1:n0+n0/2,n0/2+1:n0+n0/2)=D(1:n0,1:n0); 
%         % cluster 2
%         Dsp(1:n0/2,1:n0/2)=D(n0+1:n0+n0/2,n0+1:n0+n0/2);
%         Dsp(n0+n0/2+1:n,n0+n0/2+1:n)=D(n0+n0/2+1:n,n0+n0/2+1:n);
%         Dsp(1:n0/2,n0+n0/2+1:n)=D(n0+1:n0+n0/2,n0+n0/2+1:n);
%         Dsp(n0+n0/2+1:n,1:n0/2)=D(n0+n0/2+1:n,n0+1:n0+n0/2);

    case 'noise'
        n=500;
        mu=zeros(n,n);
        sigma=ones(n,n);

        X=normrnd(mu,sigma,n,n);

        figure(pid)
        scatter(X(:,1),X(:,2),eps,[0 0.4470 0.7410],'.');
        axis equal off
        title('Original space')
        legend('noise')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        D = similarityMatrix(X,n);

        % sparse matrix
        [Dsorted,I]=sort(D,2,'descend');
        
        nn=ceil(3*u);
        k=nn;

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

    case 'ellipse'
        n=200;

        muSh=zeros(n,n);
        sigmaSh=ones(n,n);

        X=normrnd(muSh,sigmaSh,n,n);

        for i=1:n
            for j=1:n
                X(i,j)=X(i,j)/j;
            end
        end

        figure(pid)
        scatter(X(:,1),X(:,2),eps,[0 0.4470 0.7410],'.');
        axis equal off
        title('Original space')
        legend('ellipse')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        D = similarityMatrix(X,n);

        % sparse matrix
        [Dsorted,I]=sort(D,2,'descend');

        nn=ceil(3*u);
        k=nn;

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

    case 'parallelLines'
        n0=200;
        n=2*n0;

        m2Sh=zeros(n0,n0);
        sigma2Sh=ones(n0,n0);

        cluster1Sh=normrnd(m2Sh,sigma2Sh,n0,n0);
        cluster2Sh=cluster1Sh;

        s=0.03*n;

        for i=1:n0
            cluster1Sh(i,1)=s*cluster1Sh(i,1)+i;
            cluster2Sh(i,1)=s*cluster2Sh(i,1)+i+n/5;
            for j=2:n0
                cluster1Sh(i,j)=s*cluster1Sh(i,j)+i;
                cluster2Sh(i,j)=s*cluster2Sh(i,j)+i-n/5;
            end
        end

        X=[cluster1Sh; cluster2Sh;];

        figure(pid)
        scatter(X(1:n0,1),X(1:n0,2),eps,[0 0.4470 0.7410],'.')
        hold on
        scatter(X(n0+1:2*n0,1),X(n0+1:2*n0,2),eps,[0.8500 0.3250 0.0980],'.');
        axis equal off
        title('Original space')
        legend('cluster1','cluster2')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        D = similarityMatrix(X,n);

        % sparse matrix
        [Dsorted,I]=sort(D,2,'descend');

        nn=ceil(3*u);
        k=nn;

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

%         % sparse matrix
%         Dsp=zeros(n,n);
%         Dsp(1:n0,1:n0)=D(1:n0,1:n0);
%         Dsp(n0+1:2*n0,n0+1:2*n0)=D(n0+1:2*n0,n0+1:2*n0);

    case 'circle'
        n=200;
        X=zeros(n,2);
        L=zeros(n,1);
        for i=1:n
            t=2*pi*i/n;
            X(i,1)=cos(t);
            X(i,2)=sin(t);
            L(i,1)=t;
        end

        figure(pid)
        scatter(X(:,1),X(:,2),eps,L,'.');
        colormap(parula(n))
        axis equal off
        title('Original space of circle')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        % write colormap in txt file to use the same in Julia
        txtName=sprintf('%s.txt',problem{pid});
        cmap=colormap;
        writematrix(cmap,txtName);

        copyfile(txtName,'../')

        D = similarityMatrix(X,n);

        % sparse matrix
        [Dsorted,I]=sort(D,2,'descend');
        nn=ceil(3*u);
        k=nn;

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end
     
    case 'randomCircle'
        n=200;
        X=zeros(n,2);
        L=zeros(n,1);
        for i=1:n
            t=2*pi*rand();
            X(i,1)=cos(t);
            X(i,2)=sin(t);
            L(i,1)=t;
        end

        figure(pid)
        scatter(X(:,1),X(:,2),eps,L,'.');
        colormap(parula(n))
        axis equal off
        title('Original space of random circle')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        % write colormap in txt file to use the same in Julia
        txtName=sprintf('%s.txt',problem{pid});
        cmap=colormap;
        writematrix(cmap,txtName);

        copyfile(txtName,'../')

        % write L in txt file to use the same in Julia
        txtName2=sprintf('L-%s.txt',problem{pid});
        cmap=colormap;
        writematrix(L,txtName2);

        copyfile(txtName2,'../')

        D = similarityMatrix(X,n);

        % sparse matrix
        [Dsorted,I]=sort(D,2,'descend');
        nn=ceil(3*u);
        k=nn;

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

    case 'orthogonalSteps'
        n=200;
        X=zeros(n,2);

        L=ones(n,1);
        L(1,1)=1.5*pi/n;

        for i=2:n
            for j=1:2
                X(i,j)=X(i-1,j)+1;
            end
            L(i,1)=1.5*pi*i/n;
        end

        figure(pid)
        scatter(X(:,1),X(:,2),eps,L,'.');
        colormap(parula(n))
        axis equal off
        title('Original space of orthogonal steps')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        % write colormap in txt file to use the same in Julia
        txtName=sprintf('%s.txt',problem{pid});
        cmap=colormap;
        writematrix(cmap,txtName);

        copyfile(txtName,'../')

        D = similarityMatrix(X,n);

        % sparse stochastic matrix
        [Dsorted,I]=sort(D,2,'descend');
        nn=ceil(3*u);
        k=nn;

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

    case 'randomWalk'
        n=200;
        X=zeros(n,2);

        L=ones(n,1);
        L(1,1)=1.5*pi/n;

        X(1,:)=normrnd([0,0],[1,1],1,2);

        for i=2:n
            for j=1:2
                X(i,j)=X(i-1,j)+normrnd(0,1);
            end
            L(i,1)=1.5*pi*i/n;
        end

        figure(pid)
        scatter(X(:,1),X(:,2),eps,L,'.');
        colormap(parula(n))
        axis equal off
        title('Original space of random walk')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        % write colormap in txt file to use the same in Julia
        txtName=sprintf('%s.txt',problem{pid});
        cmap=colormap;
        writematrix(cmap,txtName);

        copyfile(txtName,'../')

        D = similarityMatrix(X,n);

        % sparse matrix
        [Dsorted,I]=sort(D,2,'descend');
        nn=ceil(3*u);
        k=nn;

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

    case 'randomJump'
        n=200;
        X=zeros(n,2);

        L=ones(n,1);
        L(1,1)=1.5*pi/n;

        r=sqrt(2)*normrnd([0,0],[1,1],1,2);

        X(1,:)=normrnd([0,0],[1,1],1,2)+r;

        for i=2:n
            for j=1:2
                rj=sqrt(2)*normrnd(0,1);
                X(i,j)=X(i-1,j)+normrnd(0,1)+rj;
            end
            L(i,1)=1.5*pi*i/n;
        end

        figure(pid)
        scatter(X(:,1),X(:,2),eps,L,'.');
        colormap(parula(n))
        axis equal off
        title('Original space of random jump')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        % write colormap in txt file to use the same in Julia
        txtName=sprintf('%s.txt',problem{pid});
        cmap=colormap;
        writematrix(cmap,txtName);

        copyfile(txtName,'../')

        D = similarityMatrix(X,n);

        % sparse stochastic matrix
        [Dsorted,I]=sort(D,2,'descend');
        %u=5;
        nn=ceil(3*u);
        k=nn;

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

    case 'simplex'
        n=200;
        X=zeros(n,n);

%         noise=0.5;

        for i=1:n
            for j=1:n
                if j==i
%                     X(i,j)=noise*normrnd(0,1)+1;
                      X(i,j)=1;
                end
            end
        end

        figure(pid)
        scatter3(X(:,1),X(:,2),X(:,3),200,[0 0.4470 0.7410],'.');
%         axis equal off
        xlabel('x')
        ylabel('y')
        zlabel('z')   
        title('Original 3D space')
        legend('simplex vertex')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        figure(300)
        scatter(X(:,1),X(:,2),200,[0 0.4470 0.7410],'.');
        %         axis equal off
        xlabel('x')
        ylabel('y')
        title('Original 2D space')
        legend('simplex vertex')
        imgName2D=sprintf('%s2D.png',problem{pid});
        saveas(gcf,imgName2D)

        figure(200)
        tetramesh([1 2 3 4],X,'FaceAlpha',0.1)
%         axis equal off
        xlabel('x')
        ylabel('y')
        zlabel('z') 
        title('simplex')

        D = similarityMatrix(X,n);

        % sparse matrix
        [Dsorted,I]=sort(D,2,'descend');
        nn=ceil(3*u);
        k=nn;

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

    case 'uniform'

        n=200;
        X=rand(n,n);

        figure(pid)
        scatter(X(:,1),X(:,2),eps,[0 0.4470 0.7410],'.');
        axis equal off
        title('Original space')
        legend('uniform distribution')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        D = similarityMatrix(X,n);

        % sparse matrix
        [Dsorted,I]=sort(D,2,'descend');
        nn=ceil(3*u);
        k=nn;

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
            end
        end

    case 'linkedRings'

        n0=700;
        n=2*n0;

        for i=1:n0
            t=i*2*pi/n0;

            x1=cos(t);
            y1=sin(t);
            z1=0;

            x2=cos(t)+1;
            y2=0;
            z2=sin(t);

            X(i,1)=x1;
            X(i,2)=cos(0.4)*y1+sin(0.4)*z1;
            X(i,3)=-sin(0.4)*y1+cos(0.4)*z1;

            X(i+n0,1)=x2;
            X(i+n0,2)=cos(0.4)*y2+sin(0.4)*z2;
            X(i+n0,3)=-sin(0.4)*y2+cos(0.4)*z2;

        end

        figure(pid)
        scatter3(X(1:n0,1),X(1:n0,2),X(1:n0,3),eps,[0 0.4470 0.7410],'.')
        hold on
        scatter3(X(n0+1:2*n0,1),X(n0+1:2*n0,2),X(n0+1:2*n0,3),eps,[0.8500 0.3250 0.0980],'.');
        axis equal off
        title('Original space')
        legend('cluster 1','cluster 2')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        figure(400)
        scatter(X(1:n0,1),X(1:n0,2),eps,[0 0.4470 0.7410],'.')
        hold on
        scatter(X(n0+1:2*n0,1),X(n0+1:2*n0,2),eps,[0.8500 0.3250 0.0980],'.');
        axis equal off
        title('Original 2D space')
        imgName2D=sprintf('%s2D.png',problem{pid});
        saveas(gcf,imgName2D)

        D = similarityMatrix(X,n);

        % sparse matrix
        nn=ceil(3*u);
        k=nn;

        [Dsorted,I]=sort(D,2,'descend');

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
                %Dsp(I(i,j),i)=Dsp(i,I(i,j));
            end
        end

%         Dsp=zeros(n,n);
%         Dsp(1:n0,1:n0)=D(1:n0,1:n0);
%         Dsp(n0+1:2*n0,n0+1:2*n0)=D(n0+1:2*n0,n0+1:2*n0);

    case 'unlinkedRings'

        n0=700;
        n=2*n0;

        for i=1:n0
            t=i*2*pi/n0;

            x1=cos(t);
            y1=sin(t);
            z1=0;

            x2=cos(t)+3;
            y2=0;
            z2=sin(t);

            X(i,1)=x1;
            X(i,2)=cos(0.4)*y1+sin(0.4)*z1;
            X(i,3)=-sin(0.4)*y1+cos(0.4)*z1;

            X(i+n0,1)=x2;
            X(i+n0,2)=cos(0.4)*y2+sin(0.4)*z2;
            X(i+n0,3)=-sin(0.4)*y2+cos(0.4)*z2;

        end

        figure(pid)
        scatter3(X(1:n0,1),X(1:n0,2),X(1:n0,3),eps,[0 0.4470 0.7410],'.')
        hold on
        scatter3(X(n0+1:2*n0,1),X(n0+1:2*n0,2),X(n0+1:2*n0,3),eps,[0.8500 0.3250 0.0980],'.');
        axis equal off
        title('Original space')
        legend('cluster 1','cluster 2')
        imgName=sprintf('%s.png',problem{pid});
        saveas(gcf,imgName)

        figure(500)
        scatter(X(1:n0,1),X(1:n0,2),eps,[0 0.4470 0.7410],'.')
        hold on
        scatter(X(n0+1:2*n0,1),X(n0+1:2*n0,2),eps,[0.8500 0.3250 0.0980],'.');
        axis equal off
        title('Original 2D space')
        imgName2D=sprintf('%s2D.png',problem{pid});
        saveas(gcf,imgName2D)

        D = similarityMatrix(X,n);

        % sparse matrix
        nn=ceil(3*u);
        k=nn;

        [Dsorted,I]=sort(D,2,'descend');

        Dsp=zeros(n,n);
        for i=1:n
            for j=1:k
                Dsp(i,I(i,j))=D(i,I(i,j));
                %Dsp(I(i,j),i)=Dsp(i,I(i,j));
            end
        end

%         Dsp=zeros(n,n);
%         Dsp(1:n0,1:n0)=D(1:n0,1:n0);
%         Dsp(n0+1:2*n0,n0+1:2*n0)=D(n0+1:2*n0,n0+1:2*n0);

end

title_mess=sprintf('%s%d\n','Sparse graph k = ',nn);

figure(length(problem)+1)
spy(Dsp,'.k')
title(title_mess)
img2Name=sprintf('SPARSE%s.png',problem{pid});
saveas(gcf,img2Name)

%% Write mtx file
DspF=sparse(Dsp);
fileName=sprintf('%s.mtx',problem{pid});
mmwrite(fileName,DspF);

fileNamePer=sprintf('%s-demo-perpl.mtx',problem{pid});
if (pid==16) 
    X=sparse(X);
end
mmwrite(fileNamePer,X);

% run following lines to copy files to folder pluto data
copyfile(fileName,'../')
copyfile(fileNamePer,'../')
copyfile(imgName,'../')
copyfile(img2Name,'../')