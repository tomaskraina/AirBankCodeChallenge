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

When possible, AirBank follows MVVM-C architecture. [RxSwift](https://github.com/ReactiveX/RxSwift), a popular reactive-programing framwork is used for binding views with view models. View controllers send events to the coordinator by using the delegate pattern.

## Project structure

The whole project is structured in scenes where each scene represents one screen in the app. Each scene consits of one `*ViewController`, `*ViewModel`, and a `*.storyboard` file.

All the other files are structured in their particular category, e.g. `Model`, `Networking`, `Extensions`, etc.

## Testing

The project has a few unit and integration tests implemented. The tests are written using the standart `XCTest` framework and are mainly focused on JSON parsing. You can run the tests by simply pressing `CMD+U` in Xcode.

# Contact

- Tom Kraina
- me@tomkraina.com
- tomkraina.com
