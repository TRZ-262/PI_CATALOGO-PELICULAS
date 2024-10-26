import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:welcome_to_flutter/src/utils/colors.dart';
import 'package:welcome_to_flutter/src/utils/dark_mode_extension.dart';
import 'package:welcome_to_flutter/src/widgets/circularprogress_widget.dart';
import 'package:welcome_to_flutter/src/widgets/richi_icon_widget.dart';
import 'package:welcome_to_flutter/src/widgets/row_price_details.dart';
import 'package:flutter/material.dart';

class MisComprasPage extends StatefulWidget {
  final dynamic userData;
  const MisComprasPage({Key? key, this.userData}) : super(key: key);

  @override
  State<MisComprasPage> createState() => _MisComprasPageState();
}

class _MisComprasPageState extends State<MisComprasPage> {
  Future<List<Map<String, dynamic>>> leerCompras() async {
    try {
      // REFERENCIA PARA "COMPRAS"
      CollectionReference comprasCollection =
          FirebaseFirestore.instance.collection('compras');

      // CONSULTA PARA OBTENER SÓLO LAS COMPRAS HECHAS POR EL USUARIO
      QuerySnapshot querySnapshot = await comprasCollection
          .where('id_usuario', isEqualTo: widget.userData['id'])
          .orderBy('created_at', descending: true)
          .get();

      // LISTA VACIA PARA ALMACENAR COMPRAS
      List<Map<String, dynamic>> compras = [];

      // ITERACIÓN SOBRE LOS DOCUMENTOS Y SE AGREGAN LOS DATOS A LA LISTA
      querySnapshot.docs.forEach((doc) {
        // CONVERTIR DATOS A Map<String, dynamic>
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        // VERIFICAR QUE LOS DATOS NO SEAN NUELOS ANTES DE AGREGARLOS
        if (data != null) {
          compras.add(data);
        }
      });

      // RREGRESAR A LISTA DE COMPRAS
      return compras;
    } catch (e) {
      print('Error al leer las compras: $e');
      return []; // REGRESAR A UNA LISTA VACIA EN CASO DE ERROR
    }
  }

  //ACTUALIZA PÁGINA
  Future<void> onRefresh() async {
    //2 SEGUNDOS DE ESPERA
    await Future.delayed(const Duration(seconds: 2));
    //ACTUALIZAR PÁGINA
    setState(() {
      leerCompras();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.isDarkMode;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: leerCompras(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> compras = snapshot.data!;
              return Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'Mis Compras',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "CB",
                            color: isDarkMode
                                ? AppColors.text
                                : AppColors.darkColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.shopping_cart,
                        color: isDarkMode
                            ? AppColors.lightColor
                            : AppColors.darkColor,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: compras.length,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final comp = compras[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 15,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: FadeInImage(
                                      height: 100,
                                      placeholder: const AssetImage(
                                          'assets/gif/vertical.gif'),
                                      image: NetworkImage(
                                        comp['posterPelicula'],
                                      ),
                                      imageErrorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        return Image.asset(
                                            'assets/images/noimage.png');
                                      },
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Película: ${compras[index]['nombrePelicula']}",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: isDarkMode
                                                ? AppColors.lightColor
                                                : AppColors.darkColor,
                                            fontFamily: "CB",
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        RichiIconTextWidget(
                                          icon: Icons.calendar_month_outlined,
                                          isDarkMode: isDarkMode,
                                          text: compras[index]['fechaCine'],
                                        ),
                                        RichiIconTextWidget(
                                          icon: Icons.access_time,
                                          isDarkMode: isDarkMode,
                                          text: compras[index]['horaCine'],
                                        ),
                                        RichiIconTextWidget(
                                          icon: Icons.event_seat,
                                          isDarkMode: isDarkMode,
                                          text: compras[index]['butacas']
                                              .map((seat) => 'B$seat')
                                              .join(', '),
                                        ),
                                        RowPriceDetails(
                                          icon: Icons.confirmation_num_rounded,
                                          text: 'Entradas: ',
                                          price:
                                              'S/ ${compras[index]['precioEntradas'].toStringAsFixed(2)}',
                                          isDarkMode: isDarkMode,
                                        ),
                                        RowPriceDetails(
                                          icon: Icons.shopping_cart_outlined,
                                          text: 'Productos: ',
                                          price:
                                              'S/ ${compras[index]['precioProductos'].toStringAsFixed(2)}',
                                          isDarkMode: isDarkMode,
                                        ),
                                        RowPriceDetails(
                                          icon: Icons.monetization_on_outlined,
                                          text: 'Total: ',
                                          price:
                                              'S/ ${compras[index]['precioTotal'].toStringAsFixed(2)}',
                                          isDarkMode: isDarkMode,
                                        ),
                                        //cine
                                        RichiIconTextWidget(
                                          icon: Icons.location_on,
                                          isDarkMode: isDarkMode,
                                          text:
                                              "CineWarriors - ${compras[index]['selectedCity']}",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressWidget(
                text: "Cargando...",
              ),
            );
          },
        ),
      ),
    );
  }
}
