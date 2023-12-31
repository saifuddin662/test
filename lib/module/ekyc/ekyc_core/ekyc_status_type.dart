enum EkycStatus {
  ACTIVE("ACTIVE"),
  NEW("NEW"),
  PARTIAL("PARTIALLY_COMPLETED"),
  INCOMPLETE("INCOMPLETE"),
  SUBMITTED("SUBMITTED"),
  FAILED("FAILED"),
  INVALID("INVALID"),
  PENDING("PENDING"),
  WALLET_CREATION_FAILED("WALLET_CREATION_FAILED"),;

  const EkycStatus(this.name);

  final String name;
}
