alphas = (4);
betas = (0.05);

ji_avg_results = zeros(length(alphas)*length(betas), 7);

for i=1:length(alphas)
    for j=1:length(betas)
        
        ji_avg_results(i*j, 1) = alphas(i);
        ji_avg_results(i*j, 2) = betas(j);
        
        array = evaluateSystem(alphas(i), betas(j));
        
        for k=1:length(array)
            ji_avg_results(i*j, k+2) = array(k);
        end
        fprintf('\n');
            
    end
end
