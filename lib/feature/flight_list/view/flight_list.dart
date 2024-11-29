import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/method_channel/printer_plugin.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/flight_list/controller/flight_list_controller.dart';

class FlightList extends StatefulWidget {
  const FlightList({super.key});

  @override
  _FlightListState createState() => _FlightListState();
}

class _FlightListState extends State<FlightList> {
  final List<Item> data = generateItems();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightListController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const TextWidget(
          text: "Lich bay",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            CustomTextField(
              hintText: "Tìm kiếm",
              controller: controller.searchController,
              prefixIcon: Icons.search,
              borderWidth: 0,
              backgroundColor: AppColors.primary,
              borderRadius: 20,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        data[index].isExpanded = !isExpanded;
                      });
                    },
                    children: data.map<ExpansionPanel>((Item item) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(item.headerValue),
                          );
                        },
                        body: Column(
                          children: item.expandedValue.map<Widget>((subItem) {
                            return ListTile(
                              title: Text(subItem),
                              subtitle: Text('Cung ứng: 10'),
                              trailing: Icon(Icons.edit),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ListView(
                                      children: [
                                        ListTile(title: Text('Chi tiết 1')),
                                        ListTile(title: Text('Chi tiết 2')),
                                        // Thêm các mục chi tiết khác
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          }).toList(),
                        ),
                        isExpanded: item.isExpanded,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  List<String> expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems() {
  return [
    Item(
      headerValue: 'Hàng Kho Ngoại Quan',
      expandedValue: [
        'Nước tinh khiết Aquafina 1,5L',
        'Trà túi lọc xanh kim anh',
        'Pepsi cola 320 ml',
      ],
    ),
    Item(
      headerValue: 'Hàng Việt Nam',
      expandedValue: [
        'Trà túi lọc Đà Lạt',
        'Nước ngọt việt nam 01',
      ],
    ),
    Item(
      headerValue: 'Hàng Nhập Khẩu',
      expandedValue: [
        'Rượu vang Pháp',
        'Sô cô la Bỉ',
      ],
    ),
  ];
}
