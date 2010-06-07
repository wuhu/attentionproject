
a = [1.4,1.4]
scatter(a(1),a(2))
hold on
for i = 0:300
    b = rot2d(a,[1,1],i);
    scatter(b(1),b(2))
end

axis([0 3 0 3])