enum ViewState { idle, loading, error, success }

extension ViewStateExtension on ViewState {
  bool get isLoading => this == ViewState.loading;
  bool get isIdle => this == ViewState.idle;
  bool get isError => this == ViewState.error;
  bool get isSuccess => this == ViewState.success;
}