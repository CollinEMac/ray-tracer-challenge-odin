package tests

import "core:testing"
import main ".."

@(test)
createing_and_querying_a_ray :: proc(t: ^testing.T) {
    origin := main.point(1, 2, 3)
    direction := main.vector(4, 5, 6)

    r := main.ray(origin, direction)

    testing.expect_value(t, r.origin, origin)
    testing.expect_value(t, r.direction, direction)
}



