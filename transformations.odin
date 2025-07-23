package main
import "core:math"
import "core:math/linalg"

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
    minor := linalg.matrix_minor(a, row, column)
    if (row + column % 2 == 0) {
        return minor
    } else {
        return -minor
    }
}

cofactor_4x4 :: proc(a: matrix[4, 4]f32, row, column: int) -> f32 {
    minor := linalg.matrix_minor(a, row, column)
    if ((row + column) % 2 == 0) {
        return minor
    } else {
        return -minor
    }
}

