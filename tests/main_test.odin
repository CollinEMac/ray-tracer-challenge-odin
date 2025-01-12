package tests

import "core:testing"
import main ".."

@(test)
tuple_is_a_point :: proc(t: ^testing.T) {
    a := main.Tuple{ 4.3, -4.2, 3.1, 1.0 }
    testing.expect(t, main.is_point(a))
    testing.expect(t, main.is_point(a))
}
