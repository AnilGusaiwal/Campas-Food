

class ReviewCartModel {
  final String cartId;
  final String cartImage;
  final String cartName;
  final int cartPrice;
  final int cardQuantity;

  ReviewCartModel(
      {required this.cartId,
      required this.cartImage,
      required this.cartName,
      required this.cartPrice,
      required this.cardQuantity});



  factory ReviewCartModel.fromJson(Map<String, dynamic> json) =>
      ReviewCartModel(
        cartId: json['cardId'],
        cartImage: json['cardImage'],
        cartName: json['cardName'],
        cartPrice: json['cartPrice'],
        cardQuantity: json['cardQuantity'],
      );
}
