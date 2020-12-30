class QtzModel {
  int page;
  bool lastPage;
  List<Quotes> quotes;

  QtzModel({this.page, this.lastPage, this.quotes});

  QtzModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    lastPage = json['last_page'];
    if (json['quotes'] != null) {
      quotes = new List<Quotes>();
      json['quotes'].forEach((v) {
        quotes.add(new Quotes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['last_page'] = this.lastPage;
    if (this.quotes != null) {
      data['quotes'] = this.quotes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Quotes {
  int id;
  bool dialogue;
  bool private;
  List<String> tags;
  String url;
  int favoritesCount;
  int upvotesCount;
  int downvotesCount;
  String author;
  String authorPermalink;
  String body;

  Quotes(
      {this.id,
      this.dialogue,
      this.private,
      this.tags,
      this.url,
      this.favoritesCount,
      this.upvotesCount,
      this.downvotesCount,
      this.author,
      this.authorPermalink,
      this.body});

  Quotes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dialogue = json['dialogue'];
    private = json['private'];
    tags = json['tags'].cast<String>();
    url = json['url'];
    favoritesCount = json['favorites_count'];
    upvotesCount = json['upvotes_count'];
    downvotesCount = json['downvotes_count'];
    author = json['author'];
    authorPermalink = json['author_permalink'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dialogue'] = this.dialogue;
    data['private'] = this.private;
    data['tags'] = this.tags;
    data['url'] = this.url;
    data['favorites_count'] = this.favoritesCount;
    data['upvotes_count'] = this.upvotesCount;
    data['downvotes_count'] = this.downvotesCount;
    data['author'] = this.author;
    data['author_permalink'] = this.authorPermalink;
    data['body'] = this.body;
    return data;
  }
}
