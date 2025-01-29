package tests

import "core:fmt"
import "core:testing"
import "core:strings"
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
    defer main.destroy_canvas(c)
    red := main.color(1, 0, 0)

    main.write_pixel(c, 2, 3, red)

    testing.expect_value(t, main.pixel_at(c, 2, 3), red)
}

@(test)
construct_ppm_header :: proc(t: ^testing.T) {
    c := main.canvas(5, 3)
    defer main.destroy_canvas(c)

    ppm := main.canvas_to_ppm(c)
    defer delete(ppm)

    ppm_three_lines := strings.split(ppm, "\n")
    defer delete(ppm_three_lines)

    testing.expect_value(t, ppm_three_lines[0], "P3")
    testing.expect_value(t, ppm_three_lines[1], "5 3")
    testing.expect_value(t, ppm_three_lines[2], "255")
}

@(test)
construct_ppm_pixel_data :: proc(t: ^testing.T) {
    c := main.canvas(5, 3)
    defer main.destroy_canvas(c)

    c1 := main.color(1.5, 0, 0)
    c2 := main.color(0, 0.5, 0)
    c3 := main.color(-0.5, 0, 1)

    main.write_pixel(c, 0, 0, c1)
    main.write_pixel(c, 2, 1, c2)
    main.write_pixel(c, 4, 2, c3)

    ppm := main.canvas_to_ppm(c)
    defer delete(ppm)

    ppm_lines := strings.split(ppm, "\n")
    defer delete(ppm_lines)

    fmt.println(ppm)

    testing.expect_value(
        t,
        ppm_lines[3], 
        "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0"
    )
    testing.expect_value(
        t,
        ppm_lines[4], 
        "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0"
    )
    testing.expect_value(
        t,
        ppm_lines[5], 
        "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255"
    )
}

@(test)
splitting_long_lines_in_ppm_files :: proc(t: ^testing.T) {
    height := 2
    width := 10
    c := main.canvas(width, height)
    defer main.destroy_canvas(c)

    // Make every pixel this color
    for h in 0..<height {
        for w in 0..<width {
            main.write_pixel(c, w, h, main.color(1, 0.8, 0.6))
        }
    }

    ppm := main.canvas_to_ppm(c)
    defer delete(ppm)

    ppm_lines := strings.split(ppm, "\n")
    defer delete(ppm_lines)

    testing.expect_value(
        t,
        ppm_lines[3], 
        "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204"
    )
    testing.expect_value(
        t,
        ppm_lines[4], 
        "153 255 204 153 255 204 153 255 204 153 255 204 153"
    )
    testing.expect_value(
        t,
        ppm_lines[5], 
        "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204"
    )
    testing.expect_value(
        t,
        ppm_lines[6],
        "153 255 204 153 255 204 153 255 204 153 255 204 153"
    )
}

