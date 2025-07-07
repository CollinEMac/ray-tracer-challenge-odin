package tests

import "core:testing"
import main ".."

@(test)
creating_and_querying_a_ray :: proc(t: ^testing.T) {
    origin := main.point(1, 2, 3)
    direction := main.vector(4, 5, 6)

    r := main.ray(origin, direction)

    testing.expect_value(t, r.origin, origin)
    testing.expect_value(t, r.direction, direction)
}

@(test)
computing_a_point_from_a_distance :: proc(t: ^testing.T) {
    r := main.ray(main.point(2, 3, 4), main.vector(1, 0, 0))

    testing.expect_value(t, main.position(r, 0), main.point(2, 3, 4))
    testing.expect_value(t, main.position(r, 1), main.point(3, 3, 4))
    testing.expect_value(t, main.position(r, -1), main.point(1, 3, 4))
    testing.expect_value(t, main.position(r, 2.5), main.point(4.5, 3, 4))
}

@(test)
a_ray_intersects_a_sphere_at_two_points :: proc(t: ^testing.T) {
    r := main.ray(main.point(0, 0, -5), main.vector(0, 0, 1))
    s := main.sphere()

    xs := main.intersect(s, r)

    testing.expect_value(t, xs.count, 2)
    testing.expect_value(t, xs.values[0], 4.0)
    testing.expect_value(t, xs.values[1], 6.0)
}

@(test)
a_ray_intersects_a_sphere_at_a_tangeant :: proc(t: ^testing.T) {
    r := main.ray(main.point(0, 1, -5), main.vector(0, 0, 1))
    s := main.sphere()

    xs := main.intersect(s, r)

    testing.expect_value(t, xs.count, 2)
    testing.expect_value(t, xs.values[0], 5.0)
    testing.expect_value(t, xs.values[1], 5.0)
}

@(test)
a_ray_misses_a_sphere :: proc(t: ^testing.T) {
    r := main.ray(main.point(0, 2, -5), main.vector(0, 0, 1))
    s := main.sphere()

    xs := main.intersect(s, r)

    testing.expect_value(t, xs.count, 0)
}

@(test)
a_ray_originates_inside_a_sphere :: proc(t: ^testing.T) {
    r := main.ray(main.point(0, 0, 0), main.vector(0, 0, 1))
    s := main.sphere()

    xs := main.intersect(s, r)

    testing.expect_value(t, xs.count, 2)
    testing.expect_value(t, xs.values[0], -1.0)
    testing.expect_value(t, xs.values[1], 1.0)
}

@(test)
a_sphere_is_behind_an_array :: proc(t: ^testing.T) {
    r := main.ray(main.point(0, 0, 5), main.vector(0, 0, 1))
    s := main.sphere()

    xs := main.intersect(s, r)

    testing.expect_value(t, xs.count, 2)
    testing.expect_value(t, xs.values[0], -6.0)
    testing.expect_value(t, xs.values[1], -4.0)
}

