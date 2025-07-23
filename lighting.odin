package main

Material :: struct {
    color: Color,
    ambient: f32,
    diffuse: f32,
    specular: f32,
    shininess: f32
}

Light :: struct {
    position: Point,
    intensity: Material 
}

reflect :: proc(inc, normal: Vector) -> Vector {
    return subtract(inc, mult(normal, 2 * dot(inc, normal)))
}

point_light :: proc(position: Point, intensity: Material) -> Light {
    return Light{position, intensity}
}

material :: proc{material_full, material_color_only, material_default}

material_default :: proc() -> Material {
    return Material{color(1, 1, 1), 0.1, 0.9, 0.9, 200.0}
}

material_color_only :: proc(color: Color) -> Material {
    return Material{color, 0.1, 0.9, 0.9, 200.0}
}

material_full :: proc(color: Color, ambient, diffuse, specular, shininess: f32) -> Material {
    assert(ambient >= 0.0, "Ambient must be positive")
    assert(diffuse >= 0.0, "Diffuse must be positive")
    assert(specular >= 0.0, "Specular must be positive")
    assert(shininess >= 0.0, "Shininess must be positive")

    return Material{color, ambient, diffuse, specular, shininess}
}

