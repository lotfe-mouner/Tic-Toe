import 'package:app/game_logic.dart';
import 'package:flutter/material.dart';
import 'game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [
                  ...firstBlock(),
                  _expanded(context),
                  ...lastBlock(),
                ],
              )
            :Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...firstBlock(),
                          ...lastBlock(),
                        ],
                      ),
                  ),
                  _expanded(context),
                ],
              ),
      ),
    );
  }

  List<Widget> firstBlock() {
    return [
      SwitchListTile.adaptive(
        value: isSwitched,
        onChanged: (bool newVal) {
          setState(() {
            isSwitched = newVal;
          });
        },
        title: const Text(
          'Turn on/off two \n player',
          style: TextStyle(color: Colors.white, fontSize: 28),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 20,),
      Text(
        "It's $activePlayer turn".toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 48),
        textAlign: TextAlign.center,
      )
    ];
  }

  List<Widget> lastBlock() {
    return [
      Text(
        result,
        style: const TextStyle(color: Colors.white, fontSize: 48),
        textAlign: TextAlign.center,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).splashColor)),
          onPressed: () {
            setState(() {
              Player.playerX = [];
              Player.playerO = [];
              activePlayer = 'X';
              gameOver = false;
              turn = 0;
              result = '';
            });
          },
          icon: const Icon(Icons.replay),
          label: const Text('Repeat the game'),
        ),
      ),
    ];
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
        child: GridView.count(
            padding: const EdgeInsets.all(16.0),
            crossAxisCount: 3,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 1.0,
            children: List.generate(
                9,
                (index) => InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      onTap: gameOver ? null : () => onTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                            child: Text(
                          Player.playerX.contains(index)
                              ? 'X'
                              : Player.playerO.contains(index)
                                  ? 'O'
                                  : '',
                          style: TextStyle(
                              color: Player.playerX.contains(index)
                                  ? Colors.blue
                                  : Colors.pink,
                              fontSize: 52),
                        )),
                      ),
                    ))));
  }

  onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      Update_state();

      if (!isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        Update_state();
      }
    }
  }

  void Update_state() {
    setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn++;
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = '$winnerPlayer is the Winner';
      } else if (!gameOver && turn == 9) {
        result = "It's a Draw";
      }
    });
  }
}
