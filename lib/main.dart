import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/CmcapVeriler.dart';
import 'package:myapp/Globals.dart' as Globals;
import 'package:myapp/firebase_sdk.dart';
import 'Ana_Sayfa.dart';
import 'Crypto.dart';
import 'Portfolio.dart';
import 'Global.dart';


void main() =>
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Alt_Nav_Bar(),
  ));

class Alt_Nav_Bar extends StatefulWidget {
  @override
  _Alt_Nav_Bar_State createState() => _Alt_Nav_Bar_State();
}

class _Alt_Nav_Bar_State extends State<Alt_Nav_Bar> {

  late final FirebaseApp fb_app;

  Future<void> Firebase_Baslat()
  async
  {
    this.fb_app = await Firebase.
    initializeApp(options: Globals.api_cred);

    Firebase_En_Buyuk_Market_Cap_Veriyi_Cek();
    Firebase_En_Cok_Kazanan_Kaybedenleri_Cek();
    Firebase_Global_Veriyi_Cek();
  }

  Future<void> Tum_Firebase_Datasini_Guncelle()
  async
  {
    Firebase_En_Buyuk_Market_Cap_Veriyi_Cek();
    Firebase_En_Cok_Kazanan_Kaybedenleri_Cek();
    Firebase_Global_Veriyi_Cek();
  }

  void Firebase_En_Buyuk_Market_Cap_Veriyi_Cek()
  {
    final DatabaseReference db = FirebaseDatabase(app: this.fb_app).reference();
    db.child('cmcap_en_buyuk_market_cap').once().
    then((result) =>
    {
      this.setState(()
      {
        Globals.en_iyi_coinler = result.value;
        (context as Element).reassemble();
      })
    } ).
    catchError((e) =>
    {
    });
  }

  void Firebase_En_Cok_Kazanan_Kaybedenleri_Cek()
  {
    final DatabaseReference db = FirebaseDatabase(app: this.fb_app).reference();
    db.child('cmcap_max_artan_azalan').once().
    then((result) =>
    {
      this.setState(()
      {
        Globals.max_artan_azalan_coinler = result.value;
        (context as Element).reassemble();
      })
    });
  }

  void Firebase_Global_Veriyi_Cek()
  {
    final DatabaseReference db = FirebaseDatabase(app: this.fb_app).reference();
    db.child('cmcap_global_olcumler').once().
    then((result) =>
    {
      this.setState(() {
        Globals.global_olcumler.add(result.value);
        (context as Element).reassemble();
      })
    });
  }

  @override
  void initState()
  {
    Firebase_Baslat();
    super.initState();
  }

  void Widgettan_Secili_Nav_Bar_idx_Degistir(int index)
  {
    setState(() {
      secili_bottom_nav_bar_index = index;
    });
  }

  void Secili_Nav_Bar_idx_Degistir(int index)
  {
    setState(() {
      secili_bottom_nav_bar_index = index;
    });
  }

  //!< State
  int secili_bottom_nav_bar_index = 0;
  String baslik_metin = '';

  final Bottom_Tablar = [
    //!< Anasayfa tabi
    Ana_Sayfa(),
    //!< crypto tabi
    Crypto(),
    //!< Portfolio tabi
    Portfolio(),
  ];

  @override
  Widget build(BuildContext context) {

    this.setState(() {
      switch(secili_bottom_nav_bar_index)
      {
        case 0:
        {
          setState(() {baslik_metin = "Ana Sayfa";});
          break;
        }case 1:
        {
          setState(() {baslik_metin = "Kripto";});
          break;
        }
        case 2:
        {
          setState(() {baslik_metin = "Alarm Kur";});
          break;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(baslik_metin,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800
                    ),
                ),
        backgroundColor: Color.fromRGBO(247, 147, 26, 1),
        toolbarHeight: 40,
      ),

      body:
      RefreshIndicator(
          child:
          Stack(
            key: UniqueKey(),
            children: <Widget>[ListView(), Bottom_Tablar[secili_bottom_nav_bar_index]],
          ),
          onRefresh: Tum_Firebase_Datasini_Guncelle
      ),

      bottomNavigationBar: SizedBox(
        height: 54,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromRGBO(77, 77, 77, 1),),
              label: '',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart, color: Color.fromRGBO(77, 77, 77, 1),),
                label: ''
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet, color: Color.fromRGBO(77, 77, 77, 1),),
                label: ''
            ),

          ],
          elevation: 4,
          selectedItemColor: Color.fromRGBO(13, 87, 155, 1),
          backgroundColor: Color.fromRGBO(247, 147, 26, 1),
          currentIndex: secili_bottom_nav_bar_index,
          onTap: Secili_Nav_Bar_idx_Degistir,
          type: BottomNavigationBarType.fixed,
        ),
      )
    );
  }
}

