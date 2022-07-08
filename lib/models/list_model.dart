import 'package:hive/hive.dart';
import 'package:scrumme/models/ticket_model.dart';

part 'list_model.g.dart';


@HiveType(typeId: 0)
class CategoryModel extends HiveObject{

  @HiveField(0)
  String list_id;

  @HiveField(1)
  String list_title;

  @HiveField(2)
  List<TicketModel> tickets = [];

  CategoryModel({required this.list_id,required this.list_title});






  CategoryModel copyWith({
    String? list_id,
    String? list_title,
    List<TicketModel>? tickets,
  }) {
    return CategoryModel(
      list_id: list_id ?? this.list_id,
      list_title: list_title ?? this.list_title,
      //tickets: tickets ?? this.tickets,
    );
  }


  List<Object?> get props => [list_id, list_title, tickets];

}



