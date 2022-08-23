import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          iconTheme: IconThemeData(color: Colors.black87),
          elevation: 0.0,
          title: Text(
            'About',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dear Users !',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                children: [
                  Text(
                    'Myself Anil Gusaiwal  bacth of Y19(IITK) , i have developed an app through which we can order the canteen items from anywhere inside the campus without any waiting of time .This facility currently is available for HALL-V . Therefore I\`m inviting to all of you for use this my idea and help to me for innovation it in future and give your response . \n WELCOME TO ALL OF YOU IN MY APP . \n \n If you have to any query please contact to me through this number 9587691547 \n \n Thanks .' ,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
