class WalletData {
  WalletData({
    this.id,
    this.updatedAtDt,
    this.permanentAddress,
    this.createdByUsername,
    this.activationStatus,
    this.updatedByUsername,
    this.updatedBy,
    this.createdAtDt,
    this.createdAt,
    this.createdBy,
    this.walletNo,
    this.phoneNo,
    this.fullName,
    this.nid,
    this.channelId,
    this.channelType,
    this.pinSetStatus,
    this.walletType,
    this.presentAddress,
    this.walletTypeId,
    this.hasDocuments,
    this.kycStatus,
    this.dob,
    this.detailsId,
    this.lastModificationDateLong,
    this.registrationDate,
    this.walletSubTypeId,
    this.activationDateLong,
    this.lastModificationDate,
    this.registrationDateLong,
    this.updatedAt,
    this.contactNo,
    this.activationDate,
    this.walletTag,
    this.walletSubType,
    this.additionalInfo,
    this.userStatus,
  });

  int? id;
  DateTime? updatedAtDt;
  String? permanentAddress;
  String? createdByUsername;
  int? activationStatus;
  dynamic updatedByUsername;
  dynamic updatedBy;
  DateTime? createdAtDt;
  DateTime? createdAt;
  dynamic createdBy;
  String? walletNo;
  String? phoneNo;
  String? fullName;
  String? nid;
  int? channelId;
  String? channelType;
  int? pinSetStatus;
  String? walletType;
  String? presentAddress;
  int? walletTypeId;
  int? hasDocuments;
  int? kycStatus;
  String? dob;
  int? detailsId;
  dynamic lastModificationDateLong;
  dynamic registrationDate;
  dynamic walletSubTypeId;
  dynamic activationDateLong;
  dynamic lastModificationDate;
  dynamic registrationDateLong;
  dynamic updatedAt;
  dynamic contactNo;
  dynamic activationDate;
  dynamic walletTag;
  dynamic walletSubType;
  dynamic additionalInfo;
  String? userStatus;

  WalletData copyWith({
    int? id,
    DateTime? updatedAtDt,
    String? permanentAddress,
    String? createdByUsername,
    int? activationStatus,
    dynamic updatedByUsername,
    dynamic updatedBy,
    DateTime? createdAtDt,
    DateTime? createdAt,
    dynamic createdBy,
    String? walletNo,
    String? phoneNo,
    String? fullName,
    String? nid,
    int? channelId,
    String? channelType,
    int? pinSetStatus,
    String? walletType,
    String? presentAddress,
    int? walletTypeId,
    int? hasDocuments,
    int? kycStatus,
    String? dob,
    int? detailsId,
    dynamic lastModificationDateLong,
    dynamic registrationDate,
    dynamic walletSubTypeId,
    dynamic activationDateLong,
    dynamic lastModificationDate,
    dynamic registrationDateLong,
    dynamic updatedAt,
    dynamic contactNo,
    dynamic activationDate,
    dynamic walletTag,
    dynamic walletSubType,
    dynamic additionalInfo,
    String? userStatus,
  }) =>
      WalletData(
        id: id ?? this.id,
        updatedAtDt: updatedAtDt ?? this.updatedAtDt,
        permanentAddress: permanentAddress ?? this.permanentAddress,
        createdByUsername: createdByUsername ?? this.createdByUsername,
        activationStatus: activationStatus ?? this.activationStatus,
        updatedByUsername: updatedByUsername ?? this.updatedByUsername,
        updatedBy: updatedBy ?? this.updatedBy,
        createdAtDt: createdAtDt ?? this.createdAtDt,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        walletNo: walletNo ?? this.walletNo,
        phoneNo: phoneNo ?? this.phoneNo,
        fullName: fullName ?? this.fullName,
        nid: nid ?? this.nid,
        channelId: channelId ?? this.channelId,
        channelType: channelType ?? this.channelType,
        pinSetStatus: pinSetStatus ?? this.pinSetStatus,
        walletType: walletType ?? this.walletType,
        presentAddress: presentAddress ?? this.presentAddress,
        walletTypeId: walletTypeId ?? this.walletTypeId,
        hasDocuments: hasDocuments ?? this.hasDocuments,
        kycStatus: kycStatus ?? this.kycStatus,
        dob: dob ?? this.dob,
        detailsId: detailsId ?? this.detailsId,
        lastModificationDateLong:
            lastModificationDateLong ?? this.lastModificationDateLong,
        registrationDate: registrationDate ?? this.registrationDate,
        walletSubTypeId: walletSubTypeId ?? this.walletSubTypeId,
        activationDateLong: activationDateLong ?? this.activationDateLong,
        lastModificationDate: lastModificationDate ?? this.lastModificationDate,
        registrationDateLong: registrationDateLong ?? this.registrationDateLong,
        updatedAt: updatedAt ?? this.updatedAt,
        contactNo: contactNo ?? this.contactNo,
        activationDate: activationDate ?? this.activationDate,
        walletTag: walletTag ?? this.walletTag,
        walletSubType: walletSubType ?? this.walletSubType,
        additionalInfo: additionalInfo ?? this.additionalInfo,
        userStatus: userStatus ?? this.userStatus,
      );

  factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
        id: json["id"],
        updatedAtDt: json["updated_AT_DT"] == null
            ? null
            : DateTime.parse(json["updated_AT_DT"]),
        permanentAddress: json["permanent_ADDRESS"],
        createdByUsername: json["created_BY_USERNAME"],
        activationStatus: json["activation_STATUS"],
        updatedByUsername: json["updated_BY_USERNAME"],
        updatedBy: json["updated_BY"],
        createdAtDt: json["created_AT_DT"] == null
            ? null
            : DateTime.parse(json["created_AT_DT"]),
        createdAt: json["created_AT"] == null
            ? null
            : DateTime.parse(json["created_AT"]),
        createdBy: json["created_BY"],
        walletNo: json["wallet_NO"],
        phoneNo: json["phone_NO"],
        fullName: json["full_NAME"],
        nid: json["nid"],
        channelId: json["channel_ID"],
        channelType: json["channel_TYPE"],
        pinSetStatus: json["pin_SET_STATUS"],
        walletType: json["wallet_TYPE"],
        presentAddress: json["present_ADDRESS"],
        walletTypeId: json["wallet_TYPE_ID"],
        hasDocuments: json["has_DOCUMENTS"],
        kycStatus: json["kyc_STATUS"],
        dob: json["dob"],
        detailsId: json["details_ID"],
        lastModificationDateLong: json["last_MODIFICATION_DATE_LONG"],
        registrationDate: json["registration_DATE"],
        walletSubTypeId: json["wallet_SUB_TYPE_ID"],
        activationDateLong: json["activation_DATE_LONG"],
        lastModificationDate: json["last_MODIFICATION_DATE"],
        registrationDateLong: json["registration_DATE_LONG"],
        updatedAt: json["updated_AT"],
        contactNo: json["contact_NO"],
        activationDate: json["activation_DATE"],
        walletTag: json["wallet_TAG"],
        walletSubType: json["wallet_SUB_TYPE"],
        additionalInfo: json["additional_INFO"],
        userStatus: json["user_STATUS"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "updated_AT_DT": updatedAtDt?.toIso8601String(),
        "permanent_ADDRESS": permanentAddress,
        "created_BY_USERNAME": createdByUsername,
        "activation_STATUS": activationStatus,
        "updated_BY_USERNAME": updatedByUsername,
        "updated_BY": updatedBy,
        "created_AT_DT": createdAtDt?.toIso8601String(),
        "created_AT": createdAt?.toIso8601String(),
        "created_BY": createdBy,
        "wallet_NO": walletNo,
        "phone_NO": phoneNo,
        "full_NAME": fullName,
        "nid": nid,
        "channel_ID": channelId,
        "channel_TYPE": channelType,
        "pin_SET_STATUS": pinSetStatus,
        "wallet_TYPE": walletType,
        "present_ADDRESS": presentAddress,
        "wallet_TYPE_ID": walletTypeId,
        "has_DOCUMENTS": hasDocuments,
        "kyc_STATUS": kycStatus,
        "dob": dob,
        "details_ID": detailsId,
        "last_MODIFICATION_DATE_LONG": lastModificationDateLong,
        "registration_DATE": registrationDate,
        "wallet_SUB_TYPE_ID": walletSubTypeId,
        "activation_DATE_LONG": activationDateLong,
        "last_MODIFICATION_DATE": lastModificationDate,
        "registration_DATE_LONG": registrationDateLong,
        "updated_AT": updatedAt,
        "contact_NO": contactNo,
        "activation_DATE": activationDate,
        "wallet_TAG": walletTag,
        "wallet_SUB_TYPE": walletSubType,
        "additional_INFO": additionalInfo,
        "user_STATUS": userStatus,
      };
}
