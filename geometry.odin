package main

import "core:math"
import "core:math/linalg"

Ray :: struct {
    origin, direction: Tuple4
}

Sphere :: struct {
    transform: matrix[4, 4]f32,
    material: Material
}

Object :: union {
  Sphere,
}

Intersection :: struct {
  t: f32,
  object: Object 
}

ray :: proc(origin, direction: Tuple4) -> Ray {
    return Ray{ origin, direction }
}

sphere :: proc{sphere_full, sphere_default}

sphere_default :: proc(t: matrix[4,4]f32 = IDENTITY_MATRIX_4) -> Sphere {
    return Sphere{t, material()}
}

sphere_full :: proc(t: matrix[4,4]f32 = IDENTITY_MATRIX_4, m: Material) -> Sphere {
    return Sphere{t, m}
}

set_transform :: proc(s: ^Sphere, t: matrix[4,4]f32 = IDENTITY_MATRIX_4) {
    s.transform = t
}

intersection :: proc(t: f32, object: Object) -> Intersection {
    return Intersection{t, object}
}

position :: proc(r: Ray, t: f32) -> Point {
    return add4(r.origin, mult4(r.direction, t))
}

intersect :: proc(s: Sphere, r: Ray) -> []Intersection {
    new_r := transform(r, linalg.inverse(s.transform))

    sphere_to_ray := subtract4(new_r.origin, point(0, 0, 0))

    a := dot(new_r.direction, new_r.direction)
    b := 2 * dot(new_r.direction, sphere_to_ray)
    c := dot(sphere_to_ray, sphere_to_ray) - 1

    discriminant := math.pow(b, 2) - 4 * a * c

    if (discriminant < 0) {
      return []Intersection{}
    }

    t1 := (-b - math.sqrt(discriminant))/(2 * a)
    t2 := (-b + math.sqrt(discriminant))/(2 * a)

    return intersections(intersection(t1, Object(s)), intersection(t2, Object(s))) 
}

intersections :: proc(is: ..Intersection) -> []Intersection {
    result := make([]Intersection, len(is))
    copy(result, is)
    return result
}

hit :: proc(intersections: []Intersection) -> Maybe(Intersection) {
    if len(intersections) == 0 {
        return nil
    }

    lowest := intersections[0]
    for i in intersections[1:] {
        if i.t < 0 {
          continue
        }
        if i.t < lowest.t || lowest.t <= 0 {
            lowest = i
        }
    }

    if lowest.t <= 0 {
        return nil
    }

    return lowest
}

transform :: proc(r: Ray, m: matrix[4,4]f32) -> Ray {
    return ray(
        multiply_matrix_and_tuple4(m, r.origin),
        multiply_matrix_and_tuple4(m, r.direction)
    )
}

normal_at :: proc(s: Sphere, world_point: Point) -> Vector {
    object_point := multiply_matrix_and_tuple4(linalg.inverse(s.transform), world_point)
    object_normal := subtract(object_point, point(0, 0, 0))
    world_normal := multiply_matrix_and_tuple4(linalg.transpose(linalg.inverse(s.transform)), object_normal)
    world_normal.w = 0
    return norm(world_normal)
}
