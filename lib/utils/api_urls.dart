class ApiUrls {
  static const baseUrl = "http://103.36.101.99:8080/api_middleware-0.0.1-DEV/";

  static const String appForceUpdateWithConfig = "get-service-config";
  static const String loginApi = "login";
  static const String getBannersApi = "getBanners";
  static const String featureListApi = "feature-list";
  static const String checkBalanceApi = "wallet/check-balance";
  static const String apiGetWallet = "wallet/get-wallet";
  static const String checkDevice = "check-device";
  static const String validateOtp = "device-validate-otp";
  static const String sendMoneyApi = "p2p";
  static const String changePinApi = "update_pin";
  static const String cashOutApi = "customer/cash_out";
  static const String merchantPayApi = "merchant_payment";
  static const String mobileRechargeApi = "top_up";
  static const String instituteList = "school-fees/institute-list";
  static const String schoolFees = "school-fees/bill-info";
  static const String schoolPayment = "school-fees/payment";
  static const String checkUserTypeApi = "user_type";
  static const String feeChargeApi = "fee_charge";
  static const String topUpApiSecretKey = "65723984723680723984";
  static const String txnList = "mini_statement";
  static const String ekycUploadNid = "ekyc/nid-upload";
  static const String ekycVerify = "/ekyc/verify";
  static const String ekycStatus = "ekyc/status";
  static const String ekycUpdateUser = "ekyc/update-data";
  static const String otpRegGenerate = "registration-generate-otp";
  static const String otpRegValidate = "registration-validate-otp";
  static const String geoDivision = "api/address/division-list";
  static const String geoDistrict = "api/address/district-list";
  static const String geoThana = "api/address/thana-list";
  static const String generateQrCodeApi = "qr/generate/agent-or-customer";
  static const String addMoneyInfo = "api/ssl-add-money/get-addmoney-info";


  static const String agentCashOut = "agent/cash-out";
  static const String getDisInfoByAgent = "get-distributor-info-by-agent";
  static const String agentCashIn = "agent/cash-in";
  static const String customerRegByAgentApi = "create-wallet-without-kyc";

  // dynamic utility
  static const String duDetail = "api/utility/detail";
  static const String duBillInfo = "api/utility/bill-info";
  static const String duBillPayment = "/api/utility/bill-payment";
  static const String duServiceList = "/api/utility/feature-list";


  static const String getAgentListApi = "distributor/get-agent-list";
  static const String topUpAgentApi = "distributor/cash_in";
  static const String getDsrLimitInfo = "distributor/get-dsr-limit-info";
  static const String getNearestAgent = "api/agent-locator/get-nearest-agent";
  static const String updateAgentLocator = "api/agent-locator/update-agent-location";


  static const String transactionApi = "api/backoffice/transactions";


  // request money
  static const String makeRequestApi = "/api/request-money/make-request";
  static const String getAllRequestsApi = "/api/request-money/get-all-requests";
  static const String payMoneyApi = "/api/request-money/pay";
  static const String declineMoneyApi = "/api/request-money/decline";

}
