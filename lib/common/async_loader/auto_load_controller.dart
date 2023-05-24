import 'package:first_demo/common/async_loader/async_load_controller.dart';
import 'package:first_demo/common/async_loader/data_controller.dart';

class AutoLoadController<T> extends AsyncLoadController<T> {
  AutoLoadController(DataController<T> dataController) : super(dataController);

  @override
  void onInit() {
    super.onInit();
    load();
  }
}
