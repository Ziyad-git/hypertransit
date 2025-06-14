class MyOrder {
  String id;
  String name;
  double latitude;
  double longitude;

  MyOrder({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory MyOrder.fromJson(Map<String, dynamic> json) => MyOrder(
    id: json["id"],
    name: json["name"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "latitude": latitude,
    "longitude": longitude,
  };
}
