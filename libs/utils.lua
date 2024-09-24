local Utils = {}

function Utils.CircleAndRectangleOverlap(cx, cy, cr, rx, ry, rw, rh)
    local circle_distance_x = math.abs(cx - rx - rw / 2)
    local circle_distance_y = math.abs(cy - ry - rh / 2)

    if circle_distance_x > (rw / 2 + cr) or circle_distance_y > (rh / 2 + cr) then
        return false
    elseif circle_distance_x <= (rw / 2) or circle_distance_y <= (rh / 2) then
        return true
    end

    return (math.pow(circle_distance_x - rw / 2, 2) + math.pow(circle_distance_y - rh / 2, 2)) <= math.pow(cr, 2)
end

return Utils
