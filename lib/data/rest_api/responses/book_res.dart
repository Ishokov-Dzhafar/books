
class BookRes {
  String description;
  int id;
  String preview;
  int price;
  String title;

  BookRes({this.description, this.id, this.preview, this.price, this.title});

  BookRes.fromJson(Map<String, dynamic> json) {
    description = json['discription'];
    id = json['id'];
    preview = json['preview'];
    price = json['price'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discription'] = this.description;
    data['id'] = this.id;
    data['preview'] = this.preview;
    data['price'] = this.price;
    data['title'] = this.title;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BookRes &&
              runtimeType == other.runtimeType &&
              description == other.description &&
              id == other.id &&
              preview == other.preview &&
              price == other.price &&
              title == other.title;

  @override
  int get hashCode =>
      description.hashCode ^
      id.hashCode ^
      preview.hashCode ^
      price.hashCode ^
      title.hashCode;

}