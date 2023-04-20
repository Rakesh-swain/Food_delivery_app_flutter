import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/base/custom_loader.dart';
import 'package:shopping_app/base/custom_snackbar.dart';
import 'package:shopping_app/base/no_data_found.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/controllers/auth_controller.dart';
import 'package:shopping_app/controllers/cart_controller.dart';
import 'package:shopping_app/controllers/location_controller.dart';
import 'package:shopping_app/controllers/popular_product.dart';
import 'package:shopping_app/controllers/product_controller.dart';
import 'package:shopping_app/controllers/user_controller.dart';
import 'package:shopping_app/data/repos/order_controller.dart';
import 'package:shopping_app/models/cart_item.dart';
import 'package:shopping_app/models/place_order.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/uitls/app_constants.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
import 'package:shopping_app/widgets/big_text.dart';
import 'package:shopping_app/widgets/text_widget.dart';

import '../../uitls/styles.dart';
import '../../widgets/TextFieldBuilder.dart';
import '../order/delivery_options.dart';
import '../order/payment_option_button.dart';

class CartPage extends StatelessWidget {
  TextEditingController _textController = TextEditingController();
  final int pageId;
  String page;
  CartPage({Key? key, required this.pageId, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _noteController = TextEditingController();
    //  var location = Get.find<LocationController>().getUserAddress();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 6),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (page == "recommended") {
                          Get.toNamed(RouteHelper.getRecommendedFoodRoute(
                              pageId, page));
                        } else if (page == 'popular') {
                          Get.toNamed(RouteHelper.getPopularFoodRoute(
                              pageId, page, RouteHelper.cartPage));
                        } else if (page == 'cart-history') {
                          showCustomSnackBar(
                              "Product review is not available from cart history",
                              isError: false,
                              title: "Order more");
                        } else {
                          Get.offNamed(RouteHelper.getInitialRoute());
                        }
                      },
                      child: Center(
                          child: Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: Colors.white,
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Container(
                    //padding: const EdgeInsets.only(left: 6),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        print("my page id is " + pageId.toString());

                        Get.offNamed(RouteHelper.getInitialRoute());
                      },
                      child: Center(
                          child: Icon(
                        Icons.home_outlined,
                        size: 20,
                        color: Colors.white,
                      )),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 0),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor,
                    ),
                    child: GetBuilder<CartController>(builder: (_) {
                      return Stack(
                        children: [
                          Positioned(
                            child: Center(
                                child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 16,
                              color: Colors.white,
                            )),
                          ),
                          Get.find<CartController>().totalItems >= 1
                              ? Positioned(
                                  right: 3,
                                  top: 1,
                                  child: Center(
                                      child: Icon(
                                    Icons.circle,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                                )
                              : Container(),
                          Get.find<CartController>().totalItems >= 1
                              ? Positioned(
                                  right: 7,
                                  top: 4,
                                  child: Center(
                                      child: Text(
                                    Get.find<CartController>()
                                        .totalItems
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                  )),
                                )
                              : Container()
                        ],
                      );
                    }),
                  )
                ],
              )),
          GetBuilder<CartController>(builder: (_) {
            return Get.find<CartController>().getCarts.length > 0
                ? Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    //with bottom property 0, we can make it scrollable
                    bottom: 0,
                    child: Container(
                      color: Colors.white,
                      // height: 600,
                      //width: 300,
                      child:
                          GetBuilder<CartController>(builder: (cartController) {
                        // print("here from cart "+cartController.getCarts[1].quantity.toString());
                        List<CartItem> _cartList =
                            Get.find<CartController>().getCarts;
                        return MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                              itemCount: _cartList.length,
                              itemBuilder: (_, index) {
                                return Container(
                                  //color: Colors.red,
                                  width: double.maxFinite,
                                  height: 100,
                                  margin: EdgeInsets.all(Dimensions.padding10),
                                  child: _cartList[index].quantity > 0
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          //this setting should come at the end to make sense. this is important for the cart + - button
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var getPageIndex = Get.find<
                                                        ProductController>()
                                                    .popularProductList
                                                    .indexOf(_cartList[index]
                                                        .product);

                                                // page = "recommended";
                                                if (getPageIndex < 0) {
                                                  getPageIndex =
                                                      Get.find<PopularProduct>()
                                                          .popularProductList
                                                          .indexOf(
                                                              _cartList[index]
                                                                  .product);
                                                  // page="popular";
                                                }
                                                if (getPageIndex < 0) {
                                                  showCustomSnackBar(
                                                      "Product review is not available from cart history",
                                                      isError: false,
                                                      title: "Order more");
                                                } else {
                                                  if (page == "recommended") {
                                                    Get.toNamed(RouteHelper
                                                        .getRecommendedFoodRoute(
                                                            getPageIndex,
                                                            page));
                                                  } else if (page ==
                                                      "popular") {
                                                    Get.toNamed(RouteHelper
                                                        .getPopularFoodRoute(
                                                            getPageIndex,
                                                            page,
                                                            RouteHelper
                                                                .cartPage));
                                                  } else if (page ==
                                                      'cart-history') {
                                                    showCustomSnackBar(
                                                        "Product review is not available from cart history",
                                                        isError: false,
                                                        title: "Order more");
                                                  } else {
                                                    Get.toNamed(RouteHelper
                                                        .getInitialRoute());
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            AppConstants
                                                                    .UPLOADS_URL +
                                                                _cartList[index]
                                                                    .img)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .padding20),
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                              width: Dimensions.padding10,
                                            ),
                                            Expanded(
                                              child: Container(
                                                //since column needs height, without this container height this column would take min
                                                //size. Previously this column inside the Row, it didn't know the height. Now because of
                                                //container height, column would occupy the maximun height
                                                height: 100,
                                                //width:260,
                                                child: Column(
                                                  //mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  //spacebetween pushes to the end of the upper boundary
                                                  //spaceAround has the middle upper boundary
                                                  //spaceEvenly has the lowest upper boundary
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      cartController
                                                          .getCarts[index]
                                                          .title,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    /* BigText(text: cartController.getCarts[index].title,
                                                  color: AppColors.titleColor),*/
                                                    TextWidget(
                                                      text: "Spicy",
                                                      color:
                                                          AppColors.textColor,
                                                    ),
                                                    Row(
                                                      children: [
                                                        BigText(
                                                            text: "\$ " +
                                                                cartController
                                                                    .getCarts[
                                                                        index]
                                                                    .price
                                                                    .toString(),
                                                            color: Colors
                                                                .redAccent),
                                                        SizedBox(
                                                          width: Dimensions
                                                              .padding10,
                                                        ),
                                                        Expanded(
                                                            child: Container()),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .all(Dimensions
                                                                    .padding5),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    var quantity =
                                                                        -1;
                                                                    Get.find<CartController>().addItem(
                                                                        _cartList[index]
                                                                            .product,
                                                                        quantity);
                                                                  },
                                                                  child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: AppColors
                                                                          .signColor),
                                                                ),
                                                                SizedBox(
                                                                    width: Dimensions
                                                                        .padding5),
                                                                GetBuilder<
                                                                    ProductController>(
                                                                  builder: (_) {
                                                                    return BigText(
                                                                        text: _cartList[index]
                                                                            .quantity
                                                                            .toString(),
                                                                        color: AppColors
                                                                            .mainBlackColor);
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                    width: Dimensions
                                                                        .padding5),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    var quantity =
                                                                        1;
                                                                    Get.find<CartController>().addItem(
                                                                        _cartList[index]
                                                                            .product,
                                                                        quantity);
                                                                  },
                                                                  child: Icon(
                                                                      Icons.add,
                                                                      color: AppColors
                                                                          .signColor),
                                                                ),
                                                              ],
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .padding20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              0),
                                                                      blurRadius:
                                                                          10,
                                                                      //spreadRadius: 3,
                                                                      color: AppColors
                                                                          .titleColor
                                                                          .withOpacity(
                                                                              0.05))
                                                                ]),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                                );
                              }),
                        );
                      }),
                    ))
                : NoDataScreen(text: "Your cart is empty!");
          })
        ],
      ),
      bottomNavigationBar: bottomNavigationBarBuilder(context),
    );
  }

  Widget bottomNavigationBarBuilder(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return GetBuilder<CartController>(
          builder: (controller) => Container(
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.height10),
                      topRight: Radius.circular(Dimensions.height10)),
                  color: Colors.grey[100],
                ),
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height10,
                    horizontal: Dimensions.width10),
                child: (controller.totalItems.bitLength > 0)
                    ? Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showModalBottomSheetBuilder(
                                  context, orderController);
                            },
                            child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.height20,
                                    horizontal: Dimensions.width15),
                                decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.height20)),
                                child: Center(
                                    child: BigText(
                                  text: "Payment Options",
                                  color: Colors.white,
                                ))),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.height15)),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: Dimensions.width10,
                                      ),
                                      BigText(
                                        text: '\$ ' +
                                            controller.totalAmount.toString(),
                                        color: AppColors.mainColor,
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height10,
                                      horizontal: Dimensions.width10)),
                              GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.height20,
                                        horizontal: Dimensions.width15),
                                    decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.height20)),
                                    child: BigText(
                                      text: "Check Out",
                                      color: Colors.white,
                                    )),
                                onTap: () {
                                  if (Get.find<AuthController>().isLoggedIn()) {
                                    if (Get.find<LocationController>()
                                        .addressList
                                        .isEmpty) {
                                      Get.toNamed(
                                          RouteHelper.getAddAddressRoute());
                                    } else {
                                      var location =
                                          Get.find<LocationController>()
                                              .getUserAddress();
                                      var cart =
                                          Get.find<CartController>().getItems;
                                      var user = Get.find<UserController>()
                                          .userInfoModel;
                                      PlaceOrderBody placeOrder =
                                          PlaceOrderBody(
                                        cart: cart,
                                        orderAmount: 100.0,
                                        distance: 1.5,
                                        scheduleAt: '',
                                        orderNote: orderController.foodNote,
                                        address: location.address,
                                        latitude: location.latitude,
                                        longitude: location.longitude,
                                        contactPersonName: user!.fName,
                                        contactPersonNumber: user.phone,
                                        paymentMethod: orderController
                                                    .paymentMethodIndex ==
                                                0
                                            ? 'cash_on_delivery'
                                            : 'digital_payment',
                                        orderType: orderController.orderType,
                                      );
                                      print(placeOrder.toJson()['order_type']);
                                      Get.find<OrderController>()
                                          .placeOrder(placeOrder, _callback);
                                    }
                                  } else {
                                    Get.toNamed(RouteHelper.getSignInRoute());
                                  }
                                },
                              )
                            ],
                          ),
                        ],
                      )
                    : Container(height: Dimensions.height45 * 2),
              ));
    });
  }

  Future showModalBottomSheetBuilder(
      BuildContext context, OrderController orderController) {
    _textController.text = orderController.foodNote;
    return showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            builder: (_) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.height45)),
                child: SingleChildScrollView(child: GetBuilder<OrderController>(
                  builder: (controller) {
                    return Container(
                      height: 520,
                      padding: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        top: Dimensions.height20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PaymentOptionButton(
                            icon: Icons.money,
                            title: "cash on delivery",
                            subTitle: 'you pay after getting the delivery',
                            index: 0,
                          ),
                          SizedBox(
                            height: Dimensions.height10 / 2,
                          ),
                          PaymentOptionButton(
                            icon: Icons.paypal_outlined,
                            title: "Digital payment",
                            subTitle: 'safer and faster way of payment',
                            index: 1,
                          ),
                          SizedBox(
                            height: Dimensions.height20,
                          ),
                          Text(
                            "Delivery Options",
                            style: robotoMedium,
                          ),
                          DeliveryOptions(
                            value: 'delivery',
                            title: 'Home delivery',
                            amount: Get.find<CartController>().totalAmount,
                            isFree: false,
                          ),
                          DeliveryOptions(
                            value: 'take away',
                            title: 'Take away',
                            amount: 10.0,
                            isFree: true,
                          ),
                          SizedBox(
                            height: Dimensions.height20,
                          ),
                          Text(
                            "Additional info",
                            style: robotoMedium,
                          ),
                          TextFieldBuilder(
                            controller: _textController,
                            prefixIcon: Icons.note,
                            hintText: "Additional info",
                            maxline: 3,
                          )
                        ],
                      ),
                    );
                  },
                )),
              );
            },
            context: context)
        .whenComplete(
            () => orderController.setFoodNote(_textController.text.trim()));
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if (isSuccess) {
      Get.find<CartController>().clearCartList();
      Get.find<OrderController>().stopLoader();
      if (Get.find<OrderController>().paymentMethodIndex == 1) {
        Get.offNamed(RouteHelper.getPaymentRoute(
            orderID, Get.find<UserController>().userInfoModel!.id!));
      } else {
        if (GetPlatform.isWeb) {
          Get.back();
        } else {
          print("working fine");
          Get.offNamed(RouteHelper.getPaymentRoute(
              orderID, Get.find<UserController>().userInfoModel!.id!));
        }
      }
    } else {
      print(message);
      showCustomSnackBar(message);
    }
  }
}
