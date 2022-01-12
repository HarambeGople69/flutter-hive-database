import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/apis/api_services.dart';
import 'package:myapp/database/database.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/network_connection/network_connection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  CheckConnectivity checkConnectivity = Get.put(CheckConnectivity());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                print(Hive.box<PostModel>(DatabaseHelper.apidata).keys);
                // Hive.box<PostModel>(DatabaseHelper.apidata).clear();
              },
              icon: Icon(
                Icons.person,
              ),
            ),
          ],
        ),
        body: Obx(() {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: SafeArea(
                child: checkConnectivity.isOnline == true
                    ? FutureBuilder(
                        future: APIServices().mypost(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    PostModel postModel = snapshot.data[index];
                                    return ListTile(
                                      trailing: Text(
                                        postModel.userId!.toString(),
                                      ),
                                      leading: Text(
                                        index.toString(),
                                      ),
                                      title: Text(
                                        postModel.title!.toString(),
                                      ),
                                      subtitle: Text(
                                        postModel.body!,
                                      ),
                                    );
                                  });
                            } else {
                              return Center(
                                child: Text("Waiting for networl"),
                              );
                            }
                          } else {
                            return Center(child: Text("Error occured"));
                          }
                        },
                      )
                    : Hive.box<PostModel>(DatabaseHelper.apidata).isEmpty
                        ? Text(
                            "data",
                          )
                        : ValueListenableBuilder(
                            valueListenable:
                                Hive.box<PostModel>(DatabaseHelper.apidata)
                                    .listenable(),
                            builder: (context, Box<PostModel> posts, child) {
                              List<int> keys = posts.keys.cast<int>().toList();
                              return ListView.builder(
                                  itemCount: keys.length,
                                  itemBuilder: (context, index) {
                                    final int key = keys[index];
                                    final PostModel postModel = posts.get(key)!;
                                    return ListTile(
                                      trailing: Text(
                                        postModel.userId!.toString(),
                                      ),
                                      leading: Text(
                                        index.toString(),
                                      ),
                                      title: Text(
                                        postModel.title!.toString(),
                                      ),
                                      subtitle: Text(
                                        postModel.body!,
                                      ),
                                    );
                                  });
                            })),
          );
        }));
  }
}
