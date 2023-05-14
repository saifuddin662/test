class CapturedPhotos {
  String? nidFront;
  String? nidBack;
  String? face;

  CapturedPhotos({
    this.nidFront,
    this.nidBack,
    this.face,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CapturedPhotos &&
          runtimeType == other.runtimeType &&
          nidFront == other.nidFront &&
          nidBack == other.nidBack &&
          face == other.face);

  @override
  int get hashCode => nidFront.hashCode ^ nidBack.hashCode ^ face.hashCode;

  @override
  String toString() {
    return 'CapturedPhotos{ nidFront: $nidFront, nidBack: $nidBack, face: $face,}';
  }

  CapturedPhotos copyWith({
    String? nidFront,
    String? nidBack,
    String? face,
  }) {
    return CapturedPhotos(
      nidFront: nidFront ?? this.nidFront,
      nidBack: nidBack ?? this.nidBack,
      face: face ?? this.face,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nidFront': nidFront,
      'nidBack': nidBack,
      'face': face,
    };
  }

  factory CapturedPhotos.fromMap(Map<String, dynamic> map) {
    return CapturedPhotos(
      nidFront: map['nidFront'] as String,
      nidBack: map['nidBack'] as String,
      face: map['face'] as String,
    );
  }
}
