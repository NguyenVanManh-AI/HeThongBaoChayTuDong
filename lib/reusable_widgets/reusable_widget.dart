import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/screen/detail_screen.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    // color: Colors.white,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

DateTime now = DateTime.now();
String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
Container notification_frame(
    BuildContext context, String imageURL,Function onTap) {
  // String formattedDateTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  return Container(
    // padding: EdgeInsets.all(4),
    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailScreen(
                      imgURL: imageURL.substring(0,imageURL.length-19),
                      dateTime: imageURL.substring(imageURL.length-19,imageURL.length),
                      // dateTime: formattedDateTime,
                    )));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 60,
            width: 100,
            color: Colors.grey[300],
            // child: Image.network(
            //   imageURL,
            //   fit: BoxFit.cover,
            // ),
            child: Image.network(
              imageURL.substring(0,imageURL.length-19),
              fit: BoxFit.cover,
            ),
          ),
          // Icon(Icons.access_time, color: Colors.white),
          SizedBox(width: 30),
          Text(
            // '${formattedDateTime}',
            imageURL.substring(imageURL.length-19,imageURL.length),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            // return Color.fromARGB(255, 242, 186, 207);
            return Color.fromARGB(255, 234, 144, 137);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
    ),
  );
}
