function idx=qtcluster(objects,d,D)
% QT clustering algorithm as described in:
%
% Heyer, L. J., Kruglyak, S., Yooseph, S. (1999). Exploring expression
% data: Identification and analysis of coexpressed genes. Genome Research
% 9, 1106–1115.  
%
% http://genome.cshlp.org/content/9/11/1106.full
% http://genome.cshlp.org/content/9/11/1106/F5.large.jpg
%
% if two sets A{i} have same cardinality, we pick first one
% our distance measure is Euclidean distance
%
% input:
% G-nxp data to cluster
% d-diameter threshold
% D-Euclidean distance for all 0<i<j<=n
%
% output:
% idx-nx1 vector containing cluster indices
%
% Misha Koshelev
% January 20th, 2009
% Montague Laboratory
    
    n=length(objects);
    if n<=1
        idx=ones(n,1);
        return;
    end
    if nargin<3
        D=Inf*ones(n,n);
        for i = 1:length(objects)
            for j = 1:length(objects)
                D(i, j) = delta_dist(objects(i),objects(j));
            end
        end
    end
    
    C=[];Ccard=0;Cdiam=0;    
    for i=1:n
        flag=true;
        A=[i];Acard=1;Adiam=0;
        while flag&&length(A)<n
            pts=1:n;pts(A)=[];
            jdiam=zeros(length(pts),1);
            for pidx=1:length(pts)
                % We only need to compute maximal distance from new point j to all
                % existing points in cluster
                jdiam(pidx)=max(D(pts(pidx),A));
            end
            [minjdiam,pidx]=min(jdiam);j=pts(pidx);
            if minjdiam < inf && (sum(jdiam==minjdiam)>1)
                %dbstack;keyboard;
            end
            
            if max(Adiam,minjdiam)>d
                flag=false;
            else
                A=[A,j];
                Acard=Acard+1;
                Adiam=max(Adiam,minjdiam);
            end
        end

        A=sort(A);
        if Acard>Ccard
            C=A;
            Ccard=Acard;
            Cdiam=Adiam;
        end
    end

    idx=ones(n,1);
    GmC=1:n;GmC(C)=[];
    idx(GmC)=qtcluster(objects(GmC),d,D(GmC,GmC))+1;
    
function d=diam(G,clust)
% http://thesaurus.maths.org/mmkb/entry.html?action=entryByConcept&id=3279
% The largest distance between any two points in a set is called the  set's diameter. 
%
% input:
% G-nxp data for our cluster
% clust-vector of row indices into G
%
    
    dsqr=0;
    for k=1:length(clust)
        for k2=k:length(clust)
            dsqr=max(dsqr,sum((G(clust(k),:)-G(clust(k2),:)).^2));
        end
    end
    d=sqrt(dsqr);
    