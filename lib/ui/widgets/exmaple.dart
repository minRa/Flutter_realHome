// import 'package:flutter/material.dart';
// import 'package:realhome/ui/widgets/example2.dart';

// const title = "ReorderableListSimple demo";

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<MyItem> _sampleItems;
//   int _selectedView;
//   bool _reordering;

//   @override
//   void initState() {
//     super.initState();
//     _reordering = true;
//     _selectedView = 0;

//     _sampleItems = [];
//     for(int i = 1; i < 100; i++) {
//       _sampleItems.add(MyItem(i.toString(), randomIcons[i], "Item $i"));
//     }
//   }

//   Widget _buildOptions(MyItem item) {
//     return PopupMenuButton(
//       itemBuilder: (BuildContext context) {
//         return [
//           new PopupMenuItem(child: new Text("edit"), value: "edit"),
//           new PopupMenuItem(child: new Text("delete"), value: "delete"),
//         ];
//       },
//       onSelected: (selected) async {
//         await showDialog(context: context,
//           builder: (BuildContext context) {
//             return SimpleDialog(
//               title: Text(selected),
//               contentPadding: EdgeInsets.all(25.0),
//               children: <Widget>[Text("Item [${item.title}], Operation [$selected].")],
//             );
//           }
//         );
//       },
//     );
//   }

//   Widget _buildListTile(BuildContext context, MyItem item) {
//     Widget options = _buildOptions(item);

//     return ListTile(key: Key(item.key),
//       leading: Icon(item.icon),
//       title: Text(item.title),
//       trailing: options,
//     );
//   }

//   Widget _buildReorderableListView(BuildContext context) {
//     return ReorderableListView(
//       padding: EdgeInsets.only(top: 20.0),
//       children: _sampleItems
//                   .map((MyItem item) => _buildListTile(context, item)).toList(),
//       onReorder: (oldIndex, newIndex) {
//         setState(() {
//           // These two lines are workarounds for ReorderableListView problems
//           if (newIndex > _sampleItems.length) newIndex = _sampleItems.length;
//           if (oldIndex < newIndex) newIndex--;

//           MyItem item = _sampleItems[oldIndex];
//           _sampleItems.remove(item);
//           _sampleItems.insert(newIndex, item);
//         });
//       },
//     );
//   }

//   Widget _buildReorderableListSimple(BuildContext context) {
//     return ReorderableListSimple(
//       // handleSide: ReorderableListSimpleSide.Right,
//       // handleIcon: Icon(Icons.access_alarm),
//       allowReordering: _reordering,
//       padding: EdgeInsets.only(top: 20.0),
//       children: _sampleItems
//                   .map((MyItem item) => _buildListTile(context, item)).toList(),
//       onReorder: (oldIndex, newIndex) {
//         setState(() {
//           MyItem item = _sampleItems[oldIndex];
//           _sampleItems.remove(item);
//           _sampleItems.insert(newIndex, item);
//         });
//       },
//     );
//   }

//   Widget _buildListView(BuildContext context) {
//     return ListView(
//       padding: EdgeInsets.only(top: 20.0),
//       children: _sampleItems
//                   .map((MyItem item) => _buildListTile(context, item)).toList(),
//     );
//   }

//   void _radioChanged(int value) {
//     setState(() => _selectedView = value);
//   }

//   Widget _buildRadio(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         RadioListTile<int>(
//           value: 0,
//           groupValue: _selectedView,
//           onChanged: _radioChanged,
//           title: Text("ListView"),
//         ),
//         RadioListTile<int>(
//           value: 1,
//           groupValue: _selectedView,
//           onChanged: _radioChanged,
//           title: Text("ReorderableListView"),
//         ),
//         RadioListTile<int>(
//           value: 2,
//           groupValue: _selectedView,
//           onChanged: _radioChanged,
//           title: Text("ReorderableListSimple"),
//           secondary: Switch(                
//             value: _reordering,
//             onChanged: (value) {
//               setState(() => _reordering = value);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _view(BuildContext context) {
//     if (_selectedView == 1)
//       return _buildReorderableListView(context);

//     if (_selectedView == 2)
//       return _buildReorderableListSimple(context);

//     return _buildListView(context);
//   }

//   Widget _buildBody(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10.0),
//       child: Column(
//         children: <Widget>[
//           _buildRadio(context),
//           Expanded(child: _view(context)),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: _buildBody(context),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: title,
//       theme: ThemeData(
//         primarySwatch: Colors.pink,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// void main() => runApp(MyApp());

// class MyItem {
//   MyItem(this.key, this.icon, this.title);

//   final String key;
//   final IconData icon;
//   final String title;

//   bool operator ==(o) => o is MyItem && o.key == key;
//   int get hashCode => key.hashCode;
// }

// List<IconData> randomIcons = [
//   Icons.g_translate, Icons.backspace, Icons.backup, Icons.battery_alert, Icons.cached, Icons.cake, Icons.calendar_today, 
//   Icons.camera_enhance, Icons.camera_front, Icons.camera_rear, Icons.camera_roll, Icons.camera, Icons.cancel, Icons.card_giftcard, Icons.card_membership, Icons.card_travel, Icons.casino, Icons.cast_connected, 
//   Icons.calendar_view_day, Icons.call_end, Icons.call_made, Icons.call_merge, Icons.call_missed_outgoing, Icons.call_missed, Icons.call_received, Icons.call_split, Icons.call_to_action, Icons.call, Icons.camera_alt, 
//   Icons.laptop, Icons.last_page, Icons.launch, Icons.layers_clear, Icons.layers, Icons.mail_outline, Icons.mail, Icons.map, Icons.markunread_mailbox, Icons.markunread, Icons.maximize, 
//   Icons.cast, Icons.category, Icons.dashboard, Icons.data_usage, Icons.date_range, Icons.face, Icons.fast_forward, Icons.fast_rewind, Icons.fastfood, Icons.favorite_border, Icons.favorite, 
//   Icons.gamepad, Icons.games, Icons.gavel, Icons.label_important, Icons.label_outline, Icons.label, Icons.landscape, Icons.language, Icons.laptop_chromebook, Icons.laptop_mac, Icons.laptop_windows, 
//   Icons.wc, Icons.adb, Icons.add_a_photo, Icons.add_alarm, Icons.add_alert, Icons.add_box, Icons.add_call, Icons.add_circle_outline, Icons.add_circle, Icons.add_comment, Icons.add_location, 
//   Icons.panorama_vertical, Icons.panorama_wide_angle, Icons.panorama, Icons.party_mode, Icons.pause_circle_filled, Icons.pause_circle_outline, Icons.pause, Icons.payment, Icons.radio_button_checked, Icons.radio_button_unchecked, Icons.radio,
//   Icons.nature_people, Icons.nature, Icons.navigate_before, Icons.navigate_next, Icons.navigation, Icons.pages, Icons.pageview, Icons.palette, Icons.pan_tool, Icons.panorama_fish_eye, Icons.panorama_horizontal, 
//   Icons.ac_unit, Icons.access_alarm, Icons.access_alarms, Icons.access_time, Icons.accessibility_new, Icons.accessibility, Icons.accessible_forward, Icons.accessible, Icons.account_balance_wallet, Icons.account_balance, Icons.account_box, 
//   Icons.delete_forever, Icons.delete_outline, Icons.delete_sweep, Icons.delete, Icons.departure_board, Icons.description, Icons.desktop_mac, Icons.desktop_windows, Icons.details, Icons.developer_board, Icons.developer_mode, 
//   Icons.rate_review, Icons.satellite, Icons.save_alt, Icons.save, Icons.tab_unselected, Icons.tab, Icons.table_chart, Icons.tablet_android, Icons.tablet_mac, Icons.tablet, 
//   Icons.tag_faces, Icons.tap_and_play, Icons.wallpaper, Icons.warning, Icons.watch_later, Icons.watch, Icons.wb_auto, Icons.wb_cloudy, Icons.wb_incandescent, Icons.wb_iridescent, Icons.wb_sunny, 
//   Icons.account_circle, Icons.scanner, Icons.scatter_plot, Icons.schedule, Icons.school, Icons.score, Icons.screen_lock_landscape, Icons.screen_lock_portrait, Icons.screen_lock_rotation, Icons.screen_rotation, Icons.screen_share, 
//   Icons.add_photo_alternate, Icons.add_shopping_cart, Icons.add_to_home_screen, Icons.add_to_photos, Icons.add_to_queue, Icons.add, Icons.adjust, Icons.edit_attributes, Icons.edit_location, Icons.edit, Icons.hd, 
//   Icons.hdr_off, Icons.hdr_on, Icons.hdr_strong, Icons.hdr_weak, Icons.sd_card, Icons.sd_storage, Icons.beach_access, Icons.beenhere, Icons.center_focus_strong, Icons.center_focus_weak, Icons.dehaze, 
//   Icons.device_hub, Icons.device_unknown, Icons.devices_other, Icons.devices, Icons.featured_play_list, Icons.featured_video, Icons.feedback, Icons.gesture, Icons.get_app, Icons.headset_mic, Icons.headset_off, 
//   Icons.headset, Icons.healing, Icons.hearing, Icons.help_outline, Icons.help, Icons.keyboard_arrow_down, Icons.keyboard_arrow_left, Icons.keyboard_arrow_right, Icons.keyboard_arrow_up, Icons.keyboard_backspace, Icons.keyboard_capslock, 
//   Icons.keyboard_hide, Icons.keyboard_return, Icons.keyboard_tab, Icons.keyboard_voice, Icons.keyboard, Icons.leak_add, Icons.leak_remove, Icons.lens, Icons.memory, Icons.menu, Icons.merge_type, 
//   Icons.message, Icons.near_me, Icons.network_cell, Icons.network_check, Icons.network_locked, Icons.network_wifi, Icons.new_releases, Icons.next_week, Icons.people_outline, Icons.people, Icons.perm_camera_mic, 
//   Icons.perm_contact_calendar, Icons.perm_data_setting, Icons.perm_device_information, Icons.perm_identity, Icons.perm_media, Icons.perm_phone_msg, Icons.perm_scan_wifi, Icons.person_add, Icons.person_outline, Icons.person_pin_circle, Icons.person_pin, 
//   Icons.person, Icons.personal_video, Icons.pets, Icons.receipt, Icons.recent_actors, Icons.record_voice_over, Icons.redeem, Icons.redo, Icons.refresh, Icons.remove_circle_outline, Icons.remove_circle, 
//   Icons.remove_from_queue, Icons.remove_red_eye, Icons.remove_shopping_cart, Icons.remove, Icons.reorder, Icons.repeat_one, Icons.repeat, Icons.replay_10, Icons.replay_30, Icons.replay_5, Icons.replay, 
//   Icons.reply_all, Icons.reply, Icons.report_off, Icons.report_problem, Icons.report, Icons.restaurant_menu, Icons.restaurant, Icons.restore_from_trash, Icons.restore_page, Icons.restore, Icons.search, 
//   Icons.security, Icons.select_all, Icons.send, Icons.sentiment_dissatisfied, Icons.sentiment_neutral, Icons.sentiment_satisfied, Icons.sentiment_very_dissatisfied, Icons.sentiment_very_satisfied, Icons.settings_applications, Icons.settings_backup_restore, Icons.settings_bluetooth, 
//   Icons.settings_brightness, Icons.settings_cell, Icons.settings_ethernet, Icons.settings_input_antenna, Icons.settings_input_component, Icons.settings_input_composite, Icons.settings_input_hdmi, Icons.settings_input_svideo, Icons.settings_overscan, Icons.settings_phone, Icons.settings_power, 
//   Icons.settings_remote, Icons.settings_system_daydream, Icons.settings_voice, Icons.settings, Icons.terrain, Icons.text_fields, Icons.text_format, Icons.text_rotate_up, Icons.text_rotate_vertical, Icons.text_rotation_angledown, Icons.text_rotation_angleup, Icons.battery_charging_full, 
//   Icons.text_rotation_down, Icons.text_rotation_none, Icons.textsms, Icons.texture, Icons.verified_user, Icons.vertical_align_bottom, Icons.vertical_align_center, Icons.vertical_align_top, Icons.web_asset, Icons.web, Icons.weekend, 
//   Icons.nfc, Icons.offline_bolt, Icons.offline_pin, Icons.change_history, Icons.chat_bubble_outline, Icons.chat_bubble, Icons.chat, Icons.check_box_outline_blank, Icons.check_box, Icons.check_circle_outline, Icons.check_circle, 
// ];