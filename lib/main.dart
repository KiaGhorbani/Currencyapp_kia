import 'package:first_project/Model/Currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

void main() {
  runApp(const Kiapp());
}

class Kiapp extends StatelessWidget {
  const Kiapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fa', ''), // farsi
        ],
        theme: ThemeData(
            fontFamily: 'Kiafont',
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontFamily: 'Kiafont',
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
              displayMedium: TextStyle(
                fontFamily: 'Kiafont',
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
              bodyLarge: TextStyle(
                  fontFamily: 'Kiafont',
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.w300),
              bodyMedium: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Kiafont',
                  fontSize: 20,
                  fontWeight: FontWeight.w300),
              headlineMedium: TextStyle(
                  fontFamily: 'Kiafont',
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.w300),
              headlineSmall: TextStyle(
                  fontFamily: 'Kiafont',
                  color: Colors.green,
                  fontSize: 21,
                  fontWeight: FontWeight.w300),
            )),
        debugShowCheckedModeBanner: false,
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getResponse(BuildContext cntx) async {
    var url =
        "https://sasansafari.com/flutter/api.php?access_key=flutter123456";

    var value = await http.get(Uri.parse(url));

    developer.log(value.body, name: "getResponse");

    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        // ignore: use_build_context_synchronously
        _Snackbar(context, "اطلاعات با موفقیت بروز شد");
        developer.log(value.body,
            name: "error catcher", error: convert.jsonDecode(value.body));
        List jsonList = convert.jsonDecode(value.body);

        if (jsonList.isNotEmpty) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(() {
              currency.add(Currency(
                  id: jsonList[i]["id"],
                  title: jsonList[i]["title"],
                  price: jsonList[i]["price"],
                  changes: jsonList[i]["changes"],
                  status: jsonList[i]["status"]));
            });
          }
        }
      }
    }
    return value;
  }

  @override
  void initState() {
    super.initState();
    getResponse(context);
    developer.log("initial", name: "getResopnse");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        appBar:
            AppBar(elevation: 0, backgroundColor: Colors.lightBlue, actions: [
          const SizedBox(
            width: 10,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Image.asset(height: 60, "assets/images/Appbar 2.png")),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "از امروز چه خبر؟ ",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ))),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(height: 50, "assets/images/menu.png"))),
        ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                //Body image
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(height: 50, "assets/images/title2.png")
                  ],
                ),
                //Body Header
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "در این اپلیکیشن فعلا ارزهایی نظیر درهم امارات و دلار آمریکا و یورو و لیر ترکیه و دلار استرالیا و دینار عراق و دلار کانادا قرار گرفته است.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                //List
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                  child: Container(
                      width: double.infinity,
                      height: 35,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Color.fromARGB(255, 143, 143, 143),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "نام آزاد ارز",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text("قیمت",
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text(
                            "تغییرات به درصد",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      )),
                ),
                SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.97,
                    // color: Colors.blueAccent, برای تست مقدار ارتفاع
                    child: FutureBuilder(
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: currency.length,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 9, 0, 0),
                                    child: Items(position, currency),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  if (index % 10 == 0) {
                                    return const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 9, 0, 0),
                                        child: Ad());
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                      future: getResponse(context),
                    )),
                //Update Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: const Color.fromARGB(255, 232, 232, 232)),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 90,
                          child: TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      const Color.fromARGB(255, 202, 193, 255)),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(1000)))),
                              onPressed: () {
                                currency.clear();
                                FutureBuilder(
                                    builder: (context, snapshot) {
                                      return snapshot.hasData
                                          ? ListView.separated(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: currency.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int position) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 9, 0, 0),
                                                  child:
                                                      Items(position, currency),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                if (index % 10 == 0) {
                                                  return const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 9, 0, 0),
                                                      child: Ad());
                                                } else {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                              },
                                            )
                                          : const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                    },
                                    future: getResponse(context));
                              },
                              icon: const Icon(
                                CupertinoIcons.refresh_thick,
                                color: Colors.black,
                              ),
                              label: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text(
                                  "بروزرسانی",
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                              )),
                        ),
                        //Last update
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 0, 3, 0),
                          child: Text(
                            "آخرین بروزرسانی ${_gettime()}",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  String _gettime() {
    DateTime now = DateTime.now();

    return DateFormat('kk:mm').format(now);
  }
}

// ignore: non_constant_identifier_names
void _Snackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        message,
        style: Theme.of(context).textTheme.displayLarge,
      )));
}

// ignore: must_be_immutable
class Items extends StatelessWidget {
  int position;
  List<Currency> currency;

  Items(this.position, this.currency, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 1.0, color: Colors.grey)
        ], borderRadius: BorderRadius.circular(1000), color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              currency[position].title!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              // farsinum(currency[position].price.toString()),
              currency[position].price!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
                // farsinum(currency[position].changes.toString()),
                currency[position].changes!,
                style: currency[position].status == "n"
                    ? Theme.of(context).textTheme.headlineMedium
                    : Theme.of(context).textTheme.headlineSmall),
          ],
        ));
  }
}

class Ad extends StatelessWidget {
  const Ad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 1.0, color: Colors.grey)
        ], borderRadius: BorderRadius.circular(1000), color: Colors.red),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("تبلیغات", style: Theme.of(context).textTheme.displayLarge)
          ],
        ));
  }
}

// String farsinum(String number){

// const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
// const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

// en.forEach((element) {
  
// number = element.replaceAll(element, fa[en.indexOf(element)]);

// });


//   return number;
// }
