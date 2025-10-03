class Cuota {
  final int? id;
  final String fechaPago;
  final double montoCuota;
  final double capital;
  final double interes;
  final String estado;
  final String tipoPago;
  final String? fechaPagada;
  final double? montoPagado;

  Cuota({
    this.id,
    required this.fechaPago,
    required this.montoCuota,
    required this.capital,
    required this.interes,
    required this.estado,
    required this.tipoPago,
    this.fechaPagada,
    this.montoPagado,
  });

  factory Cuota.fromJson(Map<String, dynamic> json) => Cuota(
    id: json['id'],
    fechaPago: json['fechaPago'] ?? '',
    montoCuota: (json['montoCuota'] ?? 0).toDouble(),
    capital: (json['capital'] ?? 0).toDouble(),
    interes: (json['interes'] ?? 0).toDouble(),
    estado: json['estado'] ?? '',
    tipoPago: json['tipoPago'] ?? '',
    fechaPagada: json['fechaPagada'],
    montoPagado: (json['montoPagado'] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fechaPago": fechaPago,
    "montoCuota": montoCuota,
    "capital": capital,
    "interes": interes,
    "estado": estado,
    "tipoPago": tipoPago,
    "fechaPagada": fechaPagada,
    "montoPagado": montoPagado,
  };
}

class Prestamo {
  final int? id;
  final double monto;
  final double tasaInteresMensual;
  final int numeroCuotas;
  final String tipoCuota;
  final String fechaInicio;
  final String? estado;
  final String fechaCreacion;
  final List<Cuota>? cuotas;

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

  factory Prestamo.fromJson(Map<String, dynamic> json) => Prestamo(
    id: json['id'],
    monto: (json['monto'] ?? 0).toDouble(),
    tasaInteresMensual: (json['tasaInteresMensual'] ?? 0).toDouble(),
    numeroCuotas: json['numeroCuotas'] ?? 0,
    tipoCuota: json['tipoCuota'] ?? 'MENSUAL',
    fechaInicio: json['fechaInicio'] ?? '',
    estado: json['estado'],
    fechaCreacion: json['fechaCreacion'] ?? '',
    cuotas: json['cuotas'] != null
        ? (json['cuotas'] as List).map((e) => Cuota.fromJson(e)).toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "monto": monto,
    "tasaInteresMensual": tasaInteresMensual,
    "numeroCuotas": numeroCuotas,
    "tipoCuota": tipoCuota,
    "fechaInicio": fechaInicio,
    "estado": estado,
    "fechaCreacion": fechaCreacion,
    "cuotas": cuotas?.map((e) => e.toJson()).toList(),
  };
}
