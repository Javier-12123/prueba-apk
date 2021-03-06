import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grupoLias/Cotizaciones/model/cotizacion.model.dart';
import 'package:grupoLias/Cotizaciones/service/cotizaciones.service.dart';
import 'package:grupoLias/Cotizaciones/ui/screens/aprobacion-cotizacion.screen.dart';

class TusTicketsScreen extends StatefulWidget {
  const TusTicketsScreen({Key? key}) : super(key: key);

  @override
  State<TusTicketsScreen> createState() => _TusTicketsScreenState();
}

class _TusTicketsScreenState extends State<TusTicketsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus Tickets'),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Cotizacion>>(
        future: CotizacionesService().cotizacionesByTecnico(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Cotizacion>? cotizaciones = snapshot.data;
            List<Widget> list = [];

            cotizaciones?.forEach((cot) {
              list.add(
                Card(
                  child: ListTile(
                    title: Text(cot.id.toString()),
                    subtitle: Text(cot.diagnosticoProblema.toString()),
                    onTap: () {
                      Get.to(AprobacionCotizacion(cotizacion: cot));
                    },
                  ),
                ),
              );
            });

            return list.isEmpty
                ? const Center(
                    child: Text('No hay tickets'),
                  )
                : ListView(
                    children: list,
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
