package tests

import "core:testing"
import main ".."

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
