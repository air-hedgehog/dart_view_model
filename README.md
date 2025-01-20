
// Integration structure in pubspec.yaml:

dependencies:
  flutter_localizations:
    sdk: flutter
  view_model:
    git:
      url: git@github.com:air-hedgehog/dart_view_model.git
      ref: master
  annotation:
    git:
      url: git@github.com:air-hedgehog/dart_view_model.git
      ref: master
      path: annotation

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.11
  generator:
    git:
      url: git@github.com:air-hedgehog/dart_view_model.git
      ref: master
      path: generator


// command for generating new state "apply" function - in your terminal use:
dart run build_runner build

!!!Nullable value types in state class are NOT supported!!!
