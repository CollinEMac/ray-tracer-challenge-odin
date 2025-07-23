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

@(test)
a_point_light_has_a_position_and_intensity :: proc(t: ^testing.T) {
    intensity := main.material(main.color(0, 1, 1))
    position := main.point(0, 0, 0)
    light := main.point_light(position, intensity)

    testing.expect(t, helpers.deeply_approx_equal_4(light.position, position))
    testing.expect(t, helpers.deeply_approx_equal(light.intensity.color, intensity.color))
    testing.expect_value(t, light.intensity.ambient, intensity.ambient)
    testing.expect_value(t, light.intensity.diffuse, intensity.diffuse)
    testing.expect_value(t, light.intensity.specular, intensity.specular)
    testing.expect_value(t, light.intensity.shininess, intensity.shininess)
}

@(test)
the_default_material :: proc(t: ^testing.T) {
    m := main.material()

    testing.expect_value(t, m.color, main.color(1, 1, 1))
    testing.expect_value(t, m.ambient, 0.1)
    testing.expect_value(t, m.diffuse, 0.9)
    testing.expect_value(t, m.specular, 0.9)
    testing.expect_value(t, m.shininess, 200.0)
}

@(test)
a_sphere_has_a_deafult_material :: proc(t: ^testing.T) {
    s := main.sphere()
    m := s.material

    testing.expect_value(t, m, main.material())
}

@(test)
a_sphere_may_be_assigned_a_material :: proc(t: ^testing.T) {
    s := main.sphere()
    m := main.material()
    m.ambient = 1
    s.material = m

    testing.expect_value(t, m, s.material)
    testing.expect_value(t, m, s.material)
}

