import Foundation

let b = Brownian(height: 1400, width: 900, numberOfParticles: 20_000)

print("Starting to tree")

b.tree(preview: true)
