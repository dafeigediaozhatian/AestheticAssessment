function c = fuzzyc(x)
% FUZZYC generate a set of centroids for fuzzy membership functions on
% chroma (saturation) channel.
% c is a set of centroids representing 3 luminance bins (low saturation, 
% middle saturation and high saturtaion); x is input data sequence 
% generated from image segmentation, here represents saturation of different regions)

minx = min(x(:));
maxx = max(x(:));
% initiate 3 membership functions 
bounds = linspace(minx,maxx,5);
n = size(x,1);
c = bounds(2:end-1);

% begin iteration
maxiter = 100;
for iter = 1:maxiter
    new_c = c;
    u = zeros(n,3);
    % calculate u(i,j), the membership value that the i-th pattern belongs 
    % to the j-th semantic word.  
    for i = 1:n
        if x(i) <= c(1)
            u(i,1) = 1;
        else
            if x(i) > c(3)
                u(i,3) = 1;
            else
                for j = 1:3
                    if x(i)>c(j) && x(i)<=c(j+1)
                        u(i,:) = 0;
                        if c(j+1)-c(j) == 0
                            error('c(j+1)-c(j)==0');
                        end 
                        u(i,j) = (c(j+1)-x(i))/(c(j+1)-c(j));
                        u(i,j+1) = 1-u(i,j);
                    end
                end
            end
        end
    end
    % update the class centoids.
    for j = 1:3
        if sum(u(:,j))~=0
            new_c(j) = sum(u(:,j).*x(:))/sum(u(:,j));
        end
    end
    % convergence test
    d = sum(sqrt(sum((new_c - c).^2,2)));
    if d < 1e-5
        break
    else
        c = new_c;
    end
end
c = round(c);
% disp(iter)