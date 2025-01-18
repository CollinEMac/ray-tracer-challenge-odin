package tests

import "core:testing"
import main ".."

@(test)
color_is_a_struct :: proc(t: ^testing.T) {
    c := main.color(-0.5, 0.4, 1.7)

    testing.expect_value(t, c.x, -0.5)
    testing.expect_value(t, c.y, 0.4)
    testing.expect_value(t, c.z, 1.7)
}

@(test)
adding_colors :: proc(t:^testing.T) {
    c1 := main.color(0.9, 0.6, 0.75)
    c2 := main.color(0.7, 0.1, 0.25)
    sum := main.add(c1, c2)
    expected := main.color(1.6, 0.7, 1.0)

    testing.expect(t, approx_equal(sum.x, expected.x)) 
    testing.expect(t, approx_equal(sum.y, expected.y)) 
    testing.expect(t, approx_equal(sum.z, expected.z)) 
}

@(test)
subtracting_colors :: proc(t:^testing.T) {
    c1 := main.color(0.9, 0.6, 0.75)
    c2 := main.color(0.7, 0.1, 0.25)
    diff := main.subtract(c1, c2)
    expected := main.color(0.2, 0.5, 0.5)

    testing.expect(t, approx_equal(diff.x, expected.x)) 
    testing.expect(t, approx_equal(diff.y, expected.y)) 
    testing.expect(t, approx_equal(diff.z, expected.z)) 
}

@(test)
multiply_color_by_scalar :: proc(t:^testing.T) {
    c := main.color(0.2, 0.3, 0.4)

    testing.expect_value(t, main.mult(c, 2), main.color(0.4, 0.6, 0.8))
}

