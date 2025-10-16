import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:annotation/annotation.dart';

class ScreenGenerator extends GeneratorForAnnotation<ViewModelStateAnnotation> {
  @override
  Future<String> generateForAnnotatedElement(
      Element element,
      ConstantReader annotation,
      BuildStep buildStep,
      ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@ViewModelStateAnnotation can only be applied to classes.',
        element: element,
      );
    }

    final className = element.name!;
    final baseName = _getBaseName(className);

    // Check if files already exist before generating
    final screenFileExists = await _fileExists(buildStep, baseName, '_screen.dart');
    final viewModelFileExists = await _fileExists(buildStep, baseName, '_view_model.dart');

    // Only generate if files don't exist
    if (!screenFileExists) {
      await _generateScreenFile(buildStep, baseName, className);
    }

    if (!viewModelFileExists) {
      await _generateViewModelFile(buildStep, baseName, className);
    }
    // Return empty string since we're generating standalone files
    return '';
  }

  String _getBaseName(String className) {
    return className
        .replaceAll('State', '')
        .replaceAllMapped(RegExp('([a-z])([A-Z])'), (match) => '${match[1]}_${match[2]}')
        .toLowerCase();
  }

  Future<bool> _fileExists(BuildStep buildStep, String baseName, String suffix) async {
    final filePath = buildStep.inputId.path.replaceFirst(
        RegExp(r'_[^_]+_state\.dart$'),
        '$suffix'
    );
    final assetId = AssetId(buildStep.inputId.package, filePath);

    try {
      // Try to read the asset - if it exists, we won't generate
      await buildStep.canRead(assetId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _generateScreenFile(BuildStep buildStep, String baseName, String className) async {
    final screenClassName = '${className.replaceAll('State', '')}Screen';
    final viewModelClassName = '${className.replaceAll('State', '')}ViewModel';
    final stateClassName = className;

    final content = '''
// GENERATED FILE - EDIT AS NEEDED
// This file was automatically generated but can be manually modified

import 'package:flutter/material.dart';
import '${baseName}_view_model.dart';
import '${buildStep.inputId.path}';

class $screenClassName extends StatefulWidget {
  const $screenClassName({super.key});

  @override
  State<$screenClassName> createState() => _${screenClassName}State();
}

class _${screenClassName}State extends AbstractPageState<$screenClassName, $viewModelClassName, $stateClassName> {
  _${screenClassName}State() : super($viewModelClassName());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
    );
  }
  
}
''';

    final outputId = AssetId(
      buildStep.inputId.package,
      buildStep.inputId.path.replaceFirst(RegExp(r'_[^_]+_state\.dart$'), '_screen.dart'),
    );

    await buildStep.writeAsString(outputId, content);
  }

  Future<void> _generateViewModelFile(BuildStep buildStep, String baseName, String className) async {
    final viewModelClassName = '${className.replaceAll('State', '')}ViewModel';
    final stateClassName = className;

    final content = '''
// GENERATED FILE - EDIT AS NEEDED  
// This file was automatically generated but can be manually modified

import '${buildStep.inputId.path}';

class $viewModelClassName extends AbstractViewModel<$stateClassName> {
  $viewModelClassName() : super($stateClassName(loading: false, items: []));

  @override
  void getState() {
    // TODO: Implement state fetching logic
  }
}
''';

    final outputId = AssetId(
      buildStep.inputId.package,
      buildStep.inputId.path.replaceFirst(RegExp(r'_[^_]+_state\.dart$'), '_view_model.dart'),
    );

    await buildStep.writeAsString(outputId, content);
  }
}