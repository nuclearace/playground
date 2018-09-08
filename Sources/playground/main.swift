import Foundation

let a = unchurch(add(three)(four))
let b = unchurch(mult(three)(four))
let c = unchurch(exp(mult(four)(church(1)))(three))
let d = unchurch(exp(mult(three)(church(1)))(four))

print(a, b, c, d)
