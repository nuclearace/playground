import Foundation

let b = Brownian(height: 900, width: 1440, numberOfParticles: 20_000)

print("Starting to tree")

b.tree(preview: true)
