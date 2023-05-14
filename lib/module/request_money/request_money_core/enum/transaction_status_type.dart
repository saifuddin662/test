enum TransactionStatusType{
  Pending("Pending"),
  Processed("Processed"),
  Declined("Declined"),;

  const TransactionStatusType(this.name);

  final String name;
}