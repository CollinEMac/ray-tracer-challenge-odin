package helpers
import "core:math"
import main ".."

EPSILON : f32 = 0.0001

approx_equal :: proc(a, b: f32) -> bool {
    // For values near zero
    if math.abs(a) < EPSILON && math.abs(b) < EPSILON {
        return true
    }
    
    // For regular comparisons, use relative difference
    relative_diff := math.abs(a - b) / math.max(math.abs(a), math.abs(b))
    return relative_diff < EPSILON
}

deeply_approx_equal :: proc (a, b: main.Tuple3) -> bool {
    if approx_equal(a.x, b.x) &&
        approx_equal(a.y, b.y) &&
        approx_equal(a.z, b.z) {
        return true
    }
    return false
}

deeply_approx_equal_4 :: proc (a, b: main.Tuple4) -> bool {
    if approx_equal(a.x, b.x) &&
        approx_equal(a.y, b.y) &&
        approx_equal(a.z, b.z) &&
        approx_equal(a.w, a.w) {
        return true
    }
    return false
}

// Helper function for matrix comparison with epsilon
matrix_approx_equal :: proc(a, b: matrix[$R, $C]$E) -> bool {
    for r in 0..<R {
        for c in 0..<C {
            diff := a[r, c] - b[r, c]
            if abs(diff) > EPSILON{
                return false
            }
        }
    }
    return true
}

