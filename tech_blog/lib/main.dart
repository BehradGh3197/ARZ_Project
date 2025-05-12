import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tech_blog/Model/Currency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart' hide TextDirection;
// ignore: unused_import
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('fa', '')],

      theme: ThemeData(
        fontFamily: "Vazir",
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: "Vazir",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),

          bodyLarge: TextStyle(
            fontFamily: "Vazir",
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),

          displayMedium: TextStyle(
            fontFamily: "Vazir",
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),

          displaySmall: TextStyle(
            fontFamily: "Vazir",
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),

          headlineLarge: TextStyle(
            fontFamily: "Vazir",
            fontSize: 14,
            color: Colors.green,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getResponse(BuildContext context) async {
    var url =
        "https://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url));

    print((value.statusCode));

    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        _showSnackBar(context , "بروزرسانی اطلاعات با موفقیت انجام شد");
        List jasonList = convert.jsonDecode(value.body);

        if (jasonList.isNotEmpty) {
          for (int i = 0; i < jasonList.length; i++) {
            setState(() {
              currency.add(
                Currency(
                  id: jasonList[i]["id"],
                  title: jasonList[i]["title"],
                  price: jasonList[i]["price"],
                  changes: jasonList[i]["changes"],
                  status: jasonList[i]["status"],
                ),
              );
            });
          }
        }
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    getResponse(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          const SizedBox(width: 8),
          Image.asset("assets/images/icon.png"),

          const SizedBox(width: 8),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "قیمت به روز سکه و ارز",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset("assets/images/menu.png"),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/information.png"),
                  SizedBox(width: 8),
                  Text(
                    "نرخ ارز آزاد چیست؟",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                " نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                style: Theme.of(context).textTheme.bodyLarge,
                textDirection: TextDirection.rtl,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1000)),
                    color: Color.fromARGB(255, 130, 130, 130),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "نام آزاد ارز",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Text(
                        "قیمت",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Text(
                        "تغییر",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 350,
                child: listFutureBuilder(context),
              ),
              //update button box
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 232, 232),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //update btn
                      SizedBox(
                        height: 50,
                        child: TextButton.icon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Color.fromARGB(255, 202, 193, 255),
                            ),
                          ),
                          onPressed:
                              () {
                                currency.clear();
                                listFutureBuilder(context);
                              },
                          icon: const Icon(
                            CupertinoIcons.refresh_bold,
                            color: Colors.black,
                          ),
                          label: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(
                              "بروزرسانی",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                        ),
                      ),
                      Text("آخرین بروزرسانی ${_getTime()}"),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: currency.length,
                        itemBuilder: (BuildContext context, int position) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: MyItem(position, currency),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          if (index % 9 == 0) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Add(),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      )
                      : const Center(child: CircularProgressIndicator());
                },
                future: getResponse(context),
              );
  }

  String _getTime() {
      DateTime now = DateTime.now();

    return DateFormat('kk:mm:ss').format(now);
  }
}

void _showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, style: Theme.of(context).textTheme.displayLarge),
      backgroundColor: Colors.green,
    ),
  );
}

class Add extends StatelessWidget {
  const Add({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 1.0, color: Colors.grey)],
        color: Colors.red,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("تبلیغات", style: Theme.of(context).textTheme.displayMedium),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MyItem extends StatelessWidget {
  int position;
  List<Currency> currency;

  MyItem(this.position, this.currency, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 1.0, color: Colors.grey)],
        color: Colors.white,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            currency[position].title!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            getFarsiNumber(currency[position].price.toString()),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            getFarsiNumber(currency[position].changes.toString()),
            style:
                currency[position].status == "n"
                    ? Theme.of(context).textTheme.displaySmall
                    : Theme.of(context).textTheme.headlineLarge,
          ),
        ],
      ),
    );
  }
}

String getFarsiNumber(String number){

  const en = ['0', '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9'];
  const fa = ['۰', '۱' , '۲' , '۳' , '۴' , '۵' , '۶' , '۷' , '۸' , '۹'];

  en.forEach((element) {

    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });
  return number;
}