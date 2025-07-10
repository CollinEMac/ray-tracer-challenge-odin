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
    defer delete(xs)

    testing.expect_value(t, len(xs), 2)
    testing.expect_value(t, xs[0].t, 4.0)
    testing.expect_value(t, xs[1].t, 6.0)
}

@(test)
a_ray_intersects_a_sphere_at_a_tangeant :: proc(t: ^testing.T) {
    r := main.ray(main.point(0, 1, -5), main.vector(0, 0, 1))
    s := main.sphere()

    xs := main.intersect(s, r)
    defer delete(xs)

    testing.expect_value(t, len(xs), 2)
    testing.expect_value(t, xs[0].t, 5.0)
    testing.expect_value(t, xs[1].t, 5.0)
}

@(test)
a_ray_misses_a_sphere :: proc(t: ^testing.T) {
    r := main.ray(main.point(0, 2, -5), main.vector(0, 0, 1))
    s := main.sphere()

    xs := main.intersect(s, r)
    defer delete(xs)

    testing.expect_value(t, len(xs), 0)
}

@(test)
a_ray_originates_inside_a_sphere :: proc(t: ^testing.T) {
    r := main.ray(main.point(0, 0, 0), main.vector(0, 0, 1))
    s := main.sphere()

    xs := main.intersect(s, r)
    defer delete(xs)

    testing.expect_value(t, len(xs), 2)
    testing.expect_value(t, xs[0].t, -1.0)
    testing.expect_value(t, xs[1].t, 1.0)
}

@(test)
a_sphere_is_behind_an_array :: proc(t: ^testing.T) {
    r := main.ray(main.point(0, 0, 5), main.vector(0, 0, 1))
    s := main.sphere()

    xs := main.intersect(s, r)
    defer delete(xs)

    testing.expect_value(t, len(xs), 2)
}

@(test)
an_intersection_encapsulates_t_and_object :: proc(t: ^testing.T) {
    s := main.sphere()
    i := main.intersection(3.5, s)

    testing.expect_value(t, i.t, 3.5)
    testing.expect_value(t, i.object, s)
}

@(test)
aggregating_intersections :: proc(t:^testing.T) {
    s := main.sphere()
    i1 := main.intersection(1, s)
    i2 := main.intersection(2, s)
    xs := main.intersections(i1, i2)
    defer delete(xs)

    testing.expect_value(t, len(xs), 2)
    testing.expect_value(t, xs[0].t, 1)
    testing.expect_value(t, xs[1].t, 2)
}

@(test)
intersect_sets_the_object_on_the_intersection :: proc(t: ^testing.T) {
    r := main.ray(main.point(0, 0, -5), main.vector(0, 0, 1))
    s := main.sphere()
    xs := main.intersect(s, r)
    defer delete(xs)

    testing.expect_value(t, len(xs), 2)
    testing.expect_value(t, xs[0].object, s)
    testing.expect_value(t, xs[1].object, s)
}

@(test)
the_hit_when_no_intersections_are_given :: proc(t: ^testing.T) {
    s := main.sphere()
    xs := main.intersections()
    defer delete(xs)

    testing.expect_value(t, main.hit(xs), nil) 
}

@(test)
the_hit_when_all_intersections_have_positive_t :: proc(t: ^testing.T) {
    s := main.sphere()
    i1 := main.intersection(1, s)
    i2 := main.intersection(2, s)
    xs := main.intersections(i1, i2)
    defer delete(xs)

    testing.expect_value(t, main.hit(xs), i1)
}


@(test)
the_hit_when_some_intersections_have_negative_t :: proc(t: ^testing.T) {
    s := main.sphere()
    i1 := main.intersection(-1, s)
    i2 := main.intersection(1, s)
    xs := main.intersections(i1, i2)
    defer delete(xs)

    testing.expect_value(t, main.hit(xs), i2)
}

@(test)
the_hit_when_all_intersections_have_negative_t :: proc(t: ^testing.T) {
    s := main.sphere()
    i1 := main.intersection(-2, s)
    i2 := main.intersection(-1, s)
    xs := main.intersections(i1, i2)
    defer delete(xs)

    testing.expect_value(t, main.hit(xs), nil)
}

@(test)
the_hit_is_always_the_lowest_nonnegative_intersection :: proc(t: ^testing.T) {
    s := main.sphere()
    i1 := main.intersection(5, s)
    i2 := main.intersection(7, s)
    i3 := main.intersection(-3, s)
    i4 := main.intersection(2, s)
    xs := main.intersections(i1, i2, i3, i4)
    defer delete(xs)

    testing.expect_value(t, main.hit(xs), i4)
}

@(test)
translating_a_ray :: proc(t: ^testing.T) {
    r := main.ray(main.point(1, 2, 3), main.vector(0, 1, 0))
    m := main.translation(3, 4, 5)
    r2 := main.transform(r, m)
    
    testing.expect_value(t, r2.origin, main.point(4, 6, 8))
    testing.expect_value(t, r2.direction, main.vector(0, 1, 0))
}

@(test)
scaling_a_ray :: proc(t: ^testing.T) {
    r := main.ray(main.point(1, 2, 3), main.vector(0, 1, 0))
    m := main.scaling(2, 3, 4)
    r2 := main.transform(r, m)
    
    testing.expect_value(t, r2.origin, main.point(2, 6, 12))
    testing.expect_value(t, r2.direction, main.vector(0, 3, 0))
}

