function JI=computeJI(gtbox, predbox)

gtbox(3)=gtbox(1)+gtbox(3);
gtbox(4)=gtbox(2)+gtbox(4);
predbox(3)=predbox(1)+predbox(3);
predbox(4)=predbox(2)+predbox(4);
    
x_left = max(gtbox(1), predbox(1));
y_top = max(gtbox(2),  predbox(2));
x_right = min(gtbox(3), predbox(3));
y_bottom = min(gtbox(4), predbox(4));

%if they do not intersect
if x_right < x_left || y_bottom < y_top
     JI=0;  
else
    %Intersection area
    intersection_area = (x_right - x_left) * (y_bottom - y_top);

    %Union areas
    gt_area = (gtbox(3) - gtbox(1)) * (gtbox(4) - gtbox(2));
    pred_area = (predbox(3) - predbox(1)) * (predbox(4) - predbox(2));
    
    JI=intersection_area/(gt_area+pred_area-intersection_area);
    if(JI<0)
        keyboard;
    end
end