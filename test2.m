a = ones(5);

for i = 1:5
    for j  = 1:5
        if(i > j)
            a(i,j) = rand(1);
        end
    end
end

[r,c] = find(a < 0.5);

d = [r,c];

for i = 1:size(d,1)
    if d(i,1) > d(i,2)
        temp = d(i,1);
        d(i,1) = d(i,2);
        d(i,2) = temp;
    end
end

[~,ix] = sort(d(:,1));

d(:,1) = d(ix,1);
d(:,2) = d(ix,2);
for i = 1:size(d,1)
    if d(i,1) > d(i,2)
        temp = d(i,1);
        d(i,1) = d(i,2);
        d(i,2) = temp;
    end
end