import '../../api/geo_location/model/district_list_response.dart';
import '../../api/geo_location/model/division_list_response.dart';
import '../../api/geo_location/model/upazila_list_response.dart';
import '../enums/nid_details_tag.dart';

class GeoLocData {

  DivisionListResponse? divisionList;
  DistrictListResponse? districtList;
  UpazilaListResponse? upazilaList;
  NidDetailsTag? tag;

  GeoLocData({
    this.divisionList,
    this.districtList,
    this.upazilaList,
    this.tag,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeoLocData &&
          runtimeType == other.runtimeType &&
          divisionList == other.divisionList &&
          districtList == other.districtList &&
          upazilaList == other.upazilaList &&
          tag == other.tag);

  @override
  int get hashCode =>
      divisionList.hashCode ^
      districtList.hashCode ^
      upazilaList.hashCode ^
      tag.hashCode;

  @override
  String toString() {
    return 'GeoLocData{ divisionList: $divisionList, districtList: $districtList, upazilaList: $upazilaList, tag: $tag,}';
  }

  GeoLocData copyWith({
    DivisionListResponse? divisionList,
    DistrictListResponse? districtList,
    UpazilaListResponse? upazilaList,
    NidDetailsTag? tag,
  }) {
    return GeoLocData(
      divisionList: divisionList ?? this.divisionList,
      districtList: districtList ?? this.districtList,
      upazilaList: upazilaList ?? this.upazilaList,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'divisionList': this.divisionList,
      'districtList': this.districtList,
      'upazilaList': this.upazilaList,
      'tag': this.tag,
    };
  }

  factory GeoLocData.fromMap(Map<String, dynamic> map) {
    return GeoLocData(
      divisionList: map['divisionList'] as DivisionListResponse,
      districtList: map['districtList'] as DistrictListResponse,
      upazilaList: map['upazilaList'] as UpazilaListResponse,
      tag: map['tag'] as NidDetailsTag,
    );
  }
}
