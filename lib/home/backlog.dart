
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:scrumme/dialogs/add_list_dialog.dart';
import 'package:scrumme/models/list_model.dart';
import 'package:scrumme/models/ticket_model.dart';

import '../provider/db_provider.dart';


class BacklogPage extends StatefulWidget {
  const BacklogPage({Key? key}) : super(key: key);

  @override
  State<BacklogPage> createState() => _BacklogPageState();
}

class _BacklogPageState extends State<BacklogPage> {
  final ScrollController _scroll_ticket_priv = ScrollController();
  final ScrollController _scroll_list_priv = ScrollController();
  late TextEditingController _ticketNameTextController;
  late TextEditingController _ticketEditNameTextController;

   int selectedIndex = 0;

  late Box<CategoryModel> categoryBox;
  late Box<TicketModel> ticketBox;

  late CategoryModel categoryModel;
  late TicketModel ticketModel;

  /// Search option

  late TextEditingController _ticketSearchNameTextController;

  ///------------///

  Future<bool> _onBackPressed() async {
    return false;
  }


  @override
  void initState() {
    super.initState();
    _ticketNameTextController = TextEditingController();
    _ticketSearchNameTextController = TextEditingController();
    categoryBox = Hive.box('catBox');
    ticketBox = Hive.box('ticBox');

    }

  @override
  void dispose() {
    _ticketNameTextController.dispose();
    _ticketEditNameTextController.dispose();
    _ticketSearchNameTextController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomInset:false,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(10.0),
            child: AppBar(
               shadowColor: Colors.transparent,
        ),
        ),

        body: Column(children: [
          const SizedBox(
            height: 10,
          ),

          SizedBox(
          height: 80,
            child: Row(
              children: [

          Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white60, Colors.white10],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.white60),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      size: 38,
                      color: Colors.white60,
                    ),
                    onPressed: () {
                      setState(() {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) =>
                            SingleChildScrollView(
                              child: AlertDialog(
                                insetPadding:
                                const EdgeInsets.only(top: 90, right: 30, left: 30),
                                backgroundColor: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                actions: const [
                                  AddListDialog(),
                                ],
                              ),
                            ),
                      );
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(
          width: 5,
        ),
       Expanded(
            child: ValueListenableBuilder(
                   valueListenable: categoryBox.listenable(),
                   builder: (context, Box<CategoryModel> box, _){
             List<CategoryModel> cat = box.values.toList().cast<CategoryModel>();

             return Theme(
                 data: ThemeData(
                     canvasColor: Colors.transparent,
                     shadowColor: Colors.transparent
                 ),

               child: ReorderableListView.builder(
                 key: ValueKey(cat),
                shrinkWrap: true,
               scrollDirection: Axis.horizontal,
               scrollController: _scroll_list_priv,
                itemCount: cat.length,
                   onReorder: (oldIndex, newIndex) {
                     setState(() {
                       if (newIndex > oldIndex) {
                         newIndex = newIndex - 1;
                       }
                       CategoryModel oldItem = box.getAt(oldIndex) as CategoryModel;
                       CategoryModel newItem = box.getAt(newIndex) as CategoryModel;
                       box.putAt(oldIndex, newItem);
                       box.putAt(newIndex, oldItem);
                     });
                   },

                itemBuilder: (BuildContext context, int index) {
                     categoryModel = cat[index];

                  return Padding(
                    key: ValueKey(cat[index]),
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:Border.all(
                            color: selectedIndex == index ? Colors.amber[300]! : Colors.transparent,
                            width: 3
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.lightBlue[400]!,
                              Colors.purpleAccent[100]!,
                              Colors.grey[300]!
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Dismissible(
                          key: ValueKey(cat[index]),
                           background: Container(color: const Color(0xFF512DA8),),
                          direction: cat[index].tickets.isNotEmpty ? DismissDirection.none : DismissDirection.up,
                         onDismissed: (direction) {
                             setState(() {
                               box.deleteAt(index);
                               if(selectedIndex >=1) {
                                 selectedIndex = index - 1;
                               }
                               if(selectedIndex <= -1){
                                 selectedIndex = index;
                               }
                             });
                         },
                       child: ListTile(
                          title: Text(cat[index].list_title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                          onTap: () {
                          setState(() {
                                  selectedIndex = index;
                          });
                         },
                        ),
                      ),
                    ),
                    );
                  }
               ),
             );
                },
            ),
       ),
          ],),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
          child: ValueListenableBuilder(
          valueListenable: ticketBox.listenable(),
            builder: (context, Box<TicketModel> boxT, _){
              List<TicketModel> tick = boxT.values.toList().cast<TicketModel>();

            return Theme(
                data: ThemeData(
                  canvasColor: Colors.transparent,
                  shadowColor: Colors.transparent
            ),

             child: ReorderableListView.builder(
               key: ValueKey(tick),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              scrollController: _scroll_ticket_priv,
              itemCount: tick.length, // tick.length,
                onReorder: (oldIdx, newIdx) {
                  setState(() {
                    if (newIdx > oldIdx) {
                        newIdx = newIdx - 1;
                     }
                  TicketModel oldItem = boxT.getAt(oldIdx) as TicketModel;
                  TicketModel newItem = boxT.getAt(newIdx) as TicketModel;
                  boxT.putAt(oldIdx, newItem);
                  boxT.putAt(newIdx, oldItem);
              });
            },

             itemBuilder: (BuildContext context, int idx) {
                 ticketModel = tick[idx];

              if(ticketBox.getAt(idx)!.parent_list_id  == categoryBox.getAt(selectedIndex)!.list_id) {

                return Padding(
                  key: ValueKey(tick[idx]),
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlue[400]!,
                          Colors.purpleAccent[100]!,
                          Colors.grey[300]!
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),

                    child: Dismissible(
                      key: ValueKey(tick[idx]),
                      background: Container(color: const Color(0xFF512DA8),),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        setState(() {
                          categoryBox.getAt(selectedIndex)!.tickets.remove(tick[idx]);
                          ticketBox.deleteAt(idx);
                        });
                      },
                      child: Card(
                        elevation: 0,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.only(left: 3),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange[900]!,
                                Colors.orange[400]!,
                                Colors.grey[300]!
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: ListTile(
                                title: Text(tick[idx].ticket_title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                leading: IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.black,),
                                  onPressed: () {
                                    _ticketEditNameTextController = TextEditingController(text: tick[idx].ticket_title);
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SingleChildScrollView(
                                            child: AlertDialog(
                                              insetPadding:
                                              const EdgeInsets.only(top: 90, right: 30, left: 30),
                                              backgroundColor: Colors.grey[300],
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30.0)),
                                              actions: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    const Center(
                                                        child: Text(
                                                          "Edit a Ticket",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 17),
                                                        )),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextField(
                                                      maxLength: 15,
                                                      maxLines: 1,
                                                      controller: _ticketEditNameTextController,
                                                      style: const TextStyle(fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        _buildTicketEditDialogCancelButton(),
                                                        _buildTicketEditDialogSaveButton(idx,tick),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                    );
                                  },
                                ),
                                onTap: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        SingleChildScrollView(
                                          child: AlertDialog(
                                            insetPadding:
                                            const EdgeInsets.only(top: 90, right: 30, left: 30),
                                            backgroundColor: Colors.grey[300],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30.0)),
                                            actions: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  const Center(
                                                      child: Text(
                                                        "Ticket info",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 17),
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(tick[idx].ticket_title,
                                                    style: const TextStyle(fontSize: 15,),),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      _buildTicketInfoDialogCancelButton(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                  );
                                },
                              ),
                        ),
                      ),
                    ),
                  ),
                );
              }else{
                return Container(
                  key: ValueKey(tick[idx]),
                );
              }
              }
              ),
       );
          },
          ),
    ),
          const SizedBox(
            height: 4,
          ),
          Visibility(
              visible: categoryBox.isEmpty? false: true,
              child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white60, Colors.white10],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.white60),
                  ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        size: 38,
                        color: Colors.white60,
                      ),
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) =>
                              SingleChildScrollView(
                                child: AlertDialog(
                                  insetPadding:
                                  const EdgeInsets.only(top: 90, right: 30, left: 30),
                                  backgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0)),
                                  actions: [
                                  Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Center(
                                        child: Text(
                                          "Create a Ticket",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),

                                    TextField(
                                      maxLength: 40,
                                      maxLines: 2,
                                      controller: _ticketNameTextController,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildDialogCancelButton(),
                                        _buildDialogCreateTicketButton(),
                                      ],
                                    ),
                                  ],
                                ),
                                  ],
                                ),
                              ),
                        );
                      },
                    ),
                ),
              ),
            ),
          ),
          ),
        ],),
        floatingActionButton: Visibility(
          visible: ticketBox.isEmpty?false:true,
          child: Padding(
            padding: EdgeInsets.only(bottom: 70),
          child: FloatingActionButton(
            backgroundColor: Colors.white60,
            child: Icon(Icons.search, color: Colors.orange[800],size: 35,),
            onPressed: (){
                showSearch(
                  context: context,
                  delegate: SearchData(),
                );
            },
          ),
        ),
        ),
    ),
    );
  }

  _buildTicketEditDialogSaveButton(int index, List<TicketModel> tList) {
    return ElevatedButton(
    onPressed: () {
      if(_ticketEditNameTextController.text.isEmpty){

      }else{
      setState(() {

         TicketModel modelt = TicketModel(parent_list_id: categoryBox.getAt(selectedIndex)!.list_id, ticket_title: _ticketEditNameTextController.text);

         ticketBox.putAt(index, modelt);
         categoryBox.getAt(selectedIndex)!.tickets.remove(tList[index]);
         categoryBox.getAt(selectedIndex)!.tickets.insert(index,modelt);

      });
      _ticketEditNameTextController.clear();
      Navigator.of(context).pop();

      }
    },

      child: const Text("ReName"),
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        primary: Colors.blue,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        textStyle: const TextStyle(
          fontSize: 17,
        ),
      ),
    );

  }


  _buildTicketEditDialogCancelButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Cancel"),
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        primary: Colors.red,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        textStyle: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }


  _buildTicketInfoDialogCancelButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Close"),
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        primary: Colors.blue,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        textStyle: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }



  _buildDialogCancelButton() {
    return ElevatedButton(
      onPressed: () {
        _ticketNameTextController.clear();
        Navigator.of(context).pop();
      },
      child: const Text("Cancel"),
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        primary: Colors.red,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        textStyle: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }


  _buildDialogCreateTicketButton() {
    return ElevatedButton(
      onPressed: () {
        if(_ticketNameTextController.text.isEmpty){
        }else{
          setState(() {
            TicketModel modelt = TicketModel(parent_list_id: categoryBox.getAt(selectedIndex)!.list_id, ticket_title: _ticketNameTextController.text);
            ticketBox.add(modelt);
            categoryBox.getAt(selectedIndex)!.tickets.add(modelt);

          });
          _ticketNameTextController.clear();
          Navigator.of(context).pop();
        }
      },
      child: const Text("Create"),
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        primary: Colors.blue,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        textStyle: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }

}

class SearchData extends SearchDelegate<TicketModel> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BacklogPage()));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchFinder(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchFinder(query: query);
  }
}


class SearchFinder extends StatelessWidget {
  final String query;
  const SearchFinder({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    late Box<TicketModel> ticketBox = Hive.box('ticBox');
    late Box<CategoryModel> catBox = Hive.box('catBox');
   return ValueListenableBuilder(
       valueListenable: ticketBox.listenable(),
    builder: (context, Box<TicketModel> boxT, _){
    var results = query.isEmpty
        ? boxT.values.toList()
        : boxT.values
        .where((c) => c.ticket_title.toLowerCase().contains(query))
        .toList();

        return results.isEmpty
            ? Center(
          child: Text(
            'No results found !',
            style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.white,
            ),
          ),
        )
            : ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final TicketModel ticketsListItem = results[index];

            return ListTile(
              onTap: () {
                var selectedContactIndex =
                Provider.of<DatabaseProvider>(context, listen: false)
                    .ticketBox
                    .values
                    .toList()
                    .indexOf(results[index]);
                databaseProvider
                    .updateSelectedIndex(selectedContactIndex);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BacklogPage()
                    )
                );

              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticketsListItem.ticket_title,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 5.0),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

