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

rotation_x :: proc(r: f32) -> matrix[4,4]f32 {
    // r is a rotation in radians
    m := IDENTITY_MATRIX_4
    m[1, 1] = math.cos(r)
    m[1, 2] = -math.sin(r)
    m[2, 1] = math.sin(r)
    m[2, 2] = math.cos(r)
    return m
}

rotation_y :: proc(r: f32) -> matrix[4,4]f32 {
    // r is a rotation in radians
    m := IDENTITY_MATRIX_4
    m[0, 0] = math.cos(r)
    m[0, 2] = math.sin(r)
    m[2, 0] = -math.sin(r)
    m[2, 2] = math.cos(r)
    return m
}

rotation_z :: proc(r: f32) -> matrix[4,4]f32 {
    // r is a rotation in radians
    m := IDENTITY_MATRIX_4
    m[0, 0] = math.cos(r)
    m[0, 1] = -math.sin(r)
    m[1, 0] = math.sin(r)
    m[1, 1] = math.cos(r)
    return m
}

shearing :: proc(xy, xz, yx, yz, zx, zy: f32) -> matrix[4,4]f32 {
    m := IDENTITY_MATRIX_4
    m[0, 1] = xy
    m[0, 2] = xz
    m[1, 0] = yx
    m[1, 2] = yz
    m[2, 0] = zx
    m[2, 1] = zy
    return m
}

