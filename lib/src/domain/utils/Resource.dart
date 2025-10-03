enum Status { loading, success, error }

class Resource<T> {
  final Status? status;
  final T? data;
  final String? message;

  const Resource._({required this.status, this.data, this.message});

  // --- Estado de carga ---
  factory Resource.loading([T? data]) {
    return Resource._(status: Status.loading, data: data);
  }

  // --- Estado de éxito ---
  factory Resource.success(T data) {
    return Resource._(status: Status.success, data: data);
  }

  // --- Estado de error ---
  factory Resource.error(String message, [T? data]) {
    return Resource._(status: Status.error, message: message, data: data);
  }

  @override
  String toString() {
    return 'Resource{status: $status, data: $data, message: $message}';
  }
}
