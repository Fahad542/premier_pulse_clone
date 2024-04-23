class DsfMeasureModel {
  final int dsfDsfCode;
  final String dsfDsfName;
  final String dsfSafBusinessLine;
  final int safCustomer;
  final int? productiveCustomer;
  final String ecoPercentage;
  final int? firstOrder;
  final int? lastOrder;
  final int? duration;
  final int? orderQuantity;
  final double? orderValue;
  final double? avgValuePerBill;
  final double? avgSkuPerBill;
  final int? DSFTargetDaysDSFRemaining;
  final int? DSFTargetDaysDSFWorked;

  DsfMeasureModel({
    required this.dsfDsfCode,
    required this.dsfDsfName,
    required this.dsfSafBusinessLine,
    required this.safCustomer,
    this.productiveCustomer,
    required this.ecoPercentage,
    this.firstOrder,
    this.lastOrder,
    this.duration,
    this.orderQuantity,
    this.orderValue,
    this.avgValuePerBill,
    this.avgSkuPerBill,
    this.DSFTargetDaysDSFRemaining,
    this.DSFTargetDaysDSFWorked
  });

  factory DsfMeasureModel.fromJson(Map<String, dynamic> json) {
    return DsfMeasureModel(
      dsfDsfCode: json['DSF_DSF_Code'],
      dsfDsfName: json['DSF_DSF_Name'],
      dsfSafBusinessLine: json['DSF_SAF_Business_Line'],
      safCustomer: json['SAF_Customer'],
      productiveCustomer: json['Productive_Customer'],
      ecoPercentage: json['ECO%'],
      firstOrder: json['First_Order'],
      lastOrder: json['Last_Order'],
      duration: json['Duration'],
      orderQuantity: json['Order_Quantity'],
      orderValue: json['Order_Value'],
      avgValuePerBill: json['Avg_Value_Per_Bill'],
      avgSkuPerBill: json['Avg_SKU_Per_Bill'],
      DSFTargetDaysDSFRemaining: json['DSFTarget_Days_DSF_Remaining'],
      DSFTargetDaysDSFWorked: json['DSFTarget_Days_DSF_Worked']
    );
  }
}
