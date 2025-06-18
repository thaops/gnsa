// import 'package:flutter/material.dart';

// class TabBarCustom extends StatelessWidget {
//   const TabBarCustom({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return   Column(
//         children: [
//           CustomDetailFlight(
//             flightDetail: 'Chi tiết chuyến bay:',
//             flightDetailModel: data,
//           ),
//           // TitleRowAll(
//           //   title: 'DANH SÁCH',
//           //   subtitle: 'Xem hết',
//           //   onClickSeenAll: () => ref.read(isChildExpandedProviderProvider.notifier).toggle(),
//           // ),
//           TabBar(
//             controller: tabController,
//             labelColor: AppColors.primary,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: AppColors.primary,
//             tabs: [
//               Tab(
//                 child: SizedBox(
//                   width: 150.w,
//                   child: Text(
//                     'Phiếu cung ứng',
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               Tab(
//                 child: SizedBox(
//                   width: 150.w,
//                   child: Text(
//                     'Phiếu bổ sung',
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           ConstrainedBox(
//             constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
//             child: TabBarView(
//               controller: tabController,
//               children: [
//                 SupplyFormListView(
//                   supplyForms: data.supplyForms, 
//                   isExpanded: isExpanded,
//                   ref: ref,
//                   kValueSign: _kValueSign,
//                 ),
//                 SupplyFormListView(
//                   supplyForms: data.supplyForms, 
//                   isExpanded: isExpanded,
//                   ref: ref,
//                   kValueSign: _kValueSign,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//   }
// }


    
