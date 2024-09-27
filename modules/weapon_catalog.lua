WeaponCatalog = {
    {
        name = "Pistol",
        image = love.graphics.newImage("assets/sprites/Pistol.png"),
        bulletImage = love.graphics.newImage("assets/sprites/Bullet.png"),
        distanceFromHero = 40,
        maxBulletDistance = 300,
        damage = 1,
        unlocked = true
    },
    {
        name = "Shotgun",
        image = love.graphics.newImage("assets/sprites/Shotgun.png"),
        bulletImage = love.graphics.newImage("assets/sprites/DoubleBullet.png"),
        distanceFromHero = 40,
        maxBulletDistance = 150,
        damage = 2,
        unlocked = false
    },
}

return WeaponCatalog
