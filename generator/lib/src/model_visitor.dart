import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

class ViewModelVisitor extends SimpleElementVisitor<void> {
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