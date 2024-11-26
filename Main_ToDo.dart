import 'package:flutter/material.dart';
import 'package:untitled2/Todo/Main_DB.dart';

class Todo_design extends StatefulWidget {
  const Todo_design({super.key});

  @override
  State<Todo_design> createState() => _Todo_designState();
}

class _Todo_designState extends State<Todo_design> {
   TextEditingController title_controller = TextEditingController();
   TextEditingController desc_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String,dynamic>> allNotes=[];
  My_DB db = new My_DB();
  void getAllProducts() async {
    allNotes = await db.getAllNote();
    print("Fetched Notes: $allNotes");
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllProducts();
      print("Scaffold has been loaded");
    });
  }
  @override
  Widget build(BuildContext context) {
    dynamic size = MediaQuery.of(context).size;
    dynamic height = size.height;
    dynamic width = size.width;
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text('Notes' , style: TextStyle(color: Colors.white,fontSize: 40),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: allNotes.isNotEmpty ?
        ListView.builder(
          itemCount: allNotes.length,
          itemBuilder: (context, index) {
            return note_Card(
              index+1,
              allNotes[index][My_DB.Note_Column_Id],
              allNotes[index][My_DB.Note_Column_Title],
              allNotes[index][My_DB.Note_Column_Desc],
            );
          },
        ) :
        Center(child: Text('No Notes',style: TextStyle(fontSize: 25),)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async{
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return note_form('ADD',null);
              },
          );
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
  // ----------------------------------------------------------------
  // card
  Widget note_Card(int no, int id, String title, String desc){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
          child: Row(
            children: [
              Container(child: Text('$no',style: TextStyle(fontSize: 25,color: Colors.grey),)),
              SizedBox(width: 8,),
              Container(child: Expanded(child: Text(title, style: TextStyle(fontSize: 25),))),
              SizedBox(width: 8,),
              IconButton(onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return note_form('Update',id);
                  },
                );
              }, icon: Icon(Icons.edit,color: Colors.grey,)),
              SizedBox(width: 2,),
              IconButton(onPressed: () async {
                bool check = await db.deleteProduct(ID: id);
                if(check) {
                  getAllProducts();
                }
              }, icon: Icon(Icons.delete,color: Colors.grey)),
              SizedBox(width: 2,),
              IconButton(onPressed: () {

              }, icon: Icon(Icons.arrow_drop_down,color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
  // ----------------------------------------------------------------
  // form
  Widget note_form (operation, int? id) {
    dynamic size = MediaQuery.of(context).size;
    dynamic h = size.height;
    dynamic w = size.width;
    return  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: h/2,
            child: Form(
             key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Text('$operation',style: TextStyle(fontSize: 25),),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextFormField(
                      controller: title_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter title";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border : OutlineInputBorder(borderRadius: BorderRadius.circular(25) , borderSide: BorderSide(color: Colors.greenAccent, width: 2 ,strokeAlign: BorderSide.strokeAlignCenter)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25) , borderSide: BorderSide(color: Colors. blue, width: 2,strokeAlign: BorderSide.strokeAlignCenter)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextFormField(
                      controller: desc_controller,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter description";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'description',
                        border : OutlineInputBorder(borderRadius: BorderRadius.circular(25) , borderSide: BorderSide(color: Colors.greenAccent, width: 2 ,strokeAlign: BorderSide.strokeAlignCenter)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25) , borderSide: BorderSide(color: Colors. blue, width: 2,strokeAlign: BorderSide.strokeAlignCenter)),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SizedBox(
                height: h/10,
                // width: w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: h/4,
                      width: w/2,
                      child: ElevatedButton(
                          onPressed: () async{
                            if (_formKey.currentState!.validate()) {
                              String title=title_controller.text;
                              String desc=desc_controller.text;
                              if(title.isNotEmpty && desc.isNotEmpty){
                                  bool check= operation == 'ADD' ? await db.addNote(N_title: title, N_desc: desc) : await db.updateNote(ID: id!, N_title: title, N_desc: desc);
                                if(check){
                                  getAllProducts();
                                  title_controller.clear();
                                  desc_controller.clear();
                                  Navigator.pop(context);
                                }
                              }
                            }
                          },
                          child: Text('$operation',style: TextStyle(fontSize: 20,color: Colors.white,),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.yellow,
                          )
                      ),
                    ),
                    Container(
                      height: h/2,
                      // width: w/3,
                      child: Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              title_controller.clear();
                              desc_controller.clear();
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',style: TextStyle(fontSize: 20,color: Colors.white,),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black26,
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
                ]
              ),
            ),
          ),
    );
  }
}
