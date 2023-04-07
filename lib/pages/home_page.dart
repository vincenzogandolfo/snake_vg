import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/blank_pixel.dart';
import '../models/food_pixel.dart';
import '../models/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum SnakeDirection { up, down, right, left }

class _HomePageState extends State<HomePage> {
  // Dimensioni Griglia
  int rowSize = 10;
  int totalSquare = 100;

  // Controllo se il Gioco è iniziato
  bool gameIsStarted = false;

  // Punteggio Utente
  int currentScore = 0;

  // Posizione Snake
  List<int> snakePosition = [0, 1, 2];

  // Variabile con Direzione Iniziale verso Destra (right)
  var currentDirection = SnakeDirection.right;

  // Posizione Food
  int foodPosition = 55;

  // Funzione che fa iniziare il Gioco
  void playGame() {
    gameIsStarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        // Snake si muove
        moveSnake();

        // Controlla se il gioco è Game Over
        if (gameOver()) {
          timer.cancel();

          // Mostra un Messaggio all'utente se Game Over
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.grey.shade400,
                  title: Center(
                    child: Column(
                      children: [
                        const Text(
                          'Game Over',
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Punteggio: $currentScore',
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        newGame();
                      },
                      color: Colors.deepPurpleAccent,
                      child: Center(
                        child: Text(
                          'New Game',
                          style: TextStyle(
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
        }
      });
    });
  }

  // Funzione che fa muovere Snake
  void moveSnake() {
    switch (currentDirection) {
      // Destra
      case SnakeDirection.right:
        {
          // Aggiunge un pixel in cima (destra)

          // Quando arriva alla Colonna 9 della Row (Muro di Destra)
          // Non prosegue verso la Row in basso,
          // ma ricomincia a Sinistra dalla stessa Row (- rowSize)
          if (snakePosition.last % rowSize == 9) {
            snakePosition.add(snakePosition.last + 1 - rowSize);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
        }
        break;
      // Sinistra
      case SnakeDirection.left:
        {
          // Aggiunge un pixel in cima (sinistra)

          // Quando arriva alla Colonna 0 della Row (Muro di Sinistra)
          // Non prosegue verso la Row in alto,
          // ma ricomincia a Destra dalla stessa Row (+ rowSize)
          if (snakePosition.last % rowSize == 0) {
            snakePosition.add(snakePosition.last - 1 + rowSize);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
        }
        break;
      // in Alto
      case SnakeDirection.up:
        {
          // Aggiunge un pixel nella Row in Alto

          // Quando arriva alla Row 0 (Muro in Alto)
          // Non prosegue verso la Row in Alto (non visibile),
          // ma ricomincia dall'ultima Row in Basso (+ totalSquare)
          if (snakePosition.last < rowSize) {
            snakePosition.add(snakePosition.last - rowSize + totalSquare);
          } else {
            snakePosition.add(snakePosition.last - rowSize);
          }
        }
        break;
      // in Basso
      case SnakeDirection.down:
        {
          // Aggiunge un pixel nella Row in Basso

          // Quando arriva alla Row 9 (Muro in Basso)
          // Non prosegue verso la Row in Basso (non visibile),
          // ma ricomincia dalla prima Row in Alto (- totalSquare)
          if (snakePosition.last + rowSize > totalSquare) {
            snakePosition.add(snakePosition.last + rowSize - totalSquare);
          } else {
            snakePosition.add(snakePosition.last + rowSize);
          }
        }
        break;
      default:
    }
    // Controllo se Snake mangia il Food
    if (snakePosition.last == foodPosition) {
      // Se Snake Mangia il Food (stessa posizione)
      // la catena di Pixel (Snake) aumenta di 1 (snakePosition.add)
      // e il Food verrà ricreato in un'altra Posizione (eatFood)
      eatFood();
    } else {
      // Altrimenti Rimuove un pixel in fondo
      // Rimanendo con la stessa quantità di Pixel
      snakePosition.removeAt(0);
    }
  }

  // Se il Food viene mangiato
  // viene ricreato in posizione Random dentro totalSquare
  void eatFood() {
    // Conteggio dei Pixel "mangiati"
    currentScore++;
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(totalSquare);
    }
  }

  // Game Over
  bool gameOver() {
    // Il gioco termina se Snake si tocca con se stesso
    // ovvero se Una posizione di un suo pixel è Duplicata

    // Questa List rappresenta il corpo dello Snake senza Testa
    List<int> bodySnake = snakePosition.sublist(
      0,
      snakePosition.length - 1,
    );

    if (bodySnake.contains(snakePosition.last)) {
      return true;
    }
    return false;
  }

  // Funzione che fa Ricominciare il Gioco
  void newGame() {
    setState(() {
      snakePosition = [
        0,
        1,
        2,
      ];
      foodPosition = 55;
      currentDirection = SnakeDirection.right;
      gameIsStarted = false;
      currentScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 10,
          centerTitle: true,
          title: const Text(
            'Snake VG',
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
        body: Column(
          children: [
            // Punteggio
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Punteggio',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentScore.toString(),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Schermata di Gioco
            Expanded(
              flex: 3,
              // Utilizzato per spostare lo Snake
              // in base alla zona dove l'Utente tocca
              child: GestureDetector(
                // Movimento Verticale
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 &&
                      currentDirection != SnakeDirection.up) {
                    // Verso il Basso
                    currentDirection = SnakeDirection.down;
                  } else if (details.delta.dy < 0 &&
                      currentDirection != SnakeDirection.down) {
                    // Verso l'Alto
                    currentDirection = SnakeDirection.up;
                  }
                },
                // Movimento Orizzontale
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 &&
                      currentDirection != SnakeDirection.left) {
                    // Verso Destra
                    currentDirection = SnakeDirection.right;
                  } else if (details.delta.dx < 0 &&
                      currentDirection != SnakeDirection.right) {
                    // Verso Sinistra
                    currentDirection = SnakeDirection.left;
                  }
                },
                child: GridView.builder(
                    itemCount: totalSquare,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize,
                    ),
                    itemBuilder: (context, index) {
                      if (snakePosition.contains(index)) {
                        return const SnakePixel();
                      } else if (foodPosition == index) {
                        return const FoodPixel();
                      } else {
                        return const BlankPixel();
                      }
                    }),
              ),
            ),
            // Pulsante Play
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(20),
                    color:
                        gameIsStarted ? Colors.grey : Colors.deepPurpleAccent,
                    onPressed: gameIsStarted ? () {} : playGame,
                    child: Text(
                      'Gioca',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
