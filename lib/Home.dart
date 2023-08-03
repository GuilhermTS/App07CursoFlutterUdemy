import 'package:consumo_servico_avancado/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

   String _urlBase = "https://jsonplaceholder.typicode.com";

   Future<List<Post>>_recuperarPostagens()async{
     http.Response response = await http.get(_urlBase + "/posts");
     var dadosJson = json.decode(response.body);

     List<Post> postagens = List();
     for(var postagem in dadosJson){
       print("post: " + postagem["title"]);
       Post estruturaPostagem = Post(postagem["userId"], postagem["id"], postagem["title"], postagem["body"]);
       postagens.add(estruturaPostagem);
     }
     return postagens;
   }

   _metodoPost() async {
     
     var corpo = json.encode({
       "userId": 120,
       "id": null,
       "title": "Título",
       "body": "Corpo"
     });
     
     http.Response response = await http.post(
       _urlBase + "/posts",
       headers: {
         'Content-type': 'application/json; charset=UTF-8',
       },
       body: corpo,
     );

   }

   _metodoPut() async{

     var corpo = json.encode({
       "userId": 120,
       "id": null,
       "title": "Título alterado",
       "body": "Corpo alterado"
     });

     http.Response response = await http.put(
       _urlBase + "/posts/2",
       headers: {
         'Content-type': 'application/json; charset=UTF-8',
       },
       body: corpo,
     );

   }

   _metodoPatch() async {

     var corpo = json.encode({
       "userId": 120,
       "id": null,
       "title": null,
       "body": "Corpo alterado"
     });

     http.Response response = await http.patch(
       _urlBase + "/posts/2",
       headers: {
         'Content-type': 'application/json; charset=UTF-8',
       },
       body: corpo,
     );
   }

   _metodoDelete()async{

     http.Response response = await http.delete(
       _urlBase + "/posts/2",
     );

   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  onPressed: _metodoPost,
                  color: Colors.green,
                  child: Text(
                    "Salvar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: _metodoPatch,
                  color: Colors.green,
                  child: Text(
                    "Atualizar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: _metodoDelete,
                  color: Colors.green,
                  child: Text(
                    "Excluir",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _recuperarPostagens(),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if(snapshot.hasError){
                        print("Erro ao carregar os dados");
                      } else {
                        print("Lista carregou!!");
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, numIndice){

                              List<Post> lista = snapshot.data;
                              Post postagem = lista[numIndice];

                              return ListTile(
                                title: Text("Usuário #" + postagem.id.toString()),
                                subtitle: Text(postagem.title),
                              );
                            }
                        );
                      }
                  }
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
