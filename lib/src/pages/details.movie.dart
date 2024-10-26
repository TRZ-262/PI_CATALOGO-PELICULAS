import 'package:welcome_to_flutter/src/providers/movies_provider.dart';
import 'package:welcome_to_flutter/src/utils/colors.dart';
import 'package:welcome_to_flutter/src/utils/dark_mode_extension.dart';
import 'package:welcome_to_flutter/src/widgets/circularprogress_widget.dart';
import 'package:welcome_to_flutter/src/widgets/input_decoration_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarteleraScreen extends StatefulWidget {
  final dynamic userData;
  const CarteleraScreen({super.key, this.userData});

  @override
  State<CarteleraScreen> createState() => _CarteleraScreenState();
}

class _CarteleraScreenState extends State<CarteleraScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // SE MUESTRAN MÁS PELICULAS CUANDO SE LLEGA AL FINAL DE LA LISTA
        Provider.of<MoviesProvider>(context, listen: false)
            .getComingSoonMovies();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void handleSearch(String query) {
    if (query.isNotEmpty) {
      Provider.of<MoviesProvider>(context, listen: false)
          .searchMovies(query)
          .then((searchResults) {
        setState(() {
          // ACTUALIZACIÓN DE LA LISTA DE PELICULAS CON LA BÚSQUEDA
          // SI NO HAY RESULTADOS NO SE MUESTRA NADA
          _isSearching = true;
          scrollController.jumpTo(0); // REGRESA AL PRINCIPIO DE LA LISTA
        });
      });
    } else {
      setState(() {
        // SE MUESTRAN TODAS LAS PRÓXIMAS PELÍCULAS; SI EL CAMPO SE ENCUENTRA VACIO
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.isDarkMode;
    final moviesProvider = Provider.of<MoviesProvider>(context);
    // SE FILTRAN LAS PELÍCULAS QUE TIENEN IMAGEN
    final moviesWithImage = _isSearching
        ? moviesProvider.searchedMovies
            .where((movie) => movie.posterPath != null)
            .toList()
        : moviesProvider.comingSoonMovies
            .where((movie) => movie.posterPath != null)
            .toList();

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkColor : AppColors.lightColor,
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PRONTO EN CINES',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.lightColor
                          : AppColors.darkColor,
                      fontSize: 20,
                      fontFamily: "CB",
                    ),
                  ),
                  IconButton(
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        //PONER EL SCROLL AL INICIO
                        scrollController.jumpTo(0);
                      });
                    },
                    icon: Icon(
                      _isSearching ? Icons.close : Icons.search,
                      color: isDarkMode
                          ? AppColors.lightColor
                          : AppColors.darkColor,
                    ),
                  ),
                ],
              ),
            ),
            if (_isSearching) const SizedBox(height: 10),
            if (_isSearching)
              //BUSCADOR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputDecorationWidget(
                  borderRadius: BorderRadius.circular(100),
                  color: isDarkMode
                      ? AppColors.lightColor
                      : AppColors.darkColor.withOpacity(0.5),
                  hintText: 'Buscar película',
                  controller: searchController,
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      handleSearch('');
                      //PONER SCROLL AL INICIO
                      scrollController.jumpTo(0);
                    },
                    icon: searchController.text.isEmpty
                        ? const Icon(Icons.search)
                        : const Icon(Icons.close),
                  ),
                  onChanged: (value) => handleSearch(value),
                ),
              ),
            const SizedBox(height: 10),
            if (moviesWithImage.isEmpty && _isSearching)
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'NO SE ENCONTRARON PELICULAS CON ESE NOMBRE',
                      style: TextStyle(
                        color: AppColors.darkColor,
                        fontSize: 18,
                        fontFamily: "CB",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: moviesWithImage.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  if (index == moviesWithImage.length) {
                    // ÚLTIMO ÍNDICE, MOSTRAR MENSAJE DE CARGA
                    if (!_isSearching) return _buildLoadingIndicator();
                    return const SizedBox.shrink();
                  } else {
                    //SE MUESTRAN LAS PELICULAS QUE TENGAN IMAGEN
                    final movie = moviesWithImage[index];

                    movie.heroId = 'cartelera-${movie.id}';
                    return GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, '/detalle',
                        //     arguments: movie);
                        Navigator.pushNamed(
                          context,
                          "/detalle",
                          arguments: {
                            'movie': movie,
                            'userData': widget.userData,
                          },
                        );
                      },
                      child: Hero(
                        tag: movie.heroId!,
                        child: Card(
                          elevation: 15,
                          shadowColor: isDarkMode
                              ? AppColors.lightColor.withOpacity(0.6)
                              : AppColors.darkAcentsColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FadeInImage(
                              placeholder:
                                  const AssetImage('assets/gif/vertical.gif'),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return const Image(
                                  image:
                                      AssetImage("assets/images/noimage.png"),
                                  fit: BoxFit.cover,
                                );
                              },
                              image: NetworkImage(movie.fullPosterImg),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.center,
      child: const CircularProgressWidget(text: "CARGANDO..."),
    );
  }
}
