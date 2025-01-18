package tests

import "core:testing"
import main ".."

@(test)
color_is_a_struct :: proc(t: ^testing.T) {
    c := main.color(-0.5, 0.4, 1.7)

    testing.expect_value(t, c.red, -0.5)
    testing.expect_value(t, c.green, 0.4)
    testing.expect_value(t, c.blue, 1.7)
}

