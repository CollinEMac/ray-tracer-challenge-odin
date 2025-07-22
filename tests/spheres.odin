package tests

import "core:math"
import "core:testing"
import main ".."
import helpers "../helpers"

@(test)
the_normal_on_a_sphere_at_a_point_on_the_x_axis :: proc(t: ^testing.T) {
    s := main.sphere()
    n := main.normal_at(s, main.point(1, 0, 0))

    testing.expect_value(t, n, main.vector(1, 0, 0))
}

@(test)
the_normal_on_a_sphere_at_a_point_on_the_y_axis :: proc(t: ^testing.T) {
    s := main.sphere()
    n := main.normal_at(s, main.point(0, 1, 0))

    testing.expect_value(t, n, main.vector(0, 1, 0))
}

@(test)
the_normal_on_a_sphere_at_a_point_on_the_z_axis :: proc(t: ^testing.T) {
    s := main.sphere()
    n := main.normal_at(s, main.point(0, 0, 1))

    testing.expect_value(t, n, main.vector(0, 0, 1))
}

@(test)
the_normal_on_a_sphere_at_a_nonaxial_point :: proc(t: ^testing.T) {
    s := main.sphere()
    val := math.sqrt_f32(3.0)/3
    n := main.normal_at(s, main.point(val, val, val))
    expected := main.vector(val, val, val)

    testing.expect(t, helpers.deeply_approx_equal_4(n, expected))
}

@(test)
the_normal_is_a_normalized_vector :: proc(t: ^testing.T) {
    s := main.sphere()
    val := math.sqrt_f32(3.0)/3
    n := main.normal_at(s, main.point(val, val, val))

    testing.expect(t, helpers.deeply_approx_equal_4(n, main.norm(n)))
}

@(test)
computing_the_normal_on_a_translated_sphere :: proc(t: ^testing.T) {
    s := main.sphere()
    main.set_transform(&s, main.translation(0, 1, 0))
    n := main.normal_at(s, main.point(0, 1.70711, -0.70711))

    testing.expect(t, helpers.deeply_approx_equal_4(n, main.vector(0, 0.70711, -0.70711)))
}

@(test)
computing_the_normal_on_a_transformed_sphere :: proc(t: ^testing.T) {
    s := main.sphere()
    m := main.scaling(1, 0.5, 1) * main.rotation_z(math.PI/5)
    main.set_transform(&s, m)
    n := main.normal_at(s, main.point(0, math.sqrt_f32(2)/2, -math.sqrt_f32(2)/2))

    testing.expect(t, helpers.deeply_approx_equal_4(n, main.vector(0, 0.97014, -0.24254)))
}

@(test)
reflecting_a_vector_approaching_at_45 :: proc(t: ^testing.T) {
    v := main.vector(1, -1, 0)
    n := main.vector(0, 1, 0)
    r := main.reflect(v, n)

    testing.expect(t, helpers.deeply_approx_equal_4(r, main.vector(1, 1, 0)))
}

@(test)
reflecting_a_vector_off_a_slanted_surface :: proc(t: ^testing.T) {
    v := main.vector(0, -1, 0)
    n := main.vector(math.sqrt_f32(2)/2, math.sqrt_f32(2)/2, 0)
    r := main.reflect(v, n)

    testing.expect(t, helpers.deeply_approx_equal_4(r, main.vector(1, 0, 0)))
}

