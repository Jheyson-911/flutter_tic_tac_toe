import 'package:sqflite/sqflite.dart';
import "package:flutter_tic_tac_toe/model/partida.dart";
import "package:path/path.dart";

class DB {
  Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), "/model/partida.dart"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE partidas (id INTEGER PRIMARY KEY, nombrePartida TEXT, playerOne TEXT, playerTwo TEXT, ganador TEXT,estado TEXT");
    }, version: 1);
  }

  Future<int> insert(Partida partida) async {
    Database database = await _openDB();

    return database.rawInsert(
        "insert into partidas ( nombrePartida, playerOne, playerTwo,ganador,estado",
        [
          partida.nombrePartida,
          partida.playerOne,
          partida.playerTwo,
          partida.ganador,
          partida.estado
        ]);
  }

  Future<int> delete(Partida partida) async {
    Database database = await _openDB();

    return database.delete("partidas", where: "id = ?");
  }

  Future<int> update(Partida partida, int id) async {
    Database database = await _openDB();
    return database.update(
      "partidas",
      partida.toMap(),
      where: "id = ?",
      whereArgs: [partida.id],
    );
  }

  Future<List<Partida>> partidas() async {
    final Database db = await _openDB();
    final List<Map<String, dynamic>> maps = await db.query('partidas');

    return List.generate(maps.length, (index) {
      return Partida(
        maps[index]['id'],
        maps[index]['nombrePartida'],
        maps[index]['playerOne'],
        maps[index]['playerTwo'],
        maps[index]['ganador'],
        maps[index]['estado'],
      );
    });
  }
}
