package main

import "core:math"

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
    // multiply
    return Tuple{ n*tuple.x, n*tuple.y, n*tuple.z, n*tuple.w }
}

div :: proc(tuple: Tuple, n: f32) -> Tuple {
    // division
    return Tuple{ tuple.x/n, tuple.y/n, tuple.z/n, tuple.w/n }
}

mag :: proc(t: Tuple) -> f32 {
    // magnitude of a vector
    return math.sqrt(
        math.pow(t.x, 2) +
        math.pow(t.y, 2) +
        math.pow(t.z, 2) +
        math.pow(t.w, 2))
}

norm :: proc(t: Tuple) -> Tuple {
    // normalize a vector
    magnitude := mag(t)
    return Tuple {
        t.x / magnitude,
        t.y / magnitude,
        t.z / magnitude,
        t.w / magnitude
    }
}

dot :: proc(a, b: Tuple) -> f32 {
    // The dot product of two vectors
    return a.x * b.x +
        a.y * b.y +
        a.z * b.z +
        a.w * b.w
}

cross :: proc(a, b: Tuple) -> Tuple {
    // The cross product of two vectors
    return vector(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    )
}
