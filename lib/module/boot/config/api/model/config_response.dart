import 'dart:convert';

ConfigResponse configResponseFromJson(String str) => ConfigResponse.fromJson(json.decode(str));

String configResponseToJson(ConfigResponse data) => json.encode(data.toJson());

class ConfigResponse {
  ConfigResponse({
    this.serverConfig,
    this.clientConfig,
  });

  ServerConfig? serverConfig;
  ClientConfig? clientConfig;

  ConfigResponse copyWith({
    ServerConfig? serverConfig,
    ClientConfig? clientConfig,
  }) =>
      ConfigResponse(
        serverConfig: serverConfig ?? this.serverConfig,
        clientConfig: clientConfig ?? this.clientConfig,
      );

  factory ConfigResponse.fromJson(Map<String, dynamic> json) => ConfigResponse(
    serverConfig: json["serverConfig"] == null ? null : ServerConfig.fromJson(json["serverConfig"]),
    clientConfig: json["clientConfig"] == null ? null : ClientConfig.fromJson(json["clientConfig"]),
  );

  Map<String, dynamic> toJson() => {
    "serverConfig": serverConfig?.toJson(),
    "clientConfig": clientConfig?.toJson(),
  };
}

class ClientConfig {
  ClientConfig({
    this.forceUpdateVersion,
    this.blacklistVersion,
    this.message,
    this.link,
    this.forceUpdateEnabled,
    this.blackListed,
    this.hiddenFeatureVersion,
    this.hiddenFeatureStatus,
  });

  String? forceUpdateVersion;
  String? blacklistVersion;
  String? message;
  String? link;
  bool? forceUpdateEnabled;
  bool? blackListed;
  String? hiddenFeatureVersion;
  bool? hiddenFeatureStatus;

  ClientConfig copyWith({
    String? forceUpdateVersion,
    String? blacklistVersion,
    String? message,
    String? link,
    bool? forceUpdateEnabled,
    bool? blackListed,
    String? hiddenFeatureVersion,
    bool? hiddenFeatureStatus,
  }) =>
      ClientConfig(
        forceUpdateVersion: forceUpdateVersion ?? this.forceUpdateVersion,
        blacklistVersion: blacklistVersion ?? this.blacklistVersion,
        message: message ?? this.message,
        link: link ?? this.link,
        forceUpdateEnabled: forceUpdateEnabled ?? this.forceUpdateEnabled,
        blackListed: blackListed ?? this.blackListed,
        hiddenFeatureVersion: hiddenFeatureVersion ?? this.hiddenFeatureVersion,
        hiddenFeatureStatus: hiddenFeatureStatus ?? this.hiddenFeatureStatus,
      );

  factory ClientConfig.fromJson(Map<String, dynamic> json) => ClientConfig(
    forceUpdateVersion: json["forceUpdateVersion"],
    blacklistVersion: json["blacklistVersion"],
    message: json["message"],
    link: json["link"],
    forceUpdateEnabled: json["forceUpdateEnabled"],
    blackListed: json["blackListed"],
    hiddenFeatureVersion: json["hiddenFeatureVersion"],
    hiddenFeatureStatus: json["hiddenFeatureStatus"],
  );

  Map<String, dynamic> toJson() => {
    "forceUpdateVersion": forceUpdateVersion,
    "blacklistVersion": blacklistVersion,
    "message": message,
    "link": link,
    "forceUpdateEnabled": forceUpdateEnabled,
    "blackListed": blackListed,
    "hiddenFeatureVersion": hiddenFeatureVersion,
    "hiddenFeatureStatus": hiddenFeatureStatus,
  };
}

class ServerConfig {
  ServerConfig({
    this.deviceBindingEnabled,
    this.serviceInfo,
  });

  bool? deviceBindingEnabled;
  ServiceInfo? serviceInfo;

  ServerConfig copyWith({
    bool? deviceBindingEnabled,
    ServiceInfo? serviceInfo,
  }) =>
      ServerConfig(
        deviceBindingEnabled: deviceBindingEnabled ?? this.deviceBindingEnabled,
        serviceInfo: serviceInfo ?? this.serviceInfo,
      );

  factory ServerConfig.fromJson(Map<String, dynamic> json) => ServerConfig(
    deviceBindingEnabled: json["deviceBindingEnabled"],
    serviceInfo: json["serviceInfo"] == null ? null : ServiceInfo.fromJson(json["serviceInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "deviceBindingEnabled": deviceBindingEnabled,
    "serviceInfo": serviceInfo?.toJson(),
  };
}

class ServiceInfo {
  ServiceInfo({
    this.isServiceAvailable,
    this.notificationMessageBn,
    this.notificationMessageEn,
  });

  bool? isServiceAvailable;
  String? notificationMessageBn;
  String? notificationMessageEn;

  ServiceInfo copyWith({
    bool? isServiceAvailable,
    String? notificationMessageBn,
    String? notificationMessageEn,
  }) =>
      ServiceInfo(
        isServiceAvailable: isServiceAvailable ?? this.isServiceAvailable,
        notificationMessageBn: notificationMessageBn ?? this.notificationMessageBn,
        notificationMessageEn: notificationMessageEn ?? this.notificationMessageEn,
      );

  factory ServiceInfo.fromJson(Map<String, dynamic> json) => ServiceInfo(
    isServiceAvailable: json["isServiceAvailable"],
    notificationMessageBn: json["notificationMessageBn"],
    notificationMessageEn: json["notificationMessageEn"],
  );

  Map<String, dynamic> toJson() => {
    "isServiceAvailable": isServiceAvailable,
    "notificationMessageBn": notificationMessageBn,
    "notificationMessageEn": notificationMessageEn,
  };
}
