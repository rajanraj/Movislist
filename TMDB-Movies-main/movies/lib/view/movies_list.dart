import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movies/api_serivices.dart' as services;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:movies/local_db.dart' as db;
import 'package:movies/view/movies_detail.dart';
class MoviesList extends StatefulWidget {
  MoviesList({Key key}) : super(key: key);

  @override
  _MoviesList createState() => _MoviesList();
}


class _MoviesList extends State<MoviesList> {

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
    }).whenComplete(() => {
      newMoviesListAPI()
    });

    
    
  }

  void newMoviesListAPI(){
    services.getMoviesList(pages.toString()).then((value) => {
      setState((){
        moviesList = value['results'];
      })
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
          title: Text('Movies'),
          backgroundColor: Colors.red
        ),
        body: 
        
        Container(
          padding: EdgeInsets.all(8),
          color: Colors.black,
          child : 
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children : [
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children : [
                  GestureDetector(
                   onTap: (){
                     if (pages != 1) {
                       pages--;
                       newMoviesListAPI();
                     }

                   },
                    child : Icon(Icons.arrow_left, color: Colors.white, size: 30)
                  ),
                   Text(pages.toString(), overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.white, fontSize: 16, fontWeight : FontWeight.w500)),
                    GestureDetector(
                   onTap: (){
                        pages++;
                       newMoviesListAPI();
                   },
                    child : Icon(Icons.arrow_right, color: Colors.white, size: 30)
                  ),

                  
                ]
              ),

            ),
            Expanded(child: 
          
          ListView.builder(
        itemCount: moviesList.length,
        itemBuilder: (context, index) {
          return 
          GestureDetector(
            onTap: (){
                Navigator.push(
    context,
      MaterialPageRoute(builder: (context) => MoviesDetail(moviesList[index])),
  );
            },
            child:
          Container(
            color:  Colors.black,
    height: 200,
    child: Card(
      color: Colors.black,
      shadowColor: Colors.white,
      
      child: 
      Row(
        children : [
          CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/original/${moviesList[index]['poster_path']}',
          ),
           Padding(padding: EdgeInsets.only(right : 10)),
           Expanded(child: Container(
            padding: EdgeInsets.all(5),
            child :
            Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children : [
              Text('${moviesList[index]['title']}' , overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.white, fontSize: 20, fontWeight : FontWeight.bold), maxLines: 2,),
              Padding(padding: EdgeInsets.only(bottom : 8)),
              Text(dateFormateDisplayed('${moviesList[index]['release_date']}'), overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.white, fontSize: 12, fontWeight : FontWeight.normal)),
              Padding(padding: EdgeInsets.only(bottom : 8)),
              Text('${moviesList[index]['vote_average']} / 10', overflow: TextOverflow.ellipsis ,style: TextStyle(color: Colors.white, fontSize: 16, fontWeight : FontWeight.w500)),
              Padding(padding: EdgeInsets.only(bottom : 8)),
              GestureDetector(
                onTap: () => moveToLikedDB(moviesList[index]['id']),
                child : Icon(likesMovies.contains(moviesList[index]['id']) ? Icons.favorite : Icons.favorite_border, color: Colors.white,)
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
    ),
  ));
        }))
            ]
          )


          
        )
      
        )
        );
        
        
  }

}