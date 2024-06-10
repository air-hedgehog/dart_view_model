import 'package:flutter/widgets.dart';
import 'package:view_model/view_model.dart';

abstract class AbstractPageState<StatefulWidgetType extends StatefulWidget,
    VMT extends AbstractViewModel, ST> extends State<StatefulWidgetType> {
  //VMT - ViewModelType, ST - StateType

  AbstractPageState(VMT viewModelInstance) {
    this.viewModel = viewModelInstance;
  }

  late VMT viewModel;
  late ST state;

  @override
  void initState() {
    super.initState();
    state = viewModel.getCurrentState();
    viewModel.state.listen((event) {
      setState(() {
        state = event;
      });
    });
    viewModel.getState();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }
}
