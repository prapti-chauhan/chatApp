extension StringExt on String? {
  bool isNullOrEmpty() {
    if (this == null || this!.isEmpty) {
      return true;
    }
    return false;
  }
}
//check string, map, list, set

extension ObjectsExtension on Object? {
  bool get isNullOrEmpty {
    if (this == null) return true;

    if (this is String) {
      if ((this as String).isEmpty) {
        return true;
      }
    }
    if (this is Map) {
      if ((this as Map).isEmpty) {
        return true;
      }
    }
    if (this is List) {
      if ((this as List).isEmpty) {
        return true;
      }
    }
    if (this is Set) {
      if ((this as Set).isEmpty) {
        return true;
      }
    }
    return false;
  }
}
