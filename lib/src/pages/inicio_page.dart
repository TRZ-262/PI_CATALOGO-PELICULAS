import 'package:welcome_to_flutter/src/pages/account/profile_page.dart';
import 'package:welcome_to_flutter/src/pages/cartelera_screen.dart';
import 'package:welcome_to_flutter/src/pages/mis_compras.dart';
import 'package:welcome_to_flutter/src/pages/home_screen.dart';
import 'package:welcome_to_flutter/src/pages/ofertas_page.dart';
import 'package:welcome_to_flutter/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';

class InicioPage extends StatefulWidget {
  final dynamic userData;
  const InicioPage({Key? key, this.userData}) : super(key: key);

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(userData: widget.userData),
      CarteleraScreen(userData: widget.userData),
      OfertasPage(userData: widget.userData),
      MisComprasPage(userData: widget.userData),
      ProfilePage(userData: widget.userData),
    ];

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: AppColors.darkColor,
              title: const Text(
                '¿Está seguro que desea salir de la App?',
                style: TextStyle(
                    fontFamily: "CB",
                    color: AppColors.text,
                    letterSpacing: 0.5),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: AppColors.deepOrange,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'No',
                        style: TextStyle(
                            fontFamily: "CB",
                            color: AppColors.text,
                            fontSize: 17),
                      ),
                    ),
                    const SizedBox(width: 20),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: AppColors.acentColor,
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        // CERRAR POR COMPLETO LA APLICACIÓN
                        SystemNavigator.pop();
                      },
                      child: const Text(
                        'Sí',
                        style: TextStyle(
                            fontFamily: "CB",
                            color: AppColors.text,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            );
          },
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          height: 65.0,
          items: const <Widget>[
            Icon(Icons.home_rounded, size: 30, color: AppColors.darkColor),
            Icon(Icons.movie_filter_sharp,
                size: 30, color: AppColors.darkColor),
            Icon(Icons.local_offer_rounded,
                size: 30, color: AppColors.darkColor),
            Icon(Icons.shopify_sharp, size: 30, color: AppColors.darkColor),
            Icon(Icons.person_2_rounded, size: 30, color: AppColors.darkColor),
          ],
          color: AppColors.lightColor,
          buttonBackgroundColor: AppColors.lightColor,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        body: pages[_currentIndex],
      ),
    );
  }
}
