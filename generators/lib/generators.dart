library generators;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:generators/model_visitor.dart';
import 'package:source_gen/source_gen.dart';
import 'package:annotations/annotations.dart';

class ModelGenerator extends GeneratorForAnnotation<ViewModelStateAnnotation> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    ViewModelVisitor visitor = ViewModelVisitor();
    // Visit the class fields and constructor, then the className and fields
    // variable in the visitor will contain a value.
    element.visitChildren(visitor);
    final applyExt = _generateApply(visitor.className, visitor.fields);
    return applyExt;
  }
}

String _generateApply(String className, Map<String, dynamic> fields) {
  final params = fields.entries.map((e) => "${e.value}? ${e.key}").join(", ");
  final returnProperties = fields.entries
      .map((e) => "${e.key}: ${e.key} ?? this.${e.key}")
      .join(",\n");

  return '''
      extension ${className}ApplyExt on $className {
        $className apply({$params}) => $className(
          $returnProperties
        );
      }
    ''';
}

