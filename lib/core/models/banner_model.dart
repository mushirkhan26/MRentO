import 'package:equatable/equatable.dart';

class BannerModel extends Equatable {
  final String id;
  final String imageUrl;
  final String? redirectTo; // App route or external URL
  final String? title;
  final String? subtitle;

  const BannerModel({
    required this.id,
    required this.imageUrl,
    this.redirectTo,
    this.title,
    this.subtitle,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      redirectTo: json['redirectTo'],
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'redirectTo': redirectTo,
      'title': title,
      'subtitle': subtitle,
    };
  }

  @override
  List<Object?> get props => [id, imageUrl, redirectTo, title, subtitle];
}
