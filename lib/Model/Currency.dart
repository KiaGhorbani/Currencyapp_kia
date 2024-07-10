// ignore_for_file: file_names, empty_constructor_bodies

class Currency {
  String? id;
  String? title;
  String? price;
  String? changes;
  String? status;

  Currency(
      {required this.id,
      required this.title,
      required this.price,
      required this.changes,
      required this.status});
}
