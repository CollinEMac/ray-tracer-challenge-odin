package tests

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

