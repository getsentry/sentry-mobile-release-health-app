class Organization {
  Organization.fromJson(dynamic json)
      : id = json['id'] as String,
        name = json['name'] as String,
        slug = json['slug'] as String;

  final String id;
  final String name;
  final String slug;
}