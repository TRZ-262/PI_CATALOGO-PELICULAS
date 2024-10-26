class Validators {
  //CORREO O NOMBRE DE USUARIO
  static String? emailUsernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'INGRESAR CORREO O USUARIO';
    }
    if (value.contains(' ')) {
      return "EL CORREO NO DEBE CONTENER ESPACIOS";
    }
    return null;
  }

  // PARA VALIDAR EMAIL
  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'INGRESAR CORREO';
    }
    if (!value.contains('@')) {
      return "EL CORREO DEBE CONTENER '@'";
    }
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value)) {
      return "INGRESAR UN CORREO VÁLIDO";
    }
    if (value.contains(' ')) {
      return "EL CORREO NO DEBE CONTENER ESPACIOS";
    }
    return null;
  }

  //PARA VALIDAR CONTRASEÑA
  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'CONTRASEÑA OBLIGATORIA';
    }
    if (value.length < 8) {
      return 'LA CONTRASEÑA DEBE TENER 8 CARACTERES';
    }
    if (value.contains(' ')) {
      return "LA CONTRASEÑA NO DEBE DE TENER ESPACIOS";
    }
    return null;
  }

  //PARA VALIDAR NOMBRE DE USUARIO
  static String? validateUsername(String? value) {
    if (value!.isEmpty) {
      return 'NOMBRE DE USUARIO OBLIGATORIO';
    }
    if (value.contains(' ')) {
      return "EL NOMBRE DE USUARIO NO DEBE CONTENER ESPACIOS";
    }

    //el nombre de usuario tiene que tener maximo 15 caracteres
    if (value.length > 15) {
      return 'EL NOMBRE DE USUARIO DEBE TENER MÁS DE 15 CARACTERES';
    }

    return null;
  }

  //VALIDAR FECHA DE NACIMIENTO

//FECHA DE NACIMIENTO
  static String? birthValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese tu fecha de nacimiento';
    }

    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateRegex.hasMatch(value)) {
      return 'Ingrese una fecha válida en formato DD/MM/AAAA';
    }

    final parts = value.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return 'Ingrese una fecha válida en formato DD/MM/AAAA';
    }

    if (day < 1 || day > 31) {
      return 'El día debe estar entre 1 y 31';
    }

    if (month < 1 || month > 12) {
      return 'El mes debe estar entre 1 y 12';
    }

    if (year < 1900 || year > DateTime.now().year) {
      return 'Ingresar  año válido';
    }

    //Mayoria de edad
    DateTime birthDate = DateTime(year, month, day);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (birthDate.isAfter(today)) {
      return 'La fecha de nacimiento no puede ser posterior a la fecha actual';
    } else if (birthDate
        .isAfter(today.subtract(const Duration(days: 365 * 18)))) {
      return 'TENER 18 AÑOS PARA REGISTRARTE';
    }

    return null;
  }
}
