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

