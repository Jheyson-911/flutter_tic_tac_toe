import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/db/db.dart';
import 'package:flutter_tic_tac_toe/model/partida.dart';

import "package:provider/provider.dart";

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const String PLAYER_X = "X";
  static const String PLAYER_Y = "O";

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;
  late TextEditingController _playerOneController;
  late TextEditingController _playerTwoController;

  @override
  void initState() {
    _playerOneController = TextEditingController(text: "");
    _playerTwoController = TextEditingController(text: "");
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = PLAYER_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""]; //9 empty places
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("3 EN RAYA")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _inputPlayers(),
            //_headerText(),
            _gameContainer(),
            _restartButton(),
          ],
        ),
      ),
    );
  }

  Widget _inputPlayers() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
              controller: _playerOneController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text("Jugador 1"))),
          const SizedBox(
            height: 20,
          ),
          TextField(
              controller: _playerTwoController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text("Jugador 2"))),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.lightBlue[900]),
              onPressed: () async {
                // Partida p = new Partida(1, "", _playerOneController.text,
                //     _playerTwoController.text, "", "");
                // var api =
                //     await Provider.of<DB>(context, listen: false).insert(p);

                // var response =
                //     await Provider.of<DB>(context, listen: false).partidas();
                // print(api);
                print(_playerOneController.text);
                print(_playerTwoController.text);
              },
              child: Text("Comenzar"))
        ],
      ),
    );
  }

  // Widget _headerText() {
  //   return Column(
  //     children: [
  //       const Text(
  //         "Tic Tac Toe",
  //         style: TextStyle(
  //           color: Colors.green,
  //           fontSize: 32,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       Text(
  //         "$currentPlayer turn",
  //         style: const TextStyle(
  //           color: Colors.black87,
  //           fontSize: 32,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, int index) {
            return _box(index);
          }),
    );
  }

  Widget _box(int index) {
    return InkWell(
      onTap: () {
        //on click of box
        if (gameEnd || occupied[index].isNotEmpty) {
          //Return if game already ended or box already clicked
          return;
        }

        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkForWinner();
          checkForDraw();
        });
      },
      child: Container(
        color: occupied[index].isEmpty
            ? Colors.black26
            : occupied[index] == PLAYER_X
                ? Colors.lightBlue[900]
                : Colors.lightBlue[900],
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style: TextStyle(
                fontSize: 50,
                color: occupied[index] == PLAYER_X ? Colors.red : Colors.white),
          ),
        ),
      ),
    );
  }

  _restartButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        child: const Text("Restart Game"));
  }

  changeTurn() {
    if (currentPlayer == PLAYER_X) {
      currentPlayer = PLAYER_Y;
    } else {
      currentPlayer = PLAYER_X;
    }
  }

  checkForWinner() {
    //Define winning positions
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var winningPos in winningList) {
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          //all equal means player won
          if (playerPosition0 == "X") {
            var playerwin = _playerOneController.text;
            showGameOverMessage("$playerwin Ganó");
          } else {
            var playerwin = _playerTwoController.text;
            showGameOverMessage("$playerwin Ganó");
          }
          gameEnd = true;
          return;
        }
      }
    }
  }

  checkForDraw() {
    if (gameEnd) {
      return;
    }
    bool draw = true;
    for (var occupiedPlayer in occupied) {
      if (occupiedPlayer.isEmpty) {
        //at least one is empty not all are filled
        draw = false;
      }
    }

    if (draw) {
      showGameOverMessage("Empate");
      gameEnd = true;
    }
  }

  showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "$message",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          )),
    );
  }
}
