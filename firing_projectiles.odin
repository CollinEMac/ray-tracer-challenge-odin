package main 

Projectile :: struct {
    position: Point,
    velocity: Vector
}

Environment :: struct {
    gravity: Vector,
    wind: Vector 
}

tick :: proc(env: Environment, proj: Projectile) -> Projectile {
    position := add(proj.position, proj.velocity)

    // I have to add in two steps because my add function only supposed 2 inputs
    velocity := add(add(proj.velocity, env.gravity), env.wind)
    
    return Projectile { position, velocity }
}

