import 'dart:convert';

UploadNidResponse uploadNidResponseFromJson(String str) => UploadNidResponse.fromJson(json.decode(str));

String uploadNidResponseToJson(UploadNidResponse data) => json.encode(data.toJson());

class UploadNidResponse {
  UploadNidResponse({
    this.code,
    this.message,
    this.status,
    this.data,
    this.uuid,
  });

  final int? code;
  final dynamic message;
  final String? status;
  final Data? data;
  final dynamic uuid;

  UploadNidResponse copyWith({
    int? code,
    dynamic message,
    String? status,
    Data? data,
    dynamic uuid,
  }) =>
      UploadNidResponse(
        code: code ?? this.code,
        message: message ?? this.message,
        status: status ?? this.status,
        data: data ?? this.data,
        uuid: uuid ?? this.uuid,
      );

  factory UploadNidResponse.fromJson(Map<String, dynamic> json) => UploadNidResponse(
    code: json["code"],
    message: json["message"],
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    uuid: json["uuid"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "status": status,
    "data": data?.toJson(),
    "uuid": uuid,
  };
}

class Data {
  Data({
    this.ocrRequestUuid,
    this.nidNo,
    this.dob,
    this.applicantNameBen,
    this.applicantNameEng,
    this.fatherName,
    this.motherName,
    this.spouseName,
    this.address,
    this.idFrontName,
    this.idBackName,
  });

  final String? ocrRequestUuid;
  final String? nidNo;
  final String? dob;
  final String? applicantNameBen;
  final String? applicantNameEng;
  final String? fatherName;
  final String? motherName;
  final String? spouseName;
  final String? address;
  final String? idFrontName;
  final String? idBackName;

  Data copyWith({
    String? ocrRequestUuid,
    String? nidNo,
    String? dob,
    String? applicantNameBen,
    String? applicantNameEng,
    String? fatherName,
    String? motherName,
    String? spouseName,
    String? address,
    String? idFrontName,
    String? idBackName,
  }) =>
      Data(
        ocrRequestUuid: ocrRequestUuid ?? this.ocrRequestUuid,
        nidNo: nidNo ?? this.nidNo,
        dob: dob ?? this.dob,
        applicantNameBen: applicantNameBen ?? this.applicantNameBen,
        applicantNameEng: applicantNameEng ?? this.applicantNameEng,
        fatherName: fatherName ?? this.fatherName,
        motherName: motherName ?? this.motherName,
        spouseName: spouseName ?? this.spouseName,
        address: address ?? this.address,
        idFrontName: idFrontName ?? this.idFrontName,
        idBackName: idBackName ?? this.idBackName,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    ocrRequestUuid: json["ocr_request_uuid"],
    nidNo: json["nid_no"],
    dob: json["dob"],
    applicantNameBen: json["applicant_name_ben"],
    applicantNameEng: json["applicant_name_eng"],
    fatherName: json["father_name"],
    motherName: json["mother_name"],
    spouseName: json["spouse_name"],
    address: json["address"],
    idFrontName: json["id_front_name"],
    idBackName: json["id_back_name"],
  );

  Map<String, dynamic> toJson() => {
    "ocr_request_uuid": ocrRequestUuid,
    "nid_no": nidNo,
    "dob": dob,
    "applicant_name_ben": applicantNameBen,
    "applicant_name_eng": applicantNameEng,
    "father_name": fatherName,
    "mother_name": motherName,
    "spouse_name": spouseName,
    "address": address,
    "id_front_name": idFrontName,
    "id_back_name": idBackName,
  };
}
