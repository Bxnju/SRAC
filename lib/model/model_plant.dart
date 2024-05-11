class Plant{
  final int id;
  final String name;
  String? actualHumidity;
  String? requiredHumidity; 
  String? specie;
  String? family;
  String? requirements;
  String? description;

  Plant({
    required this.id,
    required this.name,
    this.actualHumidity,
    this.requiredHumidity,
    this.specie,
    this.family,
    this.requirements,
    this.description
  });
}