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
