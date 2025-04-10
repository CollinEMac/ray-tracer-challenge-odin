package main

import "core:fmt"
import "core:math"
import "core:math/linalg"

main :: proc() {
    // using this as sort of a playground for now
    p := Projectile { point(0, 1, 0), mult4(norm(vector(1, 1.8, 0)), 11.25) }
    e := Environment { vector(0, -0.1, 0), vector(-0.01, 0, 0) }
    w := 900
    h := 500
    c := canvas(w, h)
    defer destroy_canvas(c)
    red := color(1, 0, 0)

    i := 0
    for i < 197 {
        p = tick(e, p)
        fmt.printf("X Position: %f ", p.position.x)
        fmt.printf("Y Position: %f ", p.position.y)
        x := int(p.position.x)
        y := int(p.position.y)
        if (x <= w && y <= h) {
            write_pixel(c, x, h - y, red)
        }
        i += 1
    }

    ppm := canvas_to_ppm(c)
    save_ppm(ppm, "output.ppm")
}

IDENTITY_MATRIX := matrix[4,4]f32{
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
}

Tuple3 :: struct {
    x, y, z: f32,
}

Tuple4 :: struct {
    x, y, z, w: f32,
}

Point :: Tuple4
Vector :: Tuple4

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

equals :: proc(tuple1, tuple2: $T) -> bool {
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

multiply_matrix_and_tuple3 :: proc(a: matrix[3,3]f32, b: Tuple3) -> Tuple3{
    // convert the tuple to a matrix
    b_matrix := matrix[3, 1]f32{
        b.x, b.y, b.z
    }

    product := a * b_matrix

    return Tuple3 { product[0,0], product[1,0], product[2,0] }
}

multiply_matrix_and_tuple4 :: proc(a: matrix[4,4]f32, b: Tuple4) -> Tuple4{
    // convert the tuple to a matrix
    b_matrix := matrix[4, 1]f32{
        b.x, b.y, b.z, b.w
    }

    product := a * b_matrix

    return Tuple4 { product[0,0], product[1,0], product[2,0], product[3,0] }
}

submatrix_2x2 :: proc(src: $M/matrix[$R, $C]$E, row_start, col_start: int) -> matrix[2, 2]E {
    assert(row_start >= 0 && row_start + 2 <= R, "Row range out of bounds")
    assert(col_start >= 0 && col_start + 2 <= C, "Column range out of bounds")
    
    result: matrix[2, 2]E
    
    for r in 0..<2 {
        for c in 0..<2 {
            result[r, c] = src[row_start + r, col_start + c]
        }
    }
    
    return result
}

submatrix_3x3 :: proc(src: $M/matrix[$R, $C]$E, row_start, col_start: int) -> matrix[3, 3]E {
    assert(row_start >= 0 && row_start + 3 <= R, "Row range out of bounds")
    assert(col_start >= 0 && col_start + 3 <= C, "Column range out of bounds")
    
    result: matrix[3, 3]E
    
    for r in 0..<3 {
        for c in 0..<3 {
            result[r, c] = src[row_start + r, col_start + c]
        }
    }
    
    return result
}

cofactor_3x3 :: proc(a: matrix[3, 3]f32, row, column: int) -> f32 {
    // returns the minor if even, negative minor if odd
    minor := linalg.matrix_minor(a, row, column)
    if (row + column % 2 == 0) {
        return minor
    } else {
        return -minor
    }
}

