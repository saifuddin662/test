class EkycInfos{

  //set from prv_back
  String? applicantNameBen;
  String? applicantNameEng;
  String? fatherName;
  String? motherName;
  String? dob;
  String? nidNo;

  String? ocrRequestUuid;
  String? spouseName;
  String? address;
  String? idFrontName;
  String? idBackName;
  //set from prv_back

  //set from ekyc details
  String? pres_address;
  String? perm_address;
  int? divisionPresent;
  int? districtPresent;
  int? thanaPresent;
  int? divisionPermanent;
  int? districtPermanent;
  int? thanaPermanent;
  String? post_office_present;
  String? post_code_present;
  String? post_office_permanent;
  String? post_code_permanent;

  String? nominee;
  String? nominee_nid;
  String? nominee_dob;
  String? nominee_mobile;
  String? nominee_relation;
  String? nominee_percentage;
  //set from ekyc details

  //set from additional info
  String? gender;
  String? blood_group;
  String? source_of_income;
  String? profession;
  String? income_amount;
  //set from additional info

  EkycInfos({
    this.applicantNameBen,
    this.applicantNameEng,
    this.fatherName,
    this.motherName,
    this.dob,
    this.nidNo,
    this.ocrRequestUuid,
    this.spouseName,
    this.address,
    this.idFrontName,
    this.idBackName,
    this.pres_address,
    this.perm_address,
    this.divisionPresent,
    this.districtPresent,
    this.thanaPresent,
    this.divisionPermanent,
    this.districtPermanent,
    this.thanaPermanent,
    this.post_office_present,
    this.post_code_present,
    this.post_office_permanent,
    this.post_code_permanent,
    this.nominee,
    this.nominee_nid,
    this.nominee_dob,
    this.nominee_mobile,
    this.nominee_relation,
    this.nominee_percentage,
    this.gender,
    this.blood_group,
    this.source_of_income,
    this.profession,
    this.income_amount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EkycInfos &&
          runtimeType == other.runtimeType &&
          applicantNameBen == other.applicantNameBen &&
          applicantNameEng == other.applicantNameEng &&
          fatherName == other.fatherName &&
          motherName == other.motherName &&
          dob == other.dob &&
          nidNo == other.nidNo &&
          ocrRequestUuid == other.ocrRequestUuid &&
          spouseName == other.spouseName &&
          address == other.address &&
          idFrontName == other.idFrontName &&
          idBackName == other.idBackName &&
          pres_address == other.pres_address &&
          perm_address == other.perm_address &&
          divisionPresent == other.divisionPresent &&
          districtPresent == other.districtPresent &&
          thanaPresent == other.thanaPresent &&
          divisionPermanent == other.divisionPermanent &&
          districtPermanent == other.districtPermanent &&
          thanaPermanent == other.thanaPermanent &&
          post_office_present == other.post_office_present &&
          post_code_present == other.post_code_present &&
          post_office_permanent == other.post_office_permanent &&
          post_code_permanent == other.post_code_permanent &&
          nominee == other.nominee &&
          nominee_nid == other.nominee_nid &&
          nominee_dob == other.nominee_dob &&
          nominee_mobile == other.nominee_mobile &&
          nominee_relation == other.nominee_relation &&
          nominee_percentage == other.nominee_percentage &&
          gender == other.gender &&
          blood_group == other.blood_group &&
          source_of_income == other.source_of_income &&
          profession == other.profession &&
          income_amount == other.income_amount);

  @override
  int get hashCode =>
      applicantNameBen.hashCode ^
      applicantNameEng.hashCode ^
      fatherName.hashCode ^
      motherName.hashCode ^
      dob.hashCode ^
      nidNo.hashCode ^
      ocrRequestUuid.hashCode ^
      spouseName.hashCode ^
      address.hashCode ^
      idFrontName.hashCode ^
      idBackName.hashCode ^
      pres_address.hashCode ^
      perm_address.hashCode ^
      divisionPresent.hashCode ^
      districtPresent.hashCode ^
      thanaPresent.hashCode ^
      divisionPermanent.hashCode ^
      districtPermanent.hashCode ^
      thanaPermanent.hashCode ^
      post_office_present.hashCode ^
      post_code_present.hashCode ^
      post_office_permanent.hashCode ^
      post_code_permanent.hashCode ^
      nominee.hashCode ^
      nominee_nid.hashCode ^
      nominee_dob.hashCode ^
      nominee_mobile.hashCode ^
      nominee_relation.hashCode ^
      nominee_percentage.hashCode ^
      gender.hashCode ^
      blood_group.hashCode ^
      source_of_income.hashCode ^
      profession.hashCode ^
      income_amount.hashCode;

  @override
  String toString() {
    return 'EkycInfos{ applicantNameBen: $applicantNameBen, applicantNameEng: $applicantNameEng, fatherName: $fatherName, motherName: $motherName, dob: $dob, nidNo: $nidNo, ocrRequestUuid: $ocrRequestUuid, spouseName: $spouseName, address: $address, idFrontName: $idFrontName, idBackName: $idBackName, pres_address: $pres_address, perm_address: $perm_address, divisionPresent: $divisionPresent, districtPresent: $districtPresent, thanaPresent: $thanaPresent, divisionPermanent: $divisionPermanent, districtPermanent: $districtPermanent, thanaPermanent: $thanaPermanent, post_office_present: $post_office_present, post_code_present: $post_code_present, post_office_permanent: $post_office_permanent, post_code_permanent: $post_code_permanent, nominee: $nominee, nominee_nid: $nominee_nid, nominee_dob: $nominee_dob, nominee_mobile: $nominee_mobile, nominee_relation: $nominee_relation, nominee_percentage: $nominee_percentage, gender: $gender, blood_group: $blood_group, source_of_income: $source_of_income, profession: $profession, income_amount: $income_amount,}';
  }

  EkycInfos copyWith({
    String? applicantNameBen,
    String? applicantNameEng,
    String? fatherName,
    String? motherName,
    String? dob,
    String? nidNo,
    String? ocrRequestUuid,
    String? spouseName,
    String? address,
    String? idFrontName,
    String? idBackName,
    String? pres_address,
    String? perm_address,
    int? divisionPresent,
    int? districtPresent,
    int? thanaPresent,
    int? divisionPermanent,
    int? districtPermanent,
    int? thanaPermanent,
    String? post_office_present,
    String? post_code_present,
    String? post_office_permanent,
    String? post_code_permanent,
    String? nominee,
    String? nominee_nid,
    String? nominee_dob,
    String? nominee_mobile,
    String? nominee_relation,
    String? nominee_percentage,
    String? gender,
    String? blood_group,
    String? source_of_income,
    String? profession,
    String? income_amount,
  }) {
    return EkycInfos(
      applicantNameBen: applicantNameBen ?? this.applicantNameBen,
      applicantNameEng: applicantNameEng ?? this.applicantNameEng,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      dob: dob ?? this.dob,
      nidNo: nidNo ?? this.nidNo,
      ocrRequestUuid: ocrRequestUuid ?? this.ocrRequestUuid,
      spouseName: spouseName ?? this.spouseName,
      address: address ?? this.address,
      idFrontName: idFrontName ?? this.idFrontName,
      idBackName: idBackName ?? this.idBackName,
      pres_address: pres_address ?? this.pres_address,
      perm_address: perm_address ?? this.perm_address,
      divisionPresent: divisionPresent ?? this.divisionPresent,
      districtPresent: districtPresent ?? this.districtPresent,
      thanaPresent: thanaPresent ?? this.thanaPresent,
      divisionPermanent: divisionPermanent ?? this.divisionPermanent,
      districtPermanent: districtPermanent ?? this.districtPermanent,
      thanaPermanent: thanaPermanent ?? this.thanaPermanent,
      post_office_present: post_office_present ?? this.post_office_present,
      post_code_present: post_code_present ?? this.post_code_present,
      post_office_permanent:
          post_office_permanent ?? this.post_office_permanent,
      post_code_permanent: post_code_permanent ?? this.post_code_permanent,
      nominee: nominee ?? this.nominee,
      nominee_nid: nominee_nid ?? this.nominee_nid,
      nominee_dob: nominee_dob ?? this.nominee_dob,
      nominee_mobile: nominee_mobile ?? this.nominee_mobile,
      nominee_relation: nominee_relation ?? this.nominee_relation,
      nominee_percentage: nominee_percentage ?? this.nominee_percentage,
      gender: gender ?? this.gender,
      blood_group: blood_group ?? this.blood_group,
      source_of_income: source_of_income ?? this.source_of_income,
      profession: profession ?? this.profession,
      income_amount: income_amount ?? this.income_amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'applicantNameBen': this.applicantNameBen,
      'applicantNameEng': this.applicantNameEng,
      'fatherName': this.fatherName,
      'motherName': this.motherName,
      'dob': this.dob,
      'nidNo': this.nidNo,
      'ocrRequestUuid': this.ocrRequestUuid,
      'spouseName': this.spouseName,
      'address': this.address,
      'idFrontName': this.idFrontName,
      'idBackName': this.idBackName,
      'pres_address': this.pres_address,
      'perm_address': this.perm_address,
      'divisionPresent': this.divisionPresent,
      'districtPresent': this.districtPresent,
      'thanaPresent': this.thanaPresent,
      'divisionPermanent': this.divisionPermanent,
      'districtPermanent': this.districtPermanent,
      'thanaPermanent': this.thanaPermanent,
      'post_office_present': this.post_office_present,
      'post_code_present': this.post_code_present,
      'post_office_permanent': this.post_office_permanent,
      'post_code_permanent': this.post_code_permanent,
      'nominee': this.nominee,
      'nominee_nid': this.nominee_nid,
      'nominee_dob': this.nominee_dob,
      'nominee_mobile': this.nominee_mobile,
      'nominee_relation': this.nominee_relation,
      'nominee_percentage': this.nominee_percentage,
      'gender': this.gender,
      'blood_group': this.blood_group,
      'source_of_income': this.source_of_income,
      'profession': this.profession,
      'income_amount': this.income_amount,
    };
  }

  factory EkycInfos.fromMap(Map<String, dynamic> map) {
    return EkycInfos(
      applicantNameBen: map['applicantNameBen'] as String,
      applicantNameEng: map['applicantNameEng'] as String,
      fatherName: map['fatherName'] as String,
      motherName: map['motherName'] as String,
      dob: map['dob'] as String,
      nidNo: map['nidNo'] as String,
      ocrRequestUuid: map['ocrRequestUuid'] as String,
      spouseName: map['spouseName'] as String,
      address: map['address'] as String,
      idFrontName: map['idFrontName'] as String,
      idBackName: map['idBackName'] as String,
      pres_address: map['pres_address'] as String,
      perm_address: map['perm_address'] as String,
      divisionPresent: map['divisionPresent'] as int,
      districtPresent: map['districtPresent'] as int,
      thanaPresent: map['thanaPresent'] as int,
      divisionPermanent: map['divisionPermanent'] as int,
      districtPermanent: map['districtPermanent'] as int,
      thanaPermanent: map['thanaPermanent'] as int,
      post_office_present: map['post_office_present'] as String,
      post_code_present: map['post_code_present'] as String,
      post_office_permanent: map['post_office_permanent'] as String,
      post_code_permanent: map['post_code_permanent'] as String,
      nominee: map['nominee'] as String,
      nominee_nid: map['nominee_nid'] as String,
      nominee_dob: map['nominee_dob'] as String,
      nominee_mobile: map['nominee_mobile'] as String,
      nominee_relation: map['nominee_relation'] as String,
      nominee_percentage: map['nominee_percentage'] as String,
      gender: map['gender'] as String,
      blood_group: map['blood_group'] as String,
      source_of_income: map['source_of_income'] as String,
      profession: map['profession'] as String,
      income_amount: map['income_amount'] as String,
    );
  }
}