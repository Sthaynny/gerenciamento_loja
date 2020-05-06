class ProductValidator {
  String validateImage(List value) {
    if (value.isEmpty) {
      return "Adicione imagens do produto!";
    }
    return null;
  }

  String validateTile(String value) {
    if (value.isEmpty) {
      return "Preencha o titulo do produto";
    }
    return null;
  }

  String validateDescription(String value) {
    if (value.isEmpty) {
      return "Preencha a descrição do produto";
    }
    return null;
  }

  String validatePrice(String value) {
    double price = double.tryParse(value);
    if (price != null) {
      if (!value.contains(".") || value.split('.')[1].length != 2) {
        return "Utilize 2 casas decimais!";
      }
    } else {
      return "Preço invalido";
    }
    return null;
  }
}
