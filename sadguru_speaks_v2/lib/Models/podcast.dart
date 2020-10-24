class Podcast {
  String name;
  String url;
  String photo;

  Podcast({this.name, this.url, this.photo});

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
        name: json["name"],
        url: json["url"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        //"photo":photo
      };
}
