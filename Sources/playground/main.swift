import BigInt

let usCoins = [100, 50, 25, 10, 5, 1]
let euCoins = [200, 100, 50, 20, 10, 5, 2, 1]

for set in [usCoins, euCoins] {
  print(countCoins(amountCents: 100, coins: Array(set.dropFirst(2))))
  print(countCoins(amountCents: 100000, coins: set))
  print(countCoins(amountCents: 1000000, coins: set))
  print(countCoins(amountCents: 10000000, coins: set))
  print()
}
