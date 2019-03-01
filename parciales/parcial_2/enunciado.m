% close all
clear all
N=50;
eta=0.1;    %%% constante de aprendizaje
a=0.0;        %%% valor de la función vecindad
%%%% define random synaptic weigths

wr=rand(N,N);
wg=rand(N,N);
wb=rand(N,N);

ITER=200000;

for iter=1:ITER
    if(mod(iter,10000)==0)
        iter
    end
    
    rgbm=rand(3,1);          %%% get a random sample
    
    jw=0;iw=0;
    [d jw]=min(min((wr(4:N-3,4:N-3)-rgbm(1)).^2+(wg(4:N-3,4:N-3)-rgbm(2)).^2+(wb(4:N-3,4:N-3)-rgbm(3)).^2));
    [d iw]=min(min((wr(4:N-3,4:N-3)'-rgbm(1)).^2+(wg(4:N-3,4:N-3)'-rgbm(2)).^2+(wb(4:N-3,4:N-3)'-rgbm(3)).^2));
    
    jw=jw+3;
    iw=iw+3;
    
    %%% Actualizo la neurona ganadora
    wr(iw,jw) = wr(iw,jw) + eta * (rgbm(1)-wr(iw,jw));
    wg(iw,jw) = wg(iw,jw) + eta * (rgbm(2)-wg(iw,jw));
    wb(iw,jw) = wb(iw,jw) + eta * (rgbm(3)-wb(iw,jw));
    
    %%% Si el número de iteración es menor a ITER/2 la vecindad cubre a 7x7
    %%% neuronas
    if iter <= ITER/2
        for i=[-3 -2 -1 0 1 2 3]
            for j=[-3 -2 -1 0 1 2 3]
                if(i~=0 & j~=0)
                    wr(iw+i,jw+j) = wr(iw+i,jw+j) + (a/4)*eta * (rgbm(1)-wr(iw+i,jw+j));
                    wg(iw+i,jw+j) = wg(iw+i,jw+j) + (a/4)*eta * (rgbm(2)-wg(iw+i,jw+j));
                    wb(iw+i,jw+j) = wb(iw+i,jw+j) + (a/4)*eta * (rgbm(3)-wb(iw+i,jw+j));
                end
            end
        end
    end
    
    if iter > ITER/2 & iter <= 3*ITER/4
        for i=[-2 -1 0 1 2]
            for j=[-2 -1 0 1 2]
                if(i~=0 & j~=0)
                    wr(iw+i,jw+j) = wr(iw+i,jw+j) + (a/2)*eta * (rgbm(1)-wr(iw+i,jw+j));
                    wg(iw+i,jw+j) = wg(iw+i,jw+j) + (a/2)*eta * (rgbm(2)-wg(iw+i,jw+j));
                    wb(iw+i,jw+j) = wb(iw+i,jw+j) + (a/2)*eta * (rgbm(3)-wb(iw+i,jw+j));
                end
            end
        end
    end
    
    if iter > 3*ITER/4 & iter < 9*ITER/10
        for i=[-1 0 1]
            for j=[-1 0 1]
                if(i~=0 & j~=0)
                    wr(iw+i,jw+j) = wr(iw+i,jw+j) + a*eta * (rgbm(1)-wr(iw+i,jw+j));
                    wg(iw+i,jw+j) = wg(iw+i,jw+j) + a*eta * (rgbm(2)-wg(iw+i,jw+j));
                    wb(iw+i,jw+j) = wb(iw+i,jw+j) + a*eta * (rgbm(3)-wb(iw+i,jw+j));
                end
            end
        end
    end
end

figure;hold on
for i=3:N-2
    for j=3:N-2
        plot(i,j,'.','color',[wr(i,j) wg(i,j) wb(i,j)],'markersize',20)
    end
end