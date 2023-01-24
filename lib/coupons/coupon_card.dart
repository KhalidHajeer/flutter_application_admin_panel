import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/constants.dart';
import 'package:flutter_application_admin_panel/models/model_coupon.dart';

class CouponCard extends StatelessWidget {
  const CouponCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ModelCoupon model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kPrimaryLightColor,
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              color: Color(0x4D090F13),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                child:
                    //model.imageURL == ''
                    // ?
                    Image.asset(
                  'assets/images/waterbottle.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.scaleDown,
                ),
                // : CachedNetworkImage(
                //     progressIndicatorBuilder:
                //         (context, url, downloadProgress) => Center(
                //       child: CircularProgressIndicator(
                //           value: downloadProgress.progress),
                //     ),
                //     errorWidget: (context, url, error) =>
                //         const Icon(Icons.error),
                //     imageUrl: manager.couponsList[index].imageURL!,
                //     width: 100,
                //     height: 100,
                //     fit: BoxFit.scaleDown,
                //   ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${model.couponBookTitle}',
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF090F13),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${model.couponBookPrice} jd',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            // color: ,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.delivery_dining),
                        Text(
                          '  Free Delivery',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0xFF4B39EF),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: const [
                    //     Icon(Icons.energy_savings_leaf),
                    //     Text(
                    //       '  Save 20%',
                    //       style: TextStyle(
                    //         fontFamily: 'Outfit',
                    //         color: Color(0xFF4B39EF),
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Get ${model.couponBookPoints} Points for each Coupon',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0xFF7C8791),
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       ElevatedButton(
                    //           style: const ButtonStyle(
                    //               backgroundColor:
                    //                   MaterialStatePropertyAll<Color>(
                    //                       kPrimaryColor)),
                    //           onPressed: () {
                    //             showCouponBottomSheet(context, index);
                    //           },
                    //           child: const Text(
                    //             'Order Now',
                    //             style: TextStyle(
                    //               fontFamily: 'Outfit',
                    //               color: Colors.white,
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.normal,
                    //             ),
                    //           )),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
