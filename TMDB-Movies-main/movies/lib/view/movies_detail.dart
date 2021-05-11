import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movies/api_serivices.dart' as services;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:movies/local_db.dart' as db;
class MoviesDetail extends StatefulWidget {

  final Map<String,dynamic> movie_detail;

  MoviesDetail(this.movie_detail);

  @override
  _MoviesDetail createState() => _MoviesDetail();
}


class _MoviesDetail extends State<MoviesDetail> {

  List moviesList = []; 
  List<int> likesMovies = [];
  int pages = 1;
  @override
  void initState() {
    super.initState();
    db.getFavaouriteDB().then((result) async {
      likesMovies.clear();
      print('RESULTS == $result');
      for (var likedObj in result){
        likesMovies.add(likedObj['movieId']);
      }

      setState(() {
        likesMovies = likesMovies;
      });
    // }).whenComplete(() => {
    //   newMoviesListAPI()
    });

    
    
  }


  String dateFormateDisplayed(String dateString) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime releasedDate = formatter.parse(dateString);
    String releaseDateString = DateFormat("dd/MM/yy").format(releasedDate);
    return releaseDateString;
  }
  moveToLikedDB(int ids){

    db.fetchData(ids).then((value) async {
      print('FETCH RESULTS == $value');
      print(value);
       if (value){
         db.deleteToCartDB(ids).then((value) async{
            updateLocalList();
         });
    }else{
          db.addToCartDB(ids).then((value) async{
            updateLocalList();

         });
    }
    });

   

  }
  void updateLocalList(){
    db.getFavaouriteDB().then((result) async {
      likesMovies.clear();
      for (var likedObj in result){
        likesMovies.add(likedObj['movieId']);
      }
      setState((){
        likesMovies = likesMovies;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          
          title: 
          Container(
            child : 
            Row(
              children:[
              IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                Navigator.pop(context);
              }),
              Text('Movies Details')
              ]
            )
           
          ),
          backgroundColor: Colors.red
        ),
        body: 
        Container(
          padding: EdgeInsets.all(8),
          color: Colors.black,
          child: Column(
            children:[

              Container(
            color:  Colors.black,
    height: 200,
    child:
            Card(
      color: Colors.black,
      shadowColor: Colors.white,
      
      child: 
      Row(
        children : [
          CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/original/${widget.movie_detail['poster_path']}',
          ),
           Padding(padding: EdgeInsets.only(right : 10)),
           Expanded(child: Container(
            padding: EdgeInsets.all(5),
            child :
            Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children : [
              Text('${widget.movie_detail['title']}' , overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.white, fontSize: 20, fontWeight : FontWeight.bold), maxLines: 2,),
              Padding(padding: EdgeInsets.only(bottom : 8)),
              Text(dateFormateDisplayed('${widget.movie_detail['release_date']}'), overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.white, fontSize: 12, fontWeight : FontWeight.normal)),
              Padding(padding: EdgeInsets.only(bottom : 8)),
              Text('${widget.movie_detail['vote_average']} / 10', overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.white, fontSize: 16, fontWeight : FontWeight.w500)),
              Padding(padding: EdgeInsets.only(bottom : 8)),
              GestureDetector(
                onTap: () => moveToLikedDB(widget.movie_detail['id']),
                child : Icon(likesMovies.contains(widget.movie_detail['id']) ? Icons.favorite : Icons.favorite_border, color: Colors.white,)
              )
              
             ]
           )
           ))
        ]
      ),
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2.5,
      margin: EdgeInsets.all(10),
    )),

                  Text('${widget.movie_detail['overview']}' , overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.white, fontSize: 20, fontWeight : FontWeight.normal), maxLines: 300,),

            ])
         )
      
        )
        );
        
        
  }

}