% close all
clear all
N=50;
eta=0.01;    %%% constante de aprendizaje
a=1;        %%% valor de la función vecindad
%%%% define random synaptic weigths

offsetI = 8;
offsetJ = 8;

wr=rand(N,N);
wg=rand(N,N);
wb=rand(N,N);

ITER=600000;

for iter=1:ITER
    if(mod(iter,10000)==0)
        iter
    end
    
    rgbm=rand(3,1);          %%% get a random sample
    
    jw=0;iw=0;
    [d jw]=min(min((wr(offsetI+1:N-offsetI,offsetJ+1:N-offsetJ)-rgbm(1)).^2+(wg(offsetI+1:N-offsetI,offsetJ+1:N-offsetJ)-rgbm(2)).^2+(wb(offsetI+1:N-offsetI,offsetJ+1:N-offsetJ)-rgbm(3)).^2));
    [d iw]=min(min((wr(offsetI+1:N-offsetI,offsetJ+1:N-offsetJ)'-rgbm(1)).^2+(wg(offsetI+1:N-offsetI,offsetJ+1:N-offsetJ)'-rgbm(2)).^2+(wb(offsetI+1:N-offsetI,offsetJ+1:N-offsetJ)'-rgbm(3)).^2));
    
    jw=jw+offsetJ;
    iw=iw+offsetI;
    
    %%% Actualizo la neurona ganadora
    wr(iw,jw) = wr(iw,jw) + eta * (rgbm(1)-wr(iw,jw));
    wg(iw,jw) = wg(iw,jw) + eta * (rgbm(2)-wg(iw,jw));
    wb(iw,jw) = wb(iw,jw) + eta * (rgbm(3)-wb(iw,jw));
    
    %%% Si el número de iteración es menor a ITER/2 la vecindad cubre a 7x7
    %%% neuronas
    
    vecindad= -offsetI:1:offsetJ;
    if iter <= ITER/2
        for i=vecindad
            for j=vecindad
                if(i~=0 & j~=0)
                    wr(iw+i,jw+j) = wr(iw+i,jw+j) + (a/4)*eta * (rgbm(1)-wr(iw+i,jw+j));
                    wg(iw+i,jw+j) = wg(iw+i,jw+j) + (a/4)*eta * (rgbm(2)-wg(iw+i,jw+j));
                    wb(iw+i,jw+j) = wb(iw+i,jw+j) + (a/4)*eta * (rgbm(3)-wb(iw+i,jw+j));
                end
            end
        end
    end
    
    vecindad= -5:1:5;
    if iter > ITER/2 & iter <= 3*ITER/4
        for i=vecindad
            for j=vecindad
                if(i~=0 & j~=0)
                    wr(iw+i,jw+j) = wr(iw+i,jw+j) + (a/2)*eta * (rgbm(1)-wr(iw+i,jw+j));
                    wg(iw+i,jw+j) = wg(iw+i,jw+j) + (a/2)*eta * (rgbm(2)-wg(iw+i,jw+j));
                    wb(iw+i,jw+j) = wb(iw+i,jw+j) + (a/2)*eta * (rgbm(3)-wb(iw+i,jw+j));
                end
            end
        end
    end
    
    vecindad= -2:1:2;
    if iter > 3*ITER/4 & iter < 9*ITER/10
        for i=vecindad
            for j=vecindad
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