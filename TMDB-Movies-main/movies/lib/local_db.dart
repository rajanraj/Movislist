
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';



Future<List> getFavaouriteDB() async{
  //  List<Filter> filterVals = [];

    Database db;
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, 'app.db');
    db = await databaseFactoryIo.openDatabase(dbPath);
    final storeDb = intMapStoreFactory.store('favourites');
    // storeDb.find(db).then((value) async {
    //   print(value);
    //   return  value;
    // });
    var results = await storeDb.find(db);
    return results;
        
 }

 Future<bool> fetchData(int movieID) async{
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      final dbPath = join(appDocumentDirectory.path, 'app.db');
      final db = await databaseFactoryIo.openDatabase(dbPath);
      var storeDb = intMapStoreFactory.store('favourites');
        var filterVals = Filter.and([
        Filter.equals('movieId', movieID),
      ]);
      var results = await storeDb.find(db,finder: Finder(filter: filterVals));
      return results.length > 0;

 }
 //Add data into Local Db.
  Future<bool> addToCartDB(int movieID) async {
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      final dbPath = join(appDocumentDirectory.path, 'app.db');
      final db = await databaseFactoryIo.openDatabase(dbPath);
      var storeDb = intMapStoreFactory.store('favourites');
        var filterVals = Filter.and([
        Filter.equals('movieId', movieID),
      ]);

      storeDb
          .find(db, finder: Finder(filter: filterVals))
          .then((results) async {
        if (results.length == 0) {
            var updateRec = {
              "movieId": movieID,
            };
          var result = await storeDb.add(db, updateRec);
          return result;
            

        } else {
          print('Duplicate data');
          return false;
        }
      });

       return false;
  }

  //Delete data into Local Db.
  Future<bool> deleteToCartDB(int movieID) async {
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      final dbPath = join(appDocumentDirectory.path, 'app.db');
      final db = await databaseFactoryIo.openDatabase(dbPath);
      var storeDb = intMapStoreFactory.store('favourites');
        var filterVals = Filter.and([
        Filter.equals('movieId', movieID),
      ]);
      var result = await storeDb.delete(db, finder: Finder(filter: filterVals));
      return result == 1;
  }