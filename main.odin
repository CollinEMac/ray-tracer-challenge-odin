package main

Tuple :: struct {
    x, y, z, w: f32,
}

point :: proc(x, y, z: f32) -> Tuple {
    return Tuple{ x, y, z, 1.0 }
}

is_point :: proc(tuple: Tuple) -> bool {
    return tuple.w == 1.0
}

vector :: proc(x, y, z: f32) -> Tuple {
    return Tuple{ x, y, z, 0.0 }
}

is_vector :: proc(tuple: Tuple) -> bool {
    return tuple.w == 0.0
}

equals :: proc(tuple1: Tuple, tuple2: Tuple) -> bool {
    return tuple1 == tuple2
}

add :: proc(a1: Tuple, a2: Tuple) -> Tuple {
    return Tuple{ a1.x + a2.x, a1.y + a2.y, a1.z + a2.z, a1.w + a2.w }
}

subtract :: proc(a1: Tuple, a2: Tuple) -> Tuple {
    return Tuple{ a1.x - a2.x, a1.y - a2.y, a1.z - a2.z, a1.w - a2.w }
}

negate :: proc(tuple: Tuple) -> Tuple {
    return Tuple{ -tuple.x, -tuple.y, -tuple.z, -tuple.w }
}

mult :: proc(tuple: Tuple, n: f32) -> Tuple {
    return Tuple{ n*tuple.x, n*tuple.y, n*tuple.z, n*tuple.w }
}

div :: proc(tuple: Tuple, n: f32) -> Tuple {
    return Tuple{ tuple.x/n, tuple.y/n, tuple.z/n, tuple.w/n }
}

