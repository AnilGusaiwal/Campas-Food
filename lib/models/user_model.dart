class UserModel {
  final String Id;
  final String UserImage;
  final String UserName;
  final String Email;
  final String type;

  UserModel({
    required this.Id,
    required this.type,
    required this.UserImage,
    required this.UserName,
    required this.Email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        Id: json['userUid'],
        UserImage: json['userImage'],
        UserName: json['userName'],
        Email: json['userEmial'],
        type: json['type'],
      );
}
