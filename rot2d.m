function b = rot2d(a, center, deg)
    a = a - center;
    b = [cosd(-deg)*a(1)-sind(-deg)*a(2),sind(-deg)*a(1)+cosd(-deg)*a(2)];
    b = b + center;
end