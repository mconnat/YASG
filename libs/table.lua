function table.merge(t1, t2)
    for key, value in pairs(t2) do
        t1[key] = value
    end

    return t1
end

function table.copy(t)
    local u = {}
    for k, v in pairs(t) do u[k] = v end
    return setmetatable(u, getmetatable(t))
end

function table.dump(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end
