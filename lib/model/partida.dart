class Partida {
  late int id;
  late String nombrePartida;
  late String playerOne;
  late String playerTwo;
  late String ganador;
  late String estado;

  Partida(this.id, this.nombrePartida, this.playerOne, this.playerTwo,
      this.ganador, this.estado);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombrePartida": nombrePartida,
      "playerOne": playerOne,
      "playerTwo": playerTwo,
      "ganador": ganador,
      "estado": estado
    };
  }

  Partida.fromObject(dynamic o) {
    id = o["id"];
    nombrePartida = o["nombrePartida"];
    playerOne = o["playerOne"];
    playerTwo = o["playerTwo"];
    ganador = o["ganador"];
    estado = o["estado"];
    //this.edad = int.tryParse(o["edad"].toString());
  }
  @override
  String toString() {
    return 'Partida{id: $id, nombrePartida: $nombrePartida, playerOne: $playerOne, playerTwo: $playerTwo, ganador $ganador, estado: $estado}';
  }
}
