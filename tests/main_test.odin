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


