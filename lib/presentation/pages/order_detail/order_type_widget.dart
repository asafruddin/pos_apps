import 'package:flutter/material.dart';
import 'package:pos_app/presentation/pages/order_detail/order_type_helper.dart';
import 'package:pos_app/presentation/widget/theme.dart';

class OrderTypeWidget extends StatelessWidget {
  const OrderTypeWidget({super.key, required this.orderType});

  final ValueNotifier<int> orderType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            color: CustomTheme.neutral200,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            'Jenis Pesanan',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
            height: 50,
            child: ValueListenableBuilder<int>(
                valueListenable: orderType,
                builder: (context, value, child) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: OrderTypeHelper.orderTypeList.length,
                    itemBuilder: (context, index) {
                      final orderTypeCode =
                          OrderTypeHelper.orderTypeList[index];
                      final isSelected = value == orderTypeCode;
                      return InkWell(
                        onTap: () {
                          orderType.value = orderTypeCode;
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: Chip(
                            shape: const StadiumBorder(
                                side: BorderSide(color: CustomTheme.primary)),
                            label: Text(OrderTypeHelper.orderTypeToLabel(
                                orderTypeCode)),
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : CustomTheme.primary),
                            backgroundColor: isSelected
                                ? CustomTheme.primary
                                : Colors.transparent),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: 8.0),
                  );
                })),
        const SizedBox(height: 16.0)
      ],
    );
  }
}
