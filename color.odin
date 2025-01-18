package main

Color :: struct {
    red, green, blue: f32
}

color :: proc(r, g, b: f32) -> Color {
    return Color{ r, g, b }
}


