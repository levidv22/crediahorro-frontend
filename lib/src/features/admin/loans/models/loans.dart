class Cuota {
  final int id;
  final String fechaPago;
  final double montoCuota;
  final double capital;
  final double interes;
  final String estado;
  final String tipoPago;
  final String? fechaPagada;

  Cuota({
    required this.id,
    required this.fechaPago,
    required this.montoCuota,
    required this.capital,
    required this.interes,
    required this.estado,
    required this.tipoPago,
    this.fechaPagada,
  });

  factory Cuota.fromJson(Map<String, dynamic> json) {
    return Cuota(
      id: json['id'] ?? 0,
      fechaPago: json['fechaPago'] ?? "",
      montoCuota: (json['montoCuota'] as num?)?.toDouble() ?? 0.0,
      capital: (json['capital'] as num?)?.toDouble() ?? 0.0,
      interes: (json['interes'] as num?)?.toDouble() ?? 0.0,
      estado: json['estado'] ?? "PENDIENTE",
      tipoPago: json['tipoPago'] ?? "NO_DEFINIDO",
      fechaPagada: json['fechaPagada'],
    );
  }
}

class Prestamo {
  final int? id;
  double monto;
  double tasaInteresMensual;
  int numeroCuotas;
  String tipoCuota;
  String fechaInicio;
  String? estado;
  String fechaCreacion;
  List<Cuota>? cuotas;

  Prestamo({
    this.id,
    required this.monto,
    required this.tasaInteresMensual,
    required this.numeroCuotas,
    required this.tipoCuota,
    required this.fechaInicio,
    this.estado,
    required this.fechaCreacion,
    this.cuotas,
  });

  factory Prestamo.fromJson(Map<String, dynamic> json) {
    return Prestamo(
      id: json['id'],
      monto: (json['monto'] as num).toDouble(),
      tasaInteresMensual: (json['tasaInteresMensual'] as num).toDouble(),
      numeroCuotas: json['numeroCuotas'],
      tipoCuota: json['tipoCuota'],
      fechaInicio: json['fechaInicio'],
      estado: json['estado'],
      fechaCreacion: json['fechaCreacion'],
      cuotas: json['cuotas'] != null
          ? (json['cuotas'] as List).map((c) => Cuota.fromJson(c)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "monto": monto,
    "tasaInteresMensual": tasaInteresMensual,
    "numeroCuotas": numeroCuotas,
    "tipoCuota": tipoCuota,
    "fechaInicio": fechaInicio,
    "estado": estado,
    "fechaCreacion": fechaCreacion,
  };
}
