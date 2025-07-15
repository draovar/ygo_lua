function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

function norm_speed(x, y, s)
    len = math.sqrt(x * x + y * y)
    if len ~= 0 and len ~= 1 then
        x = x / (len / s)
        y = y / (len / s)
    end
    return x,y
end