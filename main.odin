package main

import "core:math"
import "core:fmt"

main :: proc() {
    // using this as sort of a playground for now
    p := Projectile { point(0, 1, 0), norm(vector(1, 1, 0)) }
    e := Environment { vector(0, -0.1, 0), vector(-0.01, 0, 0) }

    i := 0
    for i < 20 {
        p = tick(e, p)
        fmt.printf("Position: %f ", p.position.y)
        i += 1
    }
}

Tuple3 :: struct {
    x, y, z: f32,
}

Tuple4 :: struct {
    x, y, z, w: f32,
}

Point :: Tuple4
Vector :: Tuple4
Color :: Tuple3 // unfortunately, as a Tuple3 R,G,B will be X,Y,Z...

point :: proc(x, y, z: f32) -> Point {
    return Point{ x, y, z, 1.0 }
}

is_point :: proc(tuple: Tuple4) -> bool {
    return tuple.w == 1.0
}

vector :: proc(x, y, z: f32) -> Vector {
    return Vector{ x, y, z, 0.0 }
}

is_vector :: proc(tuple: Tuple4) -> bool {
    return tuple.w == 0.0
}

color :: proc(r, g, b: f32) -> Color {
    return Color{ r, g, b }
}

equals :: proc{equals3, equals4}

equals3 :: proc(tuple1, tuple2: Tuple3, ) -> bool {
    return tuple1 == tuple2
}

equals4 :: proc(tuple1, tuple2: Tuple4, ) -> bool {
    return tuple1 == tuple2
}

add :: proc{add3, add4}

add3 :: proc(a1, a2: Tuple3) -> Tuple3 {
    return Tuple3{ a1.x + a2.x, a1.y + a2.y, a1.z + a2.z }
}

add4 :: proc(a1, a2: Tuple4) -> Tuple4 {
    return Tuple4{ a1.x + a2.x, a1.y + a2.y, a1.z + a2.z, a1.w + a2.w }
}

subtract :: proc{subtract3, subtract4}

subtract3 :: proc(a1, a2: Tuple3) -> Tuple3 {
    return Tuple3{ a1.x - a2.x, a1.y - a2.y, a1.z - a2.z}
}

subtract4 :: proc(a1, a2: Tuple4) -> Tuple4 {
    return Tuple4{ a1.x - a2.x, a1.y - a2.y, a1.z - a2.z, a1.w - a2.w }
}

negate :: proc(tuple: Tuple4) -> Tuple4 {
    return Tuple4{ -tuple.x, -tuple.y, -tuple.z, -tuple.w }
}

mult :: proc{mult3, mult4}

mult3 :: proc(tuple: Tuple3, n: f32) -> Tuple3 {
    // multiply
    return Tuple3{ n*tuple.x, n*tuple.y, n*tuple.z }
}

mult4 :: proc(tuple: Tuple4, n: f32) -> Tuple4 {
    // multiply
    return Tuple4{ n*tuple.x, n*tuple.y, n*tuple.z, n*tuple.w }
}

hadamard:: proc(c1, c2: Color) -> Color {
    // multiply each value
    return Color{ c1.x * c2.x, c1.y * c2.y, c1.z * c2.z }
}

div :: proc(tuple: Tuple4, n: f32) -> Tuple4 {
    // division
    return Tuple4{ tuple.x/n, tuple.y/n, tuple.z/n, tuple.w/n }
}

mag :: proc(t: Vector) -> f32 {
    // magnitude of a vector
    return math.sqrt(
        math.pow(t.x, 2) +
        math.pow(t.y, 2) +
        math.pow(t.z, 2) +
        math.pow(t.w, 2))
}

norm :: proc(t: Vector) -> Vector{
    // normalize a vector
    magnitude := mag(t)
    return Vector {
        t.x / magnitude,
        t.y / magnitude,
        t.z / magnitude,
        t.w / magnitude
    }
}

dot :: proc(a, b: Vector) -> f32 {
    // The dot product of two vectors
    return a.x * b.x +
        a.y * b.y +
        a.z * b.z +
        a.w * b.w
}

cross :: proc(a, b: Vector) -> Vector{
    // The cross product of two vectors
    return vector(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    )
}

canvas :: proc(width, height: int) -> [][]Color {
    m := make([][]Color, width)
    for w in 0..< width {
        m[w] = make([]Color, height)
        for h in 0..< height {
            m[w][h] = color(0, 0, 0)
        }
    }
    return m
}

get_width :: proc(m: [][]Tuple3) -> int {
    return len(m)
}

get_height :: proc(m: [][]Tuple3) -> int {
    return len(m[0])
}

pixel_at :: proc(m: [][]Tuple3, w: int, h: int) -> Tuple3 {
    return m[w][h]
}

destroy_canvas :: proc(c: [][]Color) {
    for i in 0..<len(c) {
        delete(c[i])
    }
    delete(c)
}

write_pixel :: proc(c: [][]Color, x: int, y: int, color: Color) {
    c[x][y] = color
}
