function map = mark_obj(map,objects,found_dist)
    for object = objects
        if object.dist > found_dist && object.dist < 0.1
            map = add_ellipse(map,exp(-object.dist^2 *5),object.loc(1),object.loc(2),object.xSize,object.ySize,0);
        else
            if object.dist < found_dist
                map = add_ellipse_abs(map,-2,object.loc(1),object.loc(2),object.xSize,object.ySize,0);
            end
        end
    end
end