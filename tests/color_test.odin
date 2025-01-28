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

    testing.expect(t,
        deeply_approx_equal(main.add(c1, c2), main.color(1.6, 0.7, 1.0))
    )
}

@(test)
subtracting_colors :: proc(t:^testing.T) {
    c1 := main.color(0.9, 0.6, 0.75)
    c2 := main.color(0.7, 0.1, 0.25)

    testing.expect(t,
        deeply_approx_equal(main.subtract(c1, c2), main.color(0.2, 0.5, 0.5))
    )

}

@(test)
multiply_color_by_scalar :: proc(t:^testing.T) {
    c := main.color(0.2, 0.3, 0.4)

    testing.expect_value(t, main.mult(c, 2), main.color(0.4, 0.6, 0.8))
}

@(test)
multiply_colors :: proc(t:^testing.T) {
    c1 := main.color(1, 0.2, 0.4)
    c2 := main.color(0.9, 1, 0.1)

    testing.expect(t, deeply_approx_equal(main.hadamard(c1, c2), main.color(0.9, 0.2, 0.04)))
}

@(test)
create_a_canvas :: proc(t:^testing.T) {
    c := main.canvas(10, 20)
    // cleanup
    defer main.destroy_canvas(c)

    black := main.color(0, 0, 0)
    width := main.get_width(c)
    height := main.get_height(c)

    testing.expect_value(t, width, 10)
    testing.expect_value(t, height, 20)
    for i in 0..< width {
        for j in 0..< height {
            testing.expect_value(t, main.pixel_at(c, i, j), black)
        }
    }
}

@(test)
writing_pixel_to_canvas :: proc(t:^testing.T) {
    c := main.canvas(10, 20)
    red := main.color(1, 0, 0)

    main.write_pixel(c, 2, 3, red)

    testing.expect_value(t, main.pixel_at(c, 2, 3), red)
}

