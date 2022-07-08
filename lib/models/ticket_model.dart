import 'package:hive/hive.dart';

part 'ticket_model.g.dart';

@HiveType(typeId: 1)
class TicketModel extends HiveObject{
  TicketModel({required this.parent_list_id,required this.ticket_title});
  @HiveField(0)
  String parent_list_id;

  @HiveField(1)
  String ticket_title;

}