library generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class ModelGenerator extends GeneratorForAnnotation<ViewModelState> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    ViewModelState visitor = ViewModelState();
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

class ViewModelState extends SimpleElementVisitor<void> {
  String className = '';
  Map<String, dynamic> fields = {};

  @override
  void visitConstructorElement(ConstructorElement element) {
    final String returnType = element.returnType.toString();
    className = returnType.replaceAll("*", ""); // ClassName* -> ClassName
  }

  @override
  void visitFieldElement(FieldElement element) {
    /*
    {
      name: String,
      price: double
    }
     */

    String elementType = element.type.toString().replaceAll("*", "");
    fields[element.name] = elementType;
  }
}

// This variable will used as annotation to generate the code
final viewModelState = ViewModelState();

Builder generateModelGenClass(BuilderOptions options) => SharedPartBuilder(
      [ModelGenerator()],
      "model_generator",
    );
