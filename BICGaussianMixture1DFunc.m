function[x,y,mu,sigma,phi,peaks,order] = BICGaussianMixture1DFunc(X)
BIC = zeros(10,1);
for iter=1:100
    disp(['Iter:',num2str(iter)])
    [x,y,mu,sigma,phi,peaks] = GaussianMixture1DFunc(X, iter);
    
    for n=1:numel(X)
        ppdf = sum(phi.*gaussian1D(X(n), mu, sigma));
        BIC(iter) = BIC(iter) + log(ppdf);
    end
    BIC(iter) = BIC(iter) - 3*iter*log(numel(X));
    if(iter == 1)
        bestx = x;
        besty = y;
        bestmu = mu;
        bestsigma = sigma;
        bestphi = phi;
        bestpeaks = peaks;
        order = iter;
    else
        if(BIC(iter) > BIC(iter -1))
            bestx = x;
            besty = y;
            bestmu = mu;
            bestsigma = sigma;
            bestphi = phi;
            bestpeaks = peaks;
            order = iter;
        else
            break;
        end
    end
end

x = bestx;
y = besty;
mu = bestmu;
sigma = bestsigma;
phi = bestphi;
peaks = bestpeaks;