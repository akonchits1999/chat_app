import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  UserModel user;

  SearchScreen(this.user);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearchUserAction() async {

    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection('users').where(
        "name", isEqualTo: searchController.text).get().then((value) {
      if (value.docs.length < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("no such user found")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      value.docs.forEach((user) {
        if (user.data()['email'] != widget.user.email) {
          searchResult.add(user.data());
        }
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search for user"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      showCursor: true,
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: "username...",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  )),
              IconButton(onPressed: () {
                onSearchUserAction();
              }, icon: const Icon(Icons.search))
            ],
          ),
          if(searchResult.length > 0)
            Expanded(
              child: ListView.builder(
                itemCount: searchResult.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Image.network(searchResult[index]['image']),
                    ),
                    title: Text(searchResult[index]['name']),
                    subtitle: Text(searchResult[index]['email']),
                    trailing: IconButton(
                      onPressed: (){
                        setState(() {
                          searchController.text = "";
                        });

                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(
                            friendImage: searchResult[index]['image'],
                            currentUser: widget.user,
                            friendId: searchResult[index]['uid'],
                            friendName: searchResult[index]['name'])));
                      },icon: (Icon(Icons.message)),
                    ),
                  );
                },

              ),
            )

          else
            if (isLoading == true)
              const Center(
                child: CircularProgressIndicator(),
              )

        ],
      ),
    );
  }
}