class Cuota {
  final int id;
  final String? fechaPago;
  final double montoCuota;
  final double capital;
  final double interes;
  final String? estado;
  final String? tipoPago;
  final String? fechaPagada;

  Cuota({
    required this.id,
    this.fechaPago,
    required this.montoCuota,
    required this.capital,
    required this.interes,
    this.estado,
    this.tipoPago,
    this.fechaPagada,
  });

  factory Cuota.fromJson(Map<String, dynamic> json) {
    return Cuota(
      id: json['id'] ?? 0,
      fechaPago: json['fechaPago'],
      montoCuota: (json['montoCuota'] ?? 0).toDouble(),
      capital: (json['capital'] ?? 0).toDouble(),
      interes: (json['interes'] ?? 0).toDouble(),
      estado: json['estado'],
      tipoPago: json['tipoPago'],
      fechaPagada: json['fechaPagada'],
    );
  }
}

class PrestamoCuotasResponse {
  final int prestamoId;
  final String? tipoCuota;
  final List<Cuota> cuotas;
  final int cuotasPendientes;

  PrestamoCuotasResponse({
    required this.prestamoId,
    this.tipoCuota,
    required this.cuotas,
    required this.cuotasPendientes,
  });

  factory PrestamoCuotasResponse.fromJson(Map<String, dynamic> json) {
    return PrestamoCuotasResponse(
      prestamoId: json['prestamoId'],
      tipoCuota: json['tipoCuota'],
      cuotas: (json['cuotas'] as List).map((c) => Cuota.fromJson(c)).toList(),
      cuotasPendientes: json['cuotasPendientes'],
    );
  }
}
