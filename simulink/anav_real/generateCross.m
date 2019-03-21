function cross = generateCross(size)
% input odd number to generate x,y,z coordinate list
% representing a cross of 1x lines of length size 
cross = zeros(2*size+1, 3);
    %  Points for vertical line 
    for r = 1:size
        cross(r,1) = r-round(size/2,0);
        cross(r+size+1,2) = r-round(size/2,0);
    end
end