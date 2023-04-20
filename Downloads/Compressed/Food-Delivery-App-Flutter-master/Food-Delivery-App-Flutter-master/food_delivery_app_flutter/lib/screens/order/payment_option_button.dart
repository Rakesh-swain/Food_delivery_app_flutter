// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shopping_app/data/repos/order_controller.dart';

import 'package:shopping_app/uitls/styles.dart';
import 'package:get/get.dart';
import '../../components/colors.dart';
import '../../uitls/app_dimensions.dart';

class PaymentOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final int index;
  const PaymentOptionButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      bool _selected = orderController.paymentMethodIndex == index;
      return InkWell(
        onTap: () => orderController.setPaymentMethod(index),
        child: Container(
          padding: EdgeInsets.only(bottom: Dimensions.height10 / 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius20 / 4),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ]),
          child: ListTile(
            leading: Icon(
              icon,
              size: 40,
              color: _selected
                  ? AppColors.mainColor
                  : Theme.of(context).disabledColor,
            ),
            title: Text(
              title,
              style: robotoMedium.copyWith(fontSize: Dimensions.font20),
            ),
            subtitle: Text(
              subTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.font18,
                  color: Theme.of(context).disabledColor),
            ),
            trailing: _selected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
          ),
        ),
      );
    });
  }
}
