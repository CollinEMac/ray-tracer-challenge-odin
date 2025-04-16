package main
import "core:math"

translation :: proc(x, y, z: f32) -> matrix[4,4]f32 {
    m := IDENTITY_MATRIX_4
    m[0,3] = x
    m[1,3] = y
    m[2,3] = z
    return m 
}

scaling :: proc(x, y, z: f32) -> matrix[4,4]f32 {
    m := IDENTITY_MATRIX_4
    m[0,0] = x
    m[1,1] = y
    m[2,2] = z
    return m 
}

rotation_x_3 :: proc(r: f32) -> matrix[3,3]f32 {
    // r is a rotation in radians
    m := IDENTITY_MATRIX_3
    m[1, 1] = math.cos(r)
    m[2, 1] = -math.sin(r)
    m[1, 2] = math.sin(r)
    m[2, 2] = math.cos(r)
    return m
}

rotation_x_4 :: proc(r: f32) -> matrix[4,4]f32 {
    // r is a rotation in radians
    m := IDENTITY_MATRIX_4
    m[1, 1] = math.cos(r)
    m[1, 2] = -math.sin(r)
    m[2, 1] = math.sin(r)
    m[2, 2] = math.cos(r)
    return m
}
