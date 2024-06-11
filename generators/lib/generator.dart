library generator;

import 'package:build/build.dart';
import 'package:generators/generators.dart';
import 'package:source_gen/source_gen.dart';

Builder generateModelGenClass(BuilderOptions options) => SharedPartBuilder(
      [ModelGenerator()],
      "model_generator",
    );
