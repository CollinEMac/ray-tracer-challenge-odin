package tests

import "core:testing"
import "core:math"
import main ".."

approx_equal :: proc(a, b: f32) -> bool {
    return math.abs(a - b) <= math.F32_EPSILON
}

@(test)
tuple_is_a_point :: proc(t: ^testing.T) {
    a := main.Tuple{ 4.3, -4.2, 3.1, 1.0 }
    testing.expect_value(t, a.x, 4.3)
    testing.expect_value(t, a.y, -4.2)
    testing.expect_value(t, a.z, 3.1)
    testing.expect_value(t, a.w, 1.0)
    testing.expect(
        t,
        main.is_point(a),
        "Tuple with w=1.0 is not evaluated as Point!"
    )
    testing.expect_value(
        t,
        main.is_vector(a),
        false
    )
}

@(test)
tuple_is_vector :: proc(t: ^testing.T) {
    a := main.Tuple{ 4.3, -4.2, 3.1, 0.0 }
    testing.expect_value(t, a.x, 4.3)
    testing.expect_value(t, a.y, -4.2)
    testing.expect_value(t, a.z, 3.1)
    testing.expect_value(t, a.w, 0.0)
    testing.expect(
        t,
        main.is_vector(a),
        "Tuple with w=0.0 is not evaluated as Vector!"
    )
    testing.expect_value(
        t,
        main.is_point(a),
        false
    )
}

@(test)
point_proc_creates_point :: proc(t: ^testing.T) {
    p := main.point(4, -4, 3)
    testing.expect_value(
        t,
        p,
        main.Tuple{ 4.0, -4.0, 3.0, 1.0 }
    )
}

@(test)
vector_proc_creates_vector :: proc(t: ^testing.T) {
    p := main.vector(4, -4, 3)
    testing.expect_value(
        t,
        p,
        main.Tuple{ 4.0, -4.0, 3.0, 0.0 }
    )
}

@(test)
equals_proc_validates_equality :: proc(t: ^testing.T) {
    a := main.Tuple{ 4.0, -4.0, 3.0, 1.0 }
    b := main.Tuple{ 4.0, -4.0, 100.0, 1.0 }

    testing.expect_value(t, main.equals(a,b), false)
    testing.expect(t, main.equals(a,main.Tuple{ 4.0, -4.0, 3.0, 1.0 }))
}

@(test)
add_tuples :: proc(t: ^testing.T) {
    a1 := main.Tuple{ 3, -2, 5, 1 }
    a2 := main.Tuple{ -2, 3, 1, 0 }

    testing.expect_value(t, main.add(a1, a2), main.Tuple{ 1, 1, 6, 1 })
}

@(test)
subtract_point :: proc(t: ^testing.T) {
    p1 := main.point(3, 2, 1)
    p2 := main.point(5, 6, 7)

    testing.expect_value(t, main.subtract(p1, p2), main.vector(-2, -4, -6))
}

@(test)
subtract_vector_from_point :: proc(t: ^testing.T) {
    p := main.point(3, 2, 1)
    v := main.vector(5, 6, 7)

    testing.expect_value(t, main.subtract(p, v), main.point(-2, -4, -6))
}

@(test)
subtract_vector :: proc(t: ^testing.T) {
    v1 := main.vector(3, 2, 1)
    v2 := main.vector(5, 6, 7)

    testing.expect_value(t, main.subtract(v1, v2), main.vector(-2, -4, -6))
}

@(test)
subtract_vector_from_zero_vector :: proc(t: ^testing.T) {
    zero := main.vector(0, 0, 0)
    v := main.vector (1, -2, 3)

    testing.expect_value(t, main.subtract(zero, v), main.vector(-1, 2, -3))
}

@(test)
negate_a_vector :: proc(t: ^testing.T) {
    a := main.Tuple{ 1, -2, 3, -4 }
    testing.expect_value(t, main.negate(a), main.Tuple{ -1, 2, -3, 4 })
}

@(test)
multiply_tuple_by_scalar :: proc(t: ^testing.T) {
    a := main.Tuple{ 1, -2, 3, -4 }
    testing.expect_value(t, main.mult(a, 3.5), main.Tuple{ 3.5, -7, 10.5, -14 })
}

@(test)
multiply_tuple_by_fraction :: proc(t: ^testing.T) {
    a := main.Tuple{ 1, -2, 3, -4 }
    testing.expect_value(t, main.mult(a, 0.5), main.Tuple{ 0.5, -1, 1.5, -2 })
}

@(test)
divide_tuple_by_scalar :: proc(t: ^testing.T) {
    a := main.Tuple{ 1, -2, 3, -4 }
    testing.expect_value(t, main.div(a, 2), main.Tuple{ 0.5, -1, 1.5, -2 })
}

@(test)
get_mag_of_vector :: proc(t: ^testing.T) {
    v := main.vector(1, 0, 0)
    testing.expect_value(t, main.mag(v), 1)

    v = main.vector(0, 1, 0)
    testing.expect_value(t, main.mag(v), 1)

    v = main.vector(0, 0, 1)
    testing.expect_value(t, main.mag(v), 1)

    v = main.vector(1, 2, 3)
    testing.expect_value(t, main.mag(v), math.sqrt_f32(14))

    v = main.vector(-1, -2, -3)
    testing.expect_value(t, main.mag(v), math.sqrt_f32(14))
}

@(test)
normalize_vector :: proc(t: ^testing.T) {
    v := main.vector(4, 0, 0)
    testing.expect_value(t, main.norm(v), main.vector(1, 0, 0))

    v = main.vector(1, 2, 3)
    sqrt_14 := math.sqrt_f32(14)
    testing.expect_value(t, main.norm(v), main.vector(1/sqrt_14, 2/sqrt_14, 3/sqrt_14))
}

@(test)
get_mag_of_normalized_vector :: proc(t: ^testing.T) {
    v := main.vector(1, 2, 3)
    norm := main.norm(v)
    testing.expect(t, approx_equal(main.mag(norm), 1))
}

@(test)
get_dot_product :: proc(t: ^testing.T) {
    v1 := main.vector(1, 2, 3)
    v2 := main.vector(2, 3, 4)
    testing.expect_value(t, main.dot(v1, v2), 20)
}

