package tests

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:testing"
import main ".."
import helpers "../helpers"

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

@(test)
multiplying_two_matrices :: proc(t: ^testing.T) {
    m1 := matrix[4, 4]f32 {
        1, 2, 3, 4,
        5, 6, 7, 8,
        9, 8, 7, 6,
        5, 4, 3, 2
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

@(test)
multiply_a_matrix_by_a_tuple :: proc(t: ^testing.T) {
    m := matrix[4, 4]f32 {
        1, 2, 3, 4,
        2, 4, 4, 2,
        8, 6, 4, 1,
        0, 0, 0, 1
    }

    b := main.Tuple4 { 1, 2, 3, 1 }

    testing.expect_value(t, main.multiply_matrix_and_tuple4(m, b), main.Tuple4 { 18, 24, 33, 1 })
}

@(test)
multiply_a_matrix_by_the_identity_matrix ::  proc(t: ^testing.T) {
    m := matrix[4, 4]f32{
        0, 1, 2, 4,
        1, 2, 4, 8,
        2, 4, 8, 16,
        4, 8, 16, 32
    }

    testing.expect_value(t, m * main.IDENTITY_MATRIX_4, m)
}

@(test)
transpose_a_matrix :: proc(t: ^testing.T) {
    m := matrix[4,4]f32{
        0, 9, 3, 0,
        9, 8, 0, 8,
        1, 8, 5, 3,
        0, 0, 5, 8
    }

    testing.expect_value(
        t,
        linalg.transpose(m),
        matrix[4,4]f32{
            0, 9, 1, 0,
            9, 8, 8, 0,
            3, 0, 5, 5,
            0, 8, 3, 8
        }
    )
}

@(test)
transpose_the_identity_matrix :: proc(t: ^testing.T) {
    testing.expect_value(
        t,
        linalg.transpose(main.IDENTITY_MATRIX_4),
        main.IDENTITY_MATRIX_4
    )
}

@(test)
determinant_of_a_matrix :: proc(t: ^testing.T) {
    m := matrix[2,2]f32{
        1, 5,
        -3, 2
    }

    testing.expect_value(t, linalg.determinant(m), 17)
}

@(test)
submatrix_of_a_3x3_matrix_is_a_2x2_matrix :: proc(t: ^testing.T) {
    m := matrix[3, 3]f32{
        1, 5, 0,
        -3, 2, 7,
        0, 6, -2
    }
    
    result := matrix[2, 2]f32{
        -3, 2,
        0, 6
    }

    testing.expect_value(t, main.submatrix_2x2(m, 0, 2), result)
}

@(test)
submatrix_of_a_4x4_matrix_is_a_3x3_matrix :: proc(t: ^testing.T) {
    m := matrix[4, 4]f32{
        -6, 1, 1, 6,
        -8, 5, 8, 6,
        -1, 0, 8, 2,
        -7, 1, -1, 1
    }

    result := matrix[3, 3]f32{
        -6, 1, 6,
        -8, 8, 6,
        -7, -1, 1
    }


    testing.expect_value(t, main.submatrix_3x3(m, 2, 1), result)
}

@(test)
calculate_the_minor_of_a_3x3_matrix :: proc(t: ^testing.T) {
    a := matrix[3, 3]f32{
        3, 5, 0,
        2, -1, -7,
        6, -1, 5
    }

    b := main.submatrix_2x2(a, 1, 0)

    testing.expect_value(t, linalg.determinant(b), 25)
    testing.expect_value(t, linalg.matrix_minor(a, 1, 0), 25)
}

@(test)
calculate_a_cofactor_of_a_3x3_matrix :: proc(t: ^testing.T) {
    a := matrix[3, 3]f32{
        3, 5, 0,
        2, -1, -7,
        6, -1, 5
    }

    testing.expect_value(t, linalg.matrix_minor(a, 0, 0), -12)
    testing.expect_value(t, main.cofactor_3x3(a, 0, 0), -12)
    testing.expect_value(t, linalg.matrix_minor(a, 1, 0), 25)
    testing.expect_value(t, main.cofactor_3x3(a, 1, 0), -25)
}

@(test)
calculate_the_determinant_of_a_3x3_matrix :: proc(t: ^testing.T) {
    a := matrix[3, 3]f32{
        1, 2, 6,
        -5, 8, -4,
        2, 6, 4
    }

    testing.expect_value(t, main.cofactor_3x3(a, 0, 0), 56)
    testing.expect_value(t, main.cofactor_3x3(a, 0, 1), 12)
    testing.expect_value(t, main.cofactor_3x3(a, 0, 2), -46)
    testing.expect_value(t, linalg.determinant(a), -196)
}

@(test)
calculate_the_determinant_of_a_4x4_matrix :: proc(t: ^testing.T) {
    a := matrix[4, 4]f32{
        -2, -8, 3, 5,
        -3, 1, 7, 3,
        1, 2, -9, 6,
        -6, 7, 7, -9
    }

    testing.expect_value(t, main.cofactor_4x4(a, 0, 0), 690)
    testing.expect_value(t, main.cofactor_4x4(a, 0, 1), 447)
    testing.expect_value(t, main.cofactor_4x4(a, 0, 2), 210)
    testing.expect_value(t, main.cofactor_4x4(a, 0, 3), 51)
    testing.expect_value(t, linalg.determinant(a), -4071)
}

@(test)
calculate_the_inverse_of_a_matrix :: proc(t: ^testing.T) {
    a := matrix[4, 4]f32{
        -5, 2, 6, -8,
        1, -5, 1, 8,
        7, 7, -6, -7,
        1, -3, 7, 4
    }
    b := linalg.inverse(a)

    testing.expect(t, helpers.approx_equal(linalg.determinant(a), 532))
    testing.expect(t, helpers.approx_equal(main.cofactor_4x4(a, 2, 3), -160))
    testing.expect(t, helpers.approx_equal(b[3,2], -160.0/532.0))
    testing.expect(t, helpers.approx_equal(main.cofactor_4x4(a, 3, 2), 105))
    testing.expect(t, helpers.approx_equal(b[2,3], 105.0/532.0))
}

@(test)
multiply_a_product_by_its_inverse :: proc(t: ^testing.T) {
    a := matrix[4, 4]f32{
        3, -9, 7, 3,
        3, -8, 2, -9,
        -4, 4, 4, 1,
        -6, 5, -1, 1
    }

    b := matrix[4, 4]f32{
        8, 2, 2, 2,
        3, -1, 7, 0,
        7, 0, 5, 4,
        6, -2, 0, 5
    }

    c := a * b

    testing.expect(t, helpers.matrix_approx_equal(c * linalg.inverse(b), a))
}

@(test)
multiply_by_a_translation_matrix :: proc(t: ^testing.T) {
    transform := main.translation(5, -3, 2)
    p := main.point(-3, 4, 5)

    testing.expect_value(t, main.multiply_matrix_and_tuple4(transform, p), main.point(2,1,7))
}

@(test)
mutiply_by_the_inverse_of_a_translation_matrix :: proc(t: ^testing.T) {
    transform := main.translation(5, -3, 2)
    inv := linalg.inverse(transform)
    p := main.point(-3, 4, 5)

    testing.expect_value(t, main.multiply_matrix_and_tuple4(inv, p), main.point(-8,7,3))
}

@(test)
translation_does_not_affect_vectors :: proc(t: ^testing.T) {
    transform := main.translation(5, -3, 2)
    v := main.vector(-3, 4, 5)

    testing.expect_value(t, main.multiply_matrix_and_tuple4(transform, v), v)
}

@(test)
scaling_matrix_applied_to_a_point :: proc(t: ^testing.T) {
    transform := main.scaling(2, 3, 4)
    p := main.point(-4, 6, 8)

    testing.expect_value(t, main.multiply_matrix_and_tuple4(transform, p), main.point(-8, 18, 32))
}

@(test)
scaling_matrix_applied_to_a_vector :: proc(t: ^testing.T) {
    transform := main.scaling(2, 3, 4)
    v := main.vector(-4, 6, 8)

    testing.expect_value(t, main.multiply_matrix_and_tuple4(transform, v), main.vector(-8, 18, 32))
}

@(test)
multiply_by_the_inverse_of_a_scaling_matrix :: proc(t: ^testing.T) {
    transform := main.scaling(2, 3, 4)
    inv := linalg.inverse(transform)
    v := main.vector(-4, 6, 8)

    testing.expect_value(t, main.multiply_matrix_and_tuple4(inv, v), main.vector(-2, 2, 2))
   
}

@(test)
reflection_is_scaling_by_a_negative_value :: proc(t: ^testing.T) {
    transform := main.scaling(-1, 1, 1)
    p := main.point(2, 3, 4)

    testing.expect_value(t, main.multiply_matrix_and_tuple4(transform, p), main.point(-2, 3, 4))
}

@(test)
rotating_a_point_around_the_x_axis :: proc(t: ^testing.T) {
    p := main.point(0, 1, 0)
    half_quarter := main.rotation_x(math.PI/4)
    full_quarter := main.rotation_x(math.PI/2)

    testing.expect_value(
        t,
        main.multiply_matrix_and_tuple4(half_quarter, p),
        main.point(0, math.sqrt_f32(2)/2, math.sqrt_f32(2)/2)
    )

    testing.expect(
        t,
        helpers.deeply_approx_equal_4(
            main.multiply_matrix_and_tuple4(half_quarter, p),
            main.point(0, math.sqrt_f32(2)/2, math.sqrt_f32(2)/2)
        )
    )
}

@(test)
inverse_of_an_x_rotation_rotates_in_opposite_direction :: proc(t: ^testing.T) {
    p := main.point(0, 1, 0)
    half_quarter := main.rotation_x(math.PI/4)
    inv := linalg.inverse(half_quarter)

    testing.expect(
        t,
        helpers.deeply_approx_equal_4(
            main.multiply_matrix_and_tuple4(inv, p),
            main.point(0, math.sqrt_f32(2)/2, -math.sqrt_f32(2)/2)
        )
    )
}

@(test)
rotating_a_point_around_the_y_axis :: proc(t: ^testing.T) {
    p := main.point(0, 0, 1)
    half_quarter := main.rotation_y(math.PI/4)
    full_quarter := main.rotation_y(math.PI/2)

    testing.expect_value(
        t,
        main.multiply_matrix_and_tuple4(half_quarter, p),
        main.point(math.sqrt_f32(2)/2, 0, math.sqrt_f32(2)/2)
    )

    testing.expect(
        t,
        helpers.deeply_approx_equal_4(
            main.multiply_matrix_and_tuple4(full_quarter, p),
            main.point(1, 0, 0)
        )
    )
}

@(test)
rotating_a_point_around_the_z_axis :: proc(t: ^testing.T) {
    p := main.point(0, 1, 0)
    half_quarter := main.rotation_z(math.PI/4)
    full_quarter := main.rotation_z(math.PI/2)

    testing.expect_value(
        t,
        main.multiply_matrix_and_tuple4(half_quarter, p),
        main.point(-math.sqrt_f32(2)/2, math.sqrt_f32(2)/2, 0)
    )

    testing.expect(
        t,
        helpers.deeply_approx_equal_4(
            main.multiply_matrix_and_tuple4(full_quarter, p),
            main.point(-1, 0, 0)
        )
    )
}

