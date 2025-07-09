package main

import "core:fmt"
import "core:math"
import "core:math/linalg"

main :: proc() {
    // using this as sort of a playground for now

    // End of Chapter 4
    w := 900
    half_w := f32(w/2)
    c := canvas(w, w)
    defer destroy_canvas(c)
    color := color(1, 0, 1)

    // make radius 3/8 the canvas width
    radius := f32(w) * 3 / 8

    for hour := 0; hour < 12; hour += 1 {
        point := point(0, -1, 0)

        // rotate
        point = multiply_matrix_and_tuple4(
            rotation_z(f32(hour) * math.PI/6),
            point
        )

        // scale
        point = multiply_matrix_and_tuple4(
            scaling(radius, radius, 0),
            point
        )

        // translate
        point = multiply_matrix_and_tuple4(
            translation(half_w, half_w, 0),
            point
        )

        write_pixel(c, int(point.x), int(point.y), color)
    }

    ppm := canvas_to_ppm(c)
    save_ppm(ppm, "output.ppm")

    ///////// Project firing (End of chapter 2)
    // p := Projectile { point(0, 1, 0), mult4(norm(vector(1, 1.8, 0)), 11.25) }
    // e := Environment { vector(0, -0.1, 0), vector(-0.01, 0, 0) }
    // w := 900
    // h := 500
    // c := canvas(w, h)
    // defer destroy_canvas(c)
    // red := color(1, 0, 0)
    //
    // i := 0
    // for i < 197 {
    //     p = tick(e, p)
    //     fmt.printf("X Position: %f ", p.position.x)
    //     fmt.printf("Y Position: %f ", p.position.y)
    //     x := int(p.position.x)
    //     y := int(p.position.y)
    //     if (x <= w && y <= h) {
    //         write_pixel(c, x, h - y, red)
    //     }
    //     i += 1
    // }
    //
    // ppm := canvas_to_ppm(c)
    // save_ppm(ppm, "output.ppm")
}

IDENTITY_MATRIX_3 := matrix[3, 3]f32{
    1, 0, 0,
    0, 1, 0,
    0, 0, 1,
}

IDENTITY_MATRIX_4 := matrix[4,4]f32{
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

Ray :: struct {
    origin, direction: Tuple4
}

Sphere :: struct {}

Object :: union {
  Sphere,
}

Intersection :: struct {
  t: f32,
  object: Object 
}

Intersections :: struct {
    count: int,
    values: [2]f32
}

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

ray :: proc(origin, direction: Tuple4) -> Ray {
    return Ray{ origin, direction }
}

sphere :: proc() -> Sphere {
    return Sphere{}
}

intersection :: proc(t: f32, object: Object) -> Intersection {
    return Intersection{t, object}
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

submatrix_2x2 :: proc(src: matrix[3, 3]$E, row_to_remove, col_to_remove: int) -> matrix[2, 2]E {
    assert(row_to_remove >= 0 && row_to_remove < 3, "Row index out of bounds")
    assert(col_to_remove >= 0 && col_to_remove < 3, "Column index out of bounds")
    
    result: matrix[2, 2]E
    
    dest_row := 0
    for src_row in 0..<3 {
        if src_row == row_to_remove do continue
        
        dest_col := 0
        for src_col in 0..<3 {
            if src_col == col_to_remove do continue
            
            result[dest_row, dest_col] = src[src_row, src_col]
            dest_col += 1
        }
        dest_row += 1
    }
return result
}

submatrix_3x3 :: proc(src: matrix[4, 4]$E, row_to_remove, col_to_remove: int) -> matrix[3, 3]E {
    assert(row_to_remove >= 0 && row_to_remove < 4, "Row index out of bounds")
    assert(col_to_remove >= 0 && col_to_remove < 4, "Column index out of bounds")
    
    result: matrix[3, 3]E
    
    dest_row := 0
    for src_row in 0..<4 {
        if src_row == row_to_remove do continue
        
        dest_col := 0
        for src_col in 0..<4 {
            if src_col == col_to_remove do continue
            
            result[dest_row, dest_col] = src[src_row, src_col]
            dest_col += 1
        }
        dest_row += 1
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

cofactor_4x4 :: proc(a: matrix[4, 4]f32, row, column: int) -> f32 {
    // returns the minor if even, negative minor if odd
    minor := linalg.matrix_minor(a, row, column)
    if ((row + column) % 2 == 0) {
        return minor
    } else {
        return -minor
    }
}

position :: proc(r: Ray, t: f32) -> Point {
    return add4(r.origin, mult4(r.direction, t))
}

intersect :: proc(s: Sphere, r: Ray) -> []Intersection {
    // The vector from the sphere's center (centered at origin)
    sphere_to_ray := subtract4(r.origin, point(0, 0, 0))

    a := dot(r.direction, r.direction)
    b := 2 * dot(r.direction, sphere_to_ray)
    c := dot(sphere_to_ray, sphere_to_ray) - 1

    discriminant := math.pow(b, 2) - 4 * a * c

    if (discriminant < 0) {
      return []Intersection{}
    }

    t1 := (-b - math.sqrt(discriminant))/(2 * a)
    t2 := (-b + math.sqrt(discriminant))/(2 * a)

    return intersections(intersection(t1, Object(s)), intersection(t2, Object(s))) 
}

intersections :: proc(is: ..Intersection) -> []Intersection {
    result := make([]Intersection, len(is))
    copy(result, is)
    return result
}

