import 'package:crediahorro/src/services/LoanService.dart';
import 'package:crediahorro/src/services/UsuariosService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crediahorro/src/common_widgets/profile_avatar.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:crediahorro/src/common_widgets/role_scaffold_builder.dart';

class ProfileOverviewPage extends StatefulWidget {
  const ProfileOverviewPage({super.key});

  @override
  State<ProfileOverviewPage> createState() => _ProfileOverviewPageState();
}

class _ProfileOverviewPageState extends State<ProfileOverviewPage> {
  final UsuariosService _usuariosService = UsuariosService();
  final LoanService _loanService = LoanService();
  int _prestamosPagados = 0;
  int _prestamosActivos = 0;
  bool _cargando = true;
  String? _profileImagePath;
  String _username = "Usuario";
  String _role = "";
  String _profileName = "";

  @override
  void initState() {
    super.initState();
    _loadProfileData().then((_) => _loadPrestamosData());
  }

  Future<void> _loadPrestamosData() async {
    setState(() => _cargando = true);
    try {
      if (_role == "USUARIO") {
        // Cliente → usa UsuariosService
        final conteo = await _usuariosService.contarPrestamosPorEstado();
        setState(() {
          _prestamosPagados = conteo['pagados'] ?? 0;
          _prestamosActivos = conteo['activos'] ?? 0;
        });
      } else if (_role.isEmpty) {
        // Admin → usa LoanService
        final conteo = await _loadPrestamosAdminData();
        setState(() {
          _prestamosPagados = conteo['pagados'] ?? 0;
          _prestamosActivos = conteo['activos'] ?? 0;
        });
      }
    } catch (e) {
      print("Error cargando préstamos: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<Map<String, int>> _loadPrestamosAdminData() async {
    final data = await _loanService.obtenerTodosLosPrestamos();
    int pagados = 0;
    int activos = 0;

    for (var e in data) {
      final estado = (e['estado'] ?? '').toString().toUpperCase();
      if (estado == 'PAGADO') pagados++;
      if (estado == 'ACTIVO') activos++;
    }

    return {"pagados": pagados, "activos": activos};
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    String username = "Usuario";
    String role = "";

    if (token != null) {
      final decoded = JwtDecoder.decode(token);
      username = decoded["sub"] ?? "Usuario";
      role = decoded["role"] ?? "";
    }

    setState(() {
      _profileImagePath = prefs.getString('profile_image');
      _username = username;
      _role = role;
      _profileName = prefs.getString('profile_name') ?? username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildRoleBasedScaffold(
      role: _role,
      title: "CREDIAHORRO",
      viewName: "profile",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProfileAvatar(
              imagePath: _profileImagePath,
              size: 120,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.perfil,
                ).then((_) => _loadProfileData());
              },
            ),
            const SizedBox(height: 15),
            Text(
              "Hola $_profileName",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Espero que logres tu meta, sé que tienes lo necesario para alcanzarla. "
              "¡Confía en ti y sigue avanzando, lo vas a conseguir!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.perfil,
                ).then((_) => _loadProfileData());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
                foregroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Editar perfil"),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Resumen de Préstamos",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    value: _prestamosPagados.toString(),
                    label: "Préstamos pagados",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    value: _prestamosActivos.toString(),
                    label: "Préstamos pendientes",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            _cargando
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade50, Colors.blue.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Estado de tus préstamos",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 30),

                        SizedBox(
                          height: 220,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              PieChart(
                                PieChartData(
                                  sectionsSpace: 3,
                                  centerSpaceRadius: 60,
                                  startDegreeOffset: -90,
                                  sections: [
                                    PieChartSectionData(
                                      color: Colors.green.shade400,
                                      value: _prestamosPagados.toDouble(),
                                      title:
                                          "${_prestamosPagados > 0 ? ((_prestamosPagados / (_prestamosPagados + _prestamosActivos)) * 100).toStringAsFixed(1) : 0}%",
                                      radius: 70,
                                      titleStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    PieChartSectionData(
                                      color: Colors.orange.shade400,
                                      value: _prestamosActivos.toDouble(),
                                      title:
                                          "${_prestamosActivos > 0 ? ((_prestamosActivos / (_prestamosPagados + _prestamosActivos)) * 100).toStringAsFixed(1) : 0}%",
                                      radius: 70,
                                      titleStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "${_prestamosPagados + _prestamosActivos}",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildLegendItem(
                              Colors.orange.shade400,
                              "Pendientes",
                              _prestamosActivos,
                            ),
                            _buildLegendItem(
                              Colors.green.shade400,
                              "Pagados",
                              _prestamosPagados,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLegendItem(Color color, String label, int value) {
  return Row(
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        "$label: $value",
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    ],
  );
}

class _InfoCard extends StatelessWidget {
  final String value;
  final String label;

  const _InfoCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
