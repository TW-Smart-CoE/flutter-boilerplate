import 'package:first_demo/common/async_loader/data_controller.dart';
import 'package:first_demo/common/async_loader/load_state.dart';
import 'package:first_demo/common/utils/logger.dart';
import 'package:get/get.dart';

class AsyncLoadController<T> extends GetxController {
  final DataController<T> _dataController;

  final loadState = Rx<LoadState<T>>(Idle<T>());
  T? _data;

  AsyncLoadController(this._dataController);

  void load() async {
    loadState.value = Loading<T>(_data);
    try {
      final data = await _dataController.fetch();
      _data = data;
      _dataController.data = data;
      loadState.value = Success<T>(data);
    } catch (e) {
      logger.e('[AsyncLoadViewModel] there is an error in fetcher', error: e);
      loadState.value = Failure<T>(_data, e);
    }
  }

  void reset() {
    loadState.value = Idle<T>();
    _data = null;
  }
}
