class OrderTypeHelper {
  static const orderTypeList = [1, 2, 3];

  static String orderTypeToLabel(int orderTypeStatus) {
    switch (orderTypeStatus) {
      case 1:
        return 'Bawa Pulang';
      case 2:
        return 'Pesan Antar';
      case 3:
        return 'Makan Di Tempat';
      default:
        return 'Undefined';
    }
  }
}
