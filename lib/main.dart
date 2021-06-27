import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/CmcapVeriler.dart';
import 'package:myapp/Globals.dart' as Globals;
import 'package:myapp/firebase_sdk.dart';
import 'Ana_Sayfa.dart';
import 'Crypto.dart';
import 'Portfolio.dart';


void main() =>
  runApp(MaterialApp(
    home: Alt_Nav_Bar(),
  ));

class Alt_Nav_Bar extends StatefulWidget {
  @override
  _Alt_Nav_Bar_State createState() => _Alt_Nav_Bar_State();
}

class _Alt_Nav_Bar_State extends State<Alt_Nav_Bar> {

  Future<void> Firebase_Baslat()
  async {
    final FirebaseApp fb_app = await Firebase.
    initializeApp(options: Globals.api_cred);

    Firebase_En_Buyuk_Market_Cap_Veriyi_Cek(fb_app);
    Firebase_En_Cok_Kazanan_Kaybedenleri_Cek(fb_app);
  }

  void Firebase_En_Buyuk_Market_Cap_Veriyi_Cek(FirebaseApp app)
  {
    final DatabaseReference db = FirebaseDatabase(app: app).reference();
    db.child('cmcap_en_buyuk_market_cap').once().
    then((result) =>
    {
      this.setState(()
      {
        Globals.en_iyi_coinler = result.value;
        (context as Element).reassemble();
      })
    } );
  }
  
  void Firebase_En_Cok_Kazanan_Kaybedenleri_Cek(FirebaseApp app)
  {
    final DatabaseReference db = FirebaseDatabase(app: app).reference();
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

  @override
  void initState()
  {
    Firebase_Baslat();
    super.initState();
  }

  void Secili_Nav_Bar_idx_Degistir(int index)
  {
    setState(() {
      secili_bottom_nav_bar_index = index;
    });
  }

  //!< State
  int secili_bottom_nav_bar_index = 0;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
        backgroundColor: Color.fromRGBO(247, 147, 26, 1),
      ),

      body: Bottom_Tablar[secili_bottom_nav_bar_index],

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromRGBO(77, 77, 77, 1),),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart, color: Color.fromRGBO(77, 77, 77, 1),),
              label: 'Crypto'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet, color: Color.fromRGBO(77, 77, 77, 1),),
              label: 'Portfolio'
          ),
        ],
        elevation: 12,
        selectedItemColor: Color.fromRGBO(13, 87, 155, 1),
        backgroundColor: Color.fromRGBO(247, 147, 26, 1),
        currentIndex: secili_bottom_nav_bar_index,
        onTap: Secili_Nav_Bar_idx_Degistir,
      ),
    );
  }
}

