
/**
 * Created by Md. Awon-Uz-Zaman on 25/February/2023
 */

class GetTransactionIdResponse {
  double? amount;
  String? ipnUrl;
  String? storeId;
  String? storePassword;
  String? tranId;

  GetTransactionIdResponse(
      {this.amount,
        this.ipnUrl,
        this.storeId,
        this.storePassword,
        this.tranId});

  GetTransactionIdResponse.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    ipnUrl = json['ipnUrl'];
    storeId = json['storeId'];
    storePassword = json['storePassword'];
    tranId = json['tranId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['ipnUrl'] = ipnUrl;
    data['storeId'] = storeId;
    data['storePassword'] = storePassword;
    data['tranId'] = tranId;
    return data;
  }
}