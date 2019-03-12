function map = list2grid(x, y, xmax, ymax)
    map = false(ymax, xmax);
    len = length(x);

    for l = 1:len
        map(y(l),x(l)) = 1;
    end
end