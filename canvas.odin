package main

import "core:fmt"
import "core:math"
import "core:strings"

Color :: Tuple3 // unfortunately, as a Tuple3 R,G,B will be X,Y,Z...

color :: proc(r, g, b: f32) -> Color {
    return Color{ r, g, b }
}

hadamard:: proc(c1, c2: Color) -> Color {
    // multiply each value
    return Color{ c1.x * c2.x, c1.y * c2.y, c1.z * c2.z }
}

canvas :: proc(width, height: int) -> [][]Color {
    m := make([][]Color, width)
    for w in 0..< width {
        m[w] = make([]Color, height)
        for h in 0..< height {
            m[w][h] = color(0, 0, 0)
        }
    }
    return m
}

get_width :: proc(m: [][]Tuple3) -> int {
    return len(m)
}

get_height :: proc(m: [][]Tuple3) -> int {
    return len(m[0])
}

pixel_at :: proc(m: [][]Tuple3, w: int, h: int) -> Tuple3 {
    return m[w][h]
}

destroy_canvas :: proc(c: [][]Color) {
    for i in 0..<len(c) {
        delete(c[i])
    }
    delete(c)
}

write_pixel :: proc(c: [][]Color, x: int, y: int, color: Color) {
    c[x][y] = color
}

convert_color :: proc(element: f32) -> int {
    if element > 1 {
        return 255
    }
    if element < 0 {
        return 0
    }

    return int(math.round(element * 255))
}

canvas_to_ppm :: proc(c: [][]Color) -> string {
    width := get_width(c)
    height := get_height(c)

    header := fmt.aprintf("P3\n%d %d\n255\n", width, height)
    defer delete(header)

    builder := strings.builder_make()
    defer strings.builder_destroy(&builder)

    for h in 0..<height {
        line_length := 0
        for w in 0..<width {
            color := c[w][h]

            // For each number in the triplet
            numbers := [3]int{
                convert_color(color.x),
                convert_color(color.y),
                convert_color(color.z),
            }

            for i := 0; i < 3; i += 1 {
                // Format the number
                num := fmt.aprintf("%d", numbers[i])
                defer delete(num)
                
                // Add space if not at start of line
                if line_length > 0 {
                    // Check if adding space + number would exceed 70
                    if line_length + 1 + len(num) > 70 {
                        strings.write_byte(&builder, '\n')
                        line_length = 0
                    } else {
                        strings.write_byte(&builder, ' ')
                        line_length += 1
                    }
                }
                
                // Write the number
                strings.write_string(&builder, num)
                line_length += len(num)
            }
        }
        strings.write_byte(&builder, '\n')
    }

    return fmt.aprintf("%s%s", header, strings.to_string(builder))
}

