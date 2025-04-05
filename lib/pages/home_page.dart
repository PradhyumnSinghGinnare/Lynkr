import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkly/components/my_drawer.dart';
import 'package:linkly/components/my_list_tile.dart';
import 'package:linkly/components/my_post_button.dart';
import 'package:linkly/components/my_textfield.dart';

import '../constrained_scaffold/constrained_home_scaffold.dart';
import '../database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //text controller
  final TextEditingController newPostController = TextEditingController();

  //firestore database access
  final FirestoreDatabase database = FirestoreDatabase();

  //post message
  void postMessage(){
    //only post message if there is something in the text field
    if(newPostController.text.isNotEmpty){
      String message = newPostController.text;
      database.addPost(message);
    }

    //clear the controller
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedHomeScaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("L Y N K R"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          //text field box for user to type
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                //text field
                Expanded(
                  child: MyTextfield(
                      hintText: "Say something..",
                      obscureText: false,
                      controller: newPostController),
                ),

                //post button
                PostButton(
                    onTap: postMessage
                ),
              ],
            ),
          ),

          //posts
          StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context, snapshot) {
                //show loading circle
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                //get all posts
                final posts = snapshot.data!.docs;

                //no data?
                if(snapshot.data == null || posts.isEmpty){
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text("No posts.. Post something!"),
                    ),
                  );
                }

                //return a list of posts
                return Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index){

                        //get each individual post
                        final post = posts[index];

                        //get data from each post
                        String message = post['PostMessage'];
                        String userEmail = post['UserEmail'];
                        Timestamp timestamp = post['TimeStamp'];

                        //return as a list tile
                        return MyListTile(title: message, subtitle: userEmail);
                      },
                    ),
                );
              },
          )
        ],
      ),
    );
  }
}
