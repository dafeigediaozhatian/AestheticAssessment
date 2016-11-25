function c = fuzzyl(x)
% FUZZYL generate a set of centroids for fuzzy membership functions on
% luminance (brightness) channel.
% c is a set of centroids representing 5 luminance bins (very dark, dark, 
% middle, light, verylight); x is input data sequence generated from image 
% segmentation, here represents brightness of different regions)

minx = min(x(:));
maxx = max(x(:));
% initiate 5 membership functions 
bounds = linspace(minx,maxx,7);
n = size(x,1);
c = bounds(2:end-1);

% begin iteration
maxiter = 100;
for iter = 1:maxiter
    new_c = c;
    u = zeros(n,5);
    % calculate u(i,j), the membership value that the i-th pattern belongs 
    % to the j-th semantic word.  
    for i = 1:n
        if x(i) <= c(1)
            u(i,1) = 1;
        else
            if x(i) > c(5)
                u(i,5) = 1;
            else
                for j = 1:5
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
    for j = 1:5
        %if sum(u(:,j))~=0
            new_c(j) = sum(u(:,j).*x(:))/sum(u(:,j));
        %end
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