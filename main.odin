package main

import "core:fmt"
import "core:math"

main :: proc() {
    // using this as sort of a playground for now

    // End of Chapter 5
    ray_origin := point(0, 0, -5)
    wall_z: f32 = 0
    wall_size := 7

    canvas_pixels := 100
    pixel_size := f32(wall_size) / f32(canvas_pixels)

    half := wall_size / 2 

    canvas := canvas(canvas_pixels, canvas_pixels)
    color := color(1, 0, 0)
    shape := sphere()

    // transform the sphere
    // shirnk along y axis
    // set_transform(&shape, scaling(1, 0.5, 1))
    // shrink along the x axis
    // set_transform(&shape, scaling(0.5, 1, 1))
    // shrink adn rotate
    // set_transform(&shape, rotation_z(math.PI/4) * scaling(0.5, 1, 1))
    // shrink and skew it
    // set_transform(&shape, shearing(1, 0, 0, 0, 0, 0) * scaling(0.5, 1, 1))
    // translate
    // set_transform(&shape, translation(1, 1, 1))
    // set_transform(&shape, scaling(4, 4, 4))

    for y: f32 = 0; y < f32(canvas_pixels); y += 1 {
        world_y := f32(half) - f32(pixel_size) * y 
        for x: f32 = 0; x < f32(canvas_pixels); x += 1 {

            world_x := f32(-half) + f32(pixel_size) * x

            position := point(world_x, world_y, wall_z)

            r := ray(ray_origin, norm(subtract(position, ray_origin)))
            xs := intersect(shape, r)

            if (hit(xs) != nil) {
                write_pixel(canvas, int(x), int(y), color)
            } 
        }
    }

    ppm := canvas_to_ppm(canvas)
    save_ppm(ppm, "output.ppm")


    // End of Chapter 4
    // w := 900
    // half_w := f32(w/2)
    // c := canvas(w, w)
    // defer destroy_canvas(c)
    // color := color(1, 0, 1)
    //
    // // make radius 3/8 the canvas width
    // radius := f32(w) * 3 / 8
    //
    // for hour := 0; hour < 12; hour += 1 {
    //     point := point(0, -1, 0)
    //
    //     // rotate
    //     point = multiply_matrix_and_tuple4(
    //         rotation_z(f32(hour) * math.PI/6),
    //         point
    //     )
    //
    //     // scale
    //     point = multiply_matrix_and_tuple4(
    //         scaling(radius, radius, 0),
    //         point
    //     )
    //
    //     // translate
    //     point = multiply_matrix_and_tuple4(
    //         translation(half_w, half_w, 0),
    //         point
    //     )
    //
    //     write_pixel(c, int(point.x), int(point.y), color)
    // }
    //
    // ppm := canvas_to_ppm(c)
    // save_ppm(ppm, "output.ppm")

    ///////// Project firing (End of chapter 2)
    // p := Projectile { point(0, 1, 0), mult4(norm(vector(1, 1.8, 0)), 11.25) }
    // e := Environment { vector(0, -0.1, 0), vector(-0.01, 0, 0) }
    // w := 900
    // h := 500
    // c := canvas(w, h)
    // defer destroy_canvas(c)
    // red := color(1, 0, 0)
    //
    // i := 0
    // for i < 197 {
    //     p = tick(e, p)
    //     fmt.printf("X Position: %f ", p.position.x)
    //     fmt.printf("Y Position: %f ", p.position.y)
    //     x := int(p.position.x)
    //     y := int(p.position.y)
    //     if (x <= w && y <= h) {
    //         write_pixel(c, x, h - y, red)
    //     }
    //     i += 1
    // }
    //
    // ppm := canvas_to_ppm(c)
    // save_ppm(ppm, "output.ppm")
}
