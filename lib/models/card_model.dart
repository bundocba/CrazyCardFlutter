class CardModel {
  final int number;
  final String iconPath;
  final String task;
  final String penalty;

  CardModel({
    required this.number,
    required this.iconPath,
    required this.task,
    required this.penalty,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      number: json['number'],
      iconPath: json['iconPath'],
      task: json['task'],
      penalty: json['penalty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'iconPath': iconPath,
      'task': task,
      'penalty': penalty,
    };
  }
}