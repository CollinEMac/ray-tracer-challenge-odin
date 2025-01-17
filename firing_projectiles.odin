package main 

Projectile :: struct {
    position: Tuple,
    velocity: Tuple
}

Environment :: struct {
    gravity: Tuple,
    wind: Tuple
}

tick :: proc(env: Environment, proj: Projectile) -> Projectile {
    position := add(proj.position, proj.velocity)

    // I have to add in two steps because my add function only supposed 2 inputs
    velocity := add(add(proj.velocity, env.gravity), env.wind)
    
    return Projectile { position, velocity }
}

