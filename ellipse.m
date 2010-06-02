function x = ellipse(a,b,c)
    x = zeros(100);
    N = max(a,b)*2;
    for i = 1:N
        for j = 1:N
            x(i,j) = ((((i-N/2)*cosd(c)-(j-N/2)*sind(c)))^2)/a^2+((((j-N/2)*cosd(c)+(i-N/2)*sind(c)))^2)/b^2 <= 1;
        end
    end
end