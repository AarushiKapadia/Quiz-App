import 'package:flutter/material.dart';
import 'package:quiz/answer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

  void _questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      // adding to the score tracker on top
      _scoreTracker.add(
        answerScore
            ? Icon(
          Icons.check_circle,
          color: Colors.green,
        )
            : Icon(
          Icons.clear,
          color: Colors.red,
        ),
      );
      //when the quiz ends
      if (_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    // what happens at the end of the quiz
    if (_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Space Quiz',
          style: TextStyle(color: Colors.black,
          fontFamily: 'Pacifico',
          fontSize: 30.0),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                if (_scoreTracker.length == 0)
                  SizedBox(
                    height: 25.0,
                  ),
                if (_scoreTracker.length > 0) ..._scoreTracker
              ],
            ),
            Container(
              width: double.infinity,
              height: 130.0,
              margin: EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  _questions[_questionIndex]['question'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Pacifico',
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...(_questions[_questionIndex]['answers']
            as List<Map<String, Object>>)
                .map(
                  (answer) => Answer(
                answerText: answer['answerText'],
                answerColor: answerWasSelected
                    ? answer['score']
                    ? Colors.green
                    : Colors.red
                    : null,
                answerTap: () {
                  // if answer was already selected then nothing happens onTap
                  if (answerWasSelected) {
                    return;
                  }
                  //answer is being selected
                  _questionAnswered(answer['score']);
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              onPressed: () {
                if (!answerWasSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Please select an answer before going to the next question'),
                  ));
                  return;
                }
                _nextQuestion();
              },
              child: Text(
                  endOfQuiz ? 'Restart Quiz' : 'Next Question',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 20.0,
              ),),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                '${_totalScore.toString()}/${_questions.length}',
                style: TextStyle(color: Colors.white,fontFamily: 'Pacifico',fontSize: 35.0,),
              ),
            ),
            if (answerWasSelected && !endOfQuiz)
              Container(
                height: 75.0,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    correctAnswerSelected
                        ? 'Correct Answer!'
                        : 'Wrong Answer!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Pacifico',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text(
                    _totalScore > 4
                        ? 'Congratulations! Your final score is: $_totalScore'
                        : ' Better luck next time! Your final score is: $_totalScore.',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Pacifico',
                      // color: _totalScore > 4 ? Colors.green : Colors.red,
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


final _questions = const [
  {
    'question': 'How many rovers are there on Mars?',
    'answers':[
      {'answerText': 'Five', 'score': true},
      {'answerText': 'Seven', 'score': false},
      {'answerText': 'Four', 'score': false},
    ],
  },

  {
    'question': 'The Giant Red Spot on Jupiter is: ',
    'answers':[
      {'answerText': 'Crater', 'score': false},
      {'answerText': 'Storm', 'score': true},
      {'answerText': 'Volcano', 'score': false},
    ],
  },

  {
    'question': 'Home of Olympus Mons is: ',
    'answers':[
      {'answerText': 'Venus', 'score': false},
      {'answerText': 'Mars', 'score': true},
      {'answerText': 'IO', 'score': false},
    ],
  },

  {
    'question': 'Smallest Moon in our Solar System is: ',
    'answers':[
      {'answerText': 'Deimos', 'score': true},
      {'answerText': 'Callisto', 'score': false},
      {'answerText': 'Europa', 'score': false},
    ],
  },

  {
    'question': 'The slowest planet is: ',
    'answers':[
      {'answerText': 'Uranus', 'score': false},
      {'answerText': 'Neptune', 'score': false},
      {'answerText': 'Venus', 'score': true},
    ],
  },

  {
    'question': 'First Woman in Space',
    'answers':[
      {'answerText': 'Sally K. Ride', 'score': false},
      {'answerText': 'Mae Jemison', 'score': false},
      {'answerText': 'Valentina Tereshkova', 'score': true},
    ],
  },

  {
    'question': 'First spacecraft to enter interstellar space is:',
    'answers':[
      {'answerText': 'Voyager 1', 'score': true},
      {'answerText': 'Pioneer 10', 'score': false},
      {'answerText': 'New Horizons', 'score': false},
    ],
  },

  {
    'question': 'Largest Moon is: ',
    'answers':[
      {'answerText': 'Rhea', 'score': false},
      {'answerText': 'Ganymede', 'score': true},
      {'answerText': 'Callisto', 'score': false},
    ],
  },

  {
    'question': 'What is a Russian Astronaut called?',
    'answers':[
      {'answerText': 'Astronaut', 'score': false},
      {'answerText': 'Cosmonaut', 'score': true},
      {'answerText': 'Rocketeer', 'score': false},
    ],
  },

  {
    'question': 'Who founded ISRO: ',
    'answers':[
      {'answerText': 'Vikram Sarabhai', 'score': true},
      {'answerText': 'Homi J. Bhabha', 'score': false},
      {'answerText': 'Satish Dhawan', 'score': false},
    ],
  },
];