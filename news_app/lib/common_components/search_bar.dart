import 'package:flutter/material.dart';
import 'package:news_app/services/sizeconfig.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController textController;
  final Function onPressed;
  SearchBar({this.textController, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 20.toWidth, vertical: 20.toHeight),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  hintText: "Enter the topic name",
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20.toWidth,
          ),
          Expanded(
            flex: 1,
            child: RaisedButton(
              child: Text(
                "Search",
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              color: Colors.orange.withOpacity(0.85),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: textController.text.isNotEmpty ? onPressed : () {},
            ),
          ),
        ],
      ),
    );
  }
}
