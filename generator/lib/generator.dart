library generator;

import 'package:build/build.dart';
import 'package:generator/src/model_generator.dart';
import 'package:generator/src/screen_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder generateModelGenClass(BuilderOptions options) =>
    SharedPartBuilder([ModelGenerator()], "state");

Builder generateScreenFiles(BuilderOptions options) =>
    LibraryBuilder(
      ScreenGenerator(),
      generatedExtension: '.screen.dart',
      allowSyntaxErrors: true,
    );