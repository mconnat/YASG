local Utils = {}

-- https://stackoverflow.com/questions/401847/circle-rectangle-collision-detection-intersection/402010#402010

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

-- Check Distance between the 2 cricle's center
-- If the distance is less than the radii, it means they are overlapping
function Utils.CircleCollision(circleA, circleB)
    local dist = math.sqrt((circleA.x - circleB.x) ^ 2 + (circleA.y - circleB.y) ^ 2)
    return dist <= circleA.radius + circleB.radius
end

return Utils
