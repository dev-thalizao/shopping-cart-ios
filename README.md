[![CI](https://github.com/dev-thalizao/shopping-cart-ios/actions/workflows/ci.yml/badge.svg)](https://github.com/dev-thalizao/shopping-cart-ios/actions/workflows/ci.yml)
![Xcode](https://img.shields.io/badge/Xcode-14.2-blue.svg?style=flat)
[![Swift 5.7.2](https://img.shields.io/badge/Swift-5.7.2-orange.svg?style=flat)](https://swift.org)
![iOS](https://img.shields.io/badge/iOS-16.2-red?style=flat)

# ShoppingCart 🛒

The components are built focus on the reusability by multiple projects. The modularization was composed by:

- [CartEngine](./Packages/CartEngine/Sources): All the operations related to a cart, such add, remove, total price, with a generic API that can be used in any project.
- [NetworkEngine](./Packages/NetworkEngine/Sources): Simple HTTPClient that can be used in any project. Provides a contract and a default implementation using URLSession.
- [Marketplace](./Packages/Marketplace/Sources): The product and the cart feature, can be run in isolation of the main project.
- [CartApp](./Apps/CartApp): The main module, that create features and inject the dependencies.

https://user-images.githubusercontent.com/6041775/119925214-5d145c80-bf4b-11eb-9d7d-bf74593a998a.mov

## Getting Started

1. Install Xcode.
2. Clone this repository.
3. Open [ShoppingCart.xcworkspace](./ShoppingCart.xcworkspace):
```bash
open ShoppingCart.xcworkspace
```
> Xcode will do all the hard work for you 👨‍💻

## Features

- Load products
- Add products to the cart
- Remove products from the cart
- Increase and decrease products from the cart
- Clear the cart

## Non-functional features

- Clean Architecture
- SOLID Principles
- Unit Tests using TDD
- Modularity using Swift Package
- Design Patterns (Strategy, Adapter)
- SwiftUI
- HTTP requests
- CI using GitHub Actions