import 'package:scrumme/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DatabaseProvider extends ChangeNotifier {

  int _selectedIndex = 0;

  Box<TicketModel> _ticketBox = Hive.box<TicketModel>('ticBox');

  TicketModel _selectedContact = TicketModel(ticket_title: '', parent_list_id: '');

  Box<TicketModel> get ticketBox => _ticketBox;

  TicketModel get selectedContact => _selectedContact;

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    updateSelectedContact();
    notifyListeners();
  }

  void updateSelectedContact() {
    _selectedContact = readFromHive();
    notifyListeners();
  }

  TicketModel readFromHive() {
    TicketModel? getTicket = _ticketBox.getAt(_selectedIndex);

    return getTicket!;
  }

  void deleteFromHive(){
    _ticketBox.deleteAt(_selectedIndex);
  }

}