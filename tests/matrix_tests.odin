package tests

import "base:intrinsics"
import "core:fmt"
import "core:testing"
import main ".."

@(test)
construct_a_matrix :: proc(t: ^testing.T) {
    m := matrix[4, 4]f32{
        1, 2, 3, 4,
        5.5, 6.5, 7.5, 8.5,
        9, 10, 11, 12,
        13.5, 14.5, 15.5, 16.5
    }

    testing.expect_value(t, m[0, 0], 1)
    testing.expect_value(t, m[0, 3], 4)
    testing.expect_value(t, m[1, 0], 5.5)
    testing.expect_value(t, m[1, 2], 7.5)
    testing.expect_value(t, m[2, 2], 11)
    testing.expect_value(t, m[3, 0], 13.5)
    testing.expect_value(t, m[3, 2], 15.5)
}

@(test)
matrix_equality :: proc(t: ^testing.T) {
    m1 := matrix[4, 4]f32 {
        1, 2, 3, 4,
        5.5, 6.5, 7.5, 8.5,
        9, 10, 11, 12,
        13.5, 14.5, 15.5, 16.5
    }

    m2 := matrix[4, 4]f32 {
        1, 2, 3, 4,
        5.5, 6.5, 7.5, 8.5,
        9, 10, 11, 12,
        13.5, 14.5, 15.5, 16.5
    }

    testing.expect(t, m1 == m2)
}


@(test)
matrix_inequality :: proc(t: ^testing.T) {
    m1 := matrix[4, 4]f32 {
        1, 2, 3, 4,
        5.5, 6.5, 7.5, 8.5,
        9, 10, 11, 12,
        13.5, 14.5, 15.5, 16.5
    }

    m2 := matrix[4, 4]f32 {
        7, 2, 3, 1,
        5.5, 6.5, 7.5, 2,
        9, 44, 11, 12,
        13.5, 100.3, 15.5, 16.5
    }

    testing.expect(t, m1 != m2)
}

multiplying_two_matrices :: proc(t: ^testing.T) {
    m1 := matrix[4, 4]f32 {
        1, 2, 3, 4,
        5.5, 6.5, 7.5, 8.5,
        9, 10, 11, 12,
        13.5, 14.5, 15.5, 16.5
    }

    m2 := matrix[4, 4]f32 {
        -2, 1, 2, 3,
        3, 2, 1, -1,
        4, 3, 6, 5,
        1, 2, 7, 8
    }

    result := matrix[4, 4]f32 {
        20, 22, 50, 48,
        44, 54, 114, 108,
        40, 58, 110, 102,
        16, 26, 46, 42
    }

    testing.expect_value(t, m1*m2, result)
}

multiply_a_matrix_by_a_tuple :: proc(t: ^testing.T) {
    // TODO: maybe tuples should just be replaced with one dimentional matrices?
    m := matrix[4, 4]f32 {
        1, 2, 3, 4,
        2, 4, 4, 2,
        8, 6, 4, 1,
        0, 0, 0, 1
    }

    b := main.Tuple4 { 1, 2, 3, 1 }

    testing.expect_value(t, main.multiply_matrix_and_tuple4(m, b), main.Tuple4 { 18, 24, 33, 1 })
}

multiply_a_matrix_by_the_identity_matrix ::  proc(t: ^testing.T) {
    m := matrix[4, 4]f32{
        0, 1, 2, 4,
        1, 2, 4, 8,
        2, 4, 8, 16,
        4, 8, 16, 32
    }

    testing.expect_value(t, m * main.IDENTITY_MATRIX, m)
}

transpose_a_matrix :: proc(t: ^testing.T) {
    m := matrix[4,4]f32{
        0, 9, 3, 0,
        9, 8, 0, 8,
        1, 8, 5, 3,
        0, 0, 5, 8
    }

    testing.expect_value(
        t,
        intrinsics.transpose(m),
        matrix[4,4]f32{
            0, 9, 1, 0,
            9, 8, 8, 0,
            3, 0, 5, 5,
            0, 8, 3, 8
        }
    )
}

transpose_the_identity_matrix :: proc(t: ^testing.T) {
    testing.expect_value(
        t,
        intrinsics.transpose(main.IDENTITY_MATRIX),
        main.IDENTITY_MATRIX
    )
}
