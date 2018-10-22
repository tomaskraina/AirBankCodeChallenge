# AirBank Code Challenge

## Requirements

- iOS 12.0+
- Xcode 10.0+
- Swift 4.2
- Carthage 0.31.1+

## QuickStart

### How to run the project

This project uses [Carthage](https://github.com/Carthage/Carthage) as a dependency manager of choice. The dependencies are not included in the project so you need open the this folder in Terminal and run the following command:

```sh
carthage bootstrap --platform ios
```

## Architecture

When possible (and suitable), this app follows MVVM architecture.

## Project structure

The whole project is structured in scenes where each scene represents one screen in the app. Each scene consits of at least one `*ViewController` and `*ViewModel`.

All the other files are structured in their particular category, e.g. `Model`, `Networking`, `Extensions`, etc.

## Testing

The project has only unit test implemented. The tests are written using the standart `XCTest` framework and are mainly focused on JSON parsing. You can run the tests by simply pressing `CMD+U` in Xcode.

# Contact

Tom Kraina
me@tomkraina.com
tomkraina.com
