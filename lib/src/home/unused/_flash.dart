// import 'dart:async';

// import 'package:flash/flash.dart';
// import 'package:flash/flash_helper.dart';
// import 'package:flutter/material.dart';

// class FlashPage extends StatefulWidget {
//   const FlashPage({super.key});

//   @override
//   State<FlashPage> createState() => _FlashPageState();
// }

// class _FlashPageState extends State<FlashPage> {
//   final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _key,
//       appBar: AppBar(
//         title: const Text('Flash Demo'),
//         actions: <Widget>[
//           IconButton(
//               icon: const Icon(Icons.info_outline),
//               onPressed: () {
//                 showDialog(
//                     context: context,
//                     builder: (_) {
//                       return AlertDialog(
//                         title: const Text('Flash'),
//                         content: const Text(
//                             '⚡️A highly customizable, powerful and easy-to-use alerting library for Flutter.'),
//                         actions: <Widget>[
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text('YES'),
//                           ),
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text('NO'),
//                           ),
//                         ],
//                       );
//                     });
//               })
//         ],
//       ),
//       body: Column(
//         children: <Widget>[
//           const TextField(
//             decoration: InputDecoration(
//               hintText: 'Test FocusScopeNode',
//               contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16.0),
//               physics: const AlwaysScrollableScrollPhysics(),
//               children: [
//                 Wrap(
//                   spacing: 8.0,
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   alignment: WrapAlignment.start,
//                   runAlignment: WrapAlignment.center,
//                   children: <Widget>[
//                     const Row(children: <Widget>[Text('Flash Toast')]),
//                     ElevatedButton(
//                       onPressed: () =>
//                           context.showToast(const Text('message (Queue)')),
//                       child: const Text('Toast (Queue)'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.showToast(
//                         const Text('message'),
//                         shape: const StadiumBorder(),
//                         queue: false,
//                         alignment: const Alignment(0.0, -0.3),
//                       ),
//                       child: const Text('Toast'),
//                     ),
//                     const Row(children: <Widget>[Text('Flash Bar')]),
//                     ElevatedButton(
//                       onPressed: () => context.showFlash<bool>(
//                         duration: const Duration(seconds: 3),
//                         builder: (context, controller) => FlashBar(
//                           controller: controller,
//                           indicatorColor: Colors.red,
//                           icon: const Icon(Icons.tips_and_updates_outlined),
//                           title: const Text('Flash Title'),
//                           content: const Text('This is basic flash.'),
//                           actions: [
//                             TextButton(
//                                 onPressed: controller.dismiss,
//                                 child: const Text('Cancel')),
//                             TextButton(
//                                 onPressed: () => controller.dismiss(true),
//                                 child: const Text('Ok'))
//                           ],
//                         ),
//                       ),
//                       child: const Text('Basics'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.showFlash<bool>(
//                         barrierDismissible: true,
//                         duration: const Duration(seconds: 3),
//                         builder: (context, controller) => FlashBar(
//                           controller: controller,
//                           forwardAnimationCurve: Curves.easeInCirc,
//                           reverseAnimationCurve: Curves.bounceIn,
//                           position: FlashPosition.top,
//                           indicatorColor: Colors.red,
//                           icon: const Icon(Icons.tips_and_updates_outlined),
//                           title: const Text('Flash Title'),
//                           content: const Text('This is basic flash.'),
//                           actions: [
//                             TextButton(
//                                 onPressed: controller.dismiss,
//                                 child: const Text('Cancel')),
//                             TextButton(
//                                 onPressed: () => controller.dismiss(true),
//                                 child: const Text('Ok'))
//                           ],
//                         ),
//                       ),
//                       child: const Text('Duration | Top | Dismissible'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.showFlash<bool>(
//                         barrierColor: Colors.black54,
//                         barrierBlur: 16,
//                         barrierDismissible: true,
//                         builder: (context, controller) => FlashBar(
//                           controller: controller,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.vertical(top: Radius.circular(16)),
//                             side: BorderSide(),
//                           ),
//                           clipBehavior: Clip.hardEdge,
//                           indicatorColor: Colors.blue,
//                           icon: const Icon(Icons.tips_and_updates_outlined),
//                           title: const Text('Flash Title'),
//                           content: const Text('This is basic flash.'),
//                           actions: [
//                             TextButton(
//                                 onPressed: controller.dismiss,
//                                 child: const Text('Cancel')),
//                             TextButton(
//                                 onPressed: () => controller.dismiss(true),
//                                 child: const Text('Ok'))
//                           ],
//                         ),
//                       ),
//                       child: const Text('Bottom | Floating | Dismissible'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.showFlash<bool>(
//                         builder: (context, controller) => FlashBar(
//                           controller: controller,
//                           behavior: FlashBehavior.floating,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(16)),
//                             side: BorderSide(
//                               color: Colors.yellow,
//                               strokeAlign: BorderSide.strokeAlignInside,
//                             ),
//                           ),
//                           margin: const EdgeInsets.all(32.0),
//                           clipBehavior: Clip.antiAlias,
//                           indicatorColor: Colors.amber,
//                           icon: const Icon(Icons.tips_and_updates_outlined),
//                           title: const Text('Flash Title'),
//                           content: const Text('This is basic flash.'),
//                         ),
//                       ),
//                       child: const Text('Bottom | Fixed | Margin'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.showFlash<bool>(
//                         persistent: false,
//                         onRemoveFromRoute: () {
//                           context.showToast(const Text('Flash removed'));
//                         },
//                         builder: (context, controller) => FlashBar(
//                           controller: controller,
//                           behavior: FlashBehavior.floating,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(16)),
//                             side: BorderSide(
//                               color: Colors.yellow,
//                               strokeAlign: BorderSide.strokeAlignInside,
//                             ),
//                           ),
//                           margin: const EdgeInsets.all(32.0),
//                           clipBehavior: Clip.antiAlias,
//                           indicatorColor: Colors.red,
//                           icon: const Icon(Icons.tips_and_updates_outlined),
//                           title: const Text('Flash Title'),
//                           content: const Text('This is basic flash.'),
//                         ),
//                       ),
//                       child: const Text('Bottom | Fixed | Nonpersistent'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         final editController = TextEditingController();
//                         context
//                             .showFlash<String>(
//                               persistent: false,
//                               barrierColor: Colors.black54,
//                               barrierDismissible: true,
//                               builder: (context, controller) => FlashBar(
//                                 controller: controller,
//                                 clipBehavior: Clip.antiAlias,
//                                 indicatorColor: Colors.red,
//                                 icon:
//                                     const Icon(Icons.tips_and_updates_outlined),
//                                 title: const Text('Flash Title'),
//                                 content: TextField(
//                                   controller: editController,
//                                   autofocus: true,
//                                 ),
//                                 primaryAction: IconButton(
//                                   onPressed: () =>
//                                       controller.dismiss(editController.text),
//                                   icon: const Icon(Icons.send),
//                                 ),
//                               ),
//                             )
//                             .then((value) => value == null
//                                 ? context.showErrorBar(
//                                     position: FlashPosition.top,
//                                     content: const Text('Say nothing!'),
//                                   )
//                                 : context.showSuccessBar(
//                                     position: FlashPosition.top,
//                                     icon: const Icon(Icons.support_agent),
//                                     content: Text('Say: $value'),
//                                   ));
//                       },
//                       child: const Text('Bottom | Input | Nonpersistent'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.showInfoBar(
//                           content: const Text('I am Info Bar!')),
//                       child: const Text('Flash Info Bar'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.showSuccessBar(
//                           content: const Text('I am Success Bar!')),
//                       child: const Text('Flash Success Bar'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.showErrorBar(
//                         content: const Text('I am Error Bar!'),
//                         primaryActionBuilder: (context, controller) {
//                           return IconButton(
//                             onPressed: controller.dismiss,
//                             icon: const Icon(Icons.undo),
//                           );
//                         },
//                       ),
//                       child: const Text('Flash Error Bar'),
//                     ),
//                     const Row(children: <Widget>[Text('Flash Dialog')]),
//                     ElevatedButton(
//                       onPressed: () => context.showFlash(
//                         barrierColor: Colors.black54,
//                         barrierDismissible: true,
//                         builder: (context, controller) => FadeTransition(
//                           opacity: controller.controller,
//                           child: AlertDialog(
//                             shape: const RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(16)),
//                               side: BorderSide(),
//                             ),
//                             contentPadding: const EdgeInsets.only(
//                                 left: 24.0,
//                                 top: 16.0,
//                                 right: 24.0,
//                                 bottom: 16.0),
//                             title: const Text('Title'),
//                             content: const Text('Content'),
//                             actions: [
//                               TextButton(
//                                 onPressed: controller.dismiss,
//                                 child: const Text('Ok'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       child: const Text('Alert Dialog'),
//                     ),
//                     const Row(children: <Widget>[Text('Modal Flash')]),
//                     ElevatedButton(
//                       onPressed: () => context.showModalFlash(
//                         barrierBlur: 16,
//                         builder: (context, controller) => FlashBar(
//                           controller: controller,
//                           behavior: FlashBehavior.floating,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(16)),
//                             side: BorderSide(
//                               color: Colors.yellow,
//                               strokeAlign: BorderSide.strokeAlignInside,
//                             ),
//                           ),
//                           margin: const EdgeInsets.all(32.0),
//                           clipBehavior: Clip.antiAlias,
//                           indicatorColor: Colors.amber,
//                           icon: const Icon(Icons.tips_and_updates_outlined),
//                           title: const Text('Flash Title'),
//                           content: const Text('This is basic flash.'),
//                         ),
//                       ),
//                       child: const Text('Bar | Bottom | Floating | Margin'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.showModalFlash(
//                         builder: (context, controller) => RotationTransition(
//                           turns: controller.controller
//                               .drive(CurveTween(curve: Curves.bounceInOut)),
//                           child: FadeTransition(
//                             opacity: controller.controller
//                                 .drive(CurveTween(curve: Curves.fastOutSlowIn)),
//                             child: Flash(
//                               controller: controller,
//                               dismissDirections: FlashDismissDirection.values,
//                               slideAnimationCreator: (context, position, parent,
//                                   curve, reverseCurve) {
//                                 return controller.controller.drive(Tween(
//                                     begin: const Offset(0.1, 0.1),
//                                     end: Offset.zero));
//                               },
//                               child: AlertDialog(
//                                 shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(16)),
//                                   side: BorderSide(),
//                                 ),
//                                 contentPadding: const EdgeInsets.only(
//                                     left: 24.0,
//                                     top: 16.0,
//                                     right: 24.0,
//                                     bottom: 16.0),
//                                 title: const Text('Title'),
//                                 content: const Text('Content'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: controller.dismiss,
//                                     child: const Text('Ok'),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       child: const Text('Alert Dialog'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         final completer = Completer();
//                         Future.delayed(const Duration(seconds: 5))
//                             .then((_) => completer.complete());
//                         context.showBlockDialog(dismissCompleter: completer);
//                       },
//                       child: const Text('Block Dialog'),
//                     ),
//                     const Row(children: <Widget>[Text('Flash Custom')]),
//                     ElevatedButton(
//                       onPressed: () => context.showFlash(
//                         builder: (context, controller) {
//                           return Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Flash(
//                               controller: controller,
//                               position: FlashPosition.bottom,
//                               dismissDirections: const [
//                                 FlashDismissDirection.startToEnd
//                               ],
//                               child: const SizedBox(
//                                 width: double.infinity,
//                                 child: Material(
//                                   elevation: 24,
//                                   child: SafeArea(
//                                     top: false,
//                                     child: Padding(
//                                       padding: EdgeInsets.all(16),
//                                       child: Text('A custom with Flash'),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       child: const Text('Custom Flash Bar'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.showModalFlash(
//                         builder: (context, controller) {
//                           return Align(
//                             alignment: AlignmentDirectional.centerStart,
//                             child: FadeTransition(
//                               opacity: controller.controller
//                                   .drive(Tween(begin: 0.5, end: 1.0)),
//                               child: Flash(
//                                 controller: controller,
//                                 slideAnimationCreator: (context, position,
//                                     parent, curve, reverseCurve) {
//                                   return CurvedAnimation(
//                                           parent: parent,
//                                           curve: curve,
//                                           reverseCurve: reverseCurve)
//                                       .drive(Tween<Offset>(
//                                           begin: Offset(
//                                             Directionality.of(context) ==
//                                                     TextDirection.ltr
//                                                 ? -1.0
//                                                 : 1.0,
//                                             // -1.0,
//                                             0.0,
//                                           ),
//                                           end: Offset.zero));
//                                 },
//                                 dismissDirections: const [
//                                   FlashDismissDirection.endToStart
//                                 ],
//                                 child: const FractionallySizedBox(
//                                   widthFactor: 0.8,
//                                   child: Material(
//                                     elevation: 24,
//                                     clipBehavior: Clip.antiAlias,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(8)),
//                                     ),
//                                     child: SafeArea(
//                                       child: Column(
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.all(16),
//                                             child: Text('A custom with Flash'),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       child: const Text('Custom Flash Drawer'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
