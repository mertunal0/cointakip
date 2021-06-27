import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/CmcapVeriler.dart';
import 'package:myapp/Globals.dart' as Globals;
import 'package:myapp/firebase_sdk.dart';

class Ana_Sayfa extends StatefulWidget {
  @override
  _Ana_SayfaState createState() => _Ana_SayfaState();
}

class _Ana_SayfaState extends State<Ana_Sayfa> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100 * 2,
      margin: EdgeInsets.all(8),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Text(
                'En Büyükler',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
              shadowColor: Colors.transparent,
              color: Colors.transparent,
            ),

            Expanded(
                child: ListView.builder(
                    itemCount: Globals.en_iyi_coinler.length > 0 ? 10 : 0,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int i) {

                      double coin_deger = Globals.en_iyi_coinler[i]['quote']['USD']['price'];
                      int coin_deger_tmp = coin_deger.toInt();
                      int virgulden_sonraki_bas_sayisi = 7;
                      int coin_deger_basamak = 0;

                      while(coin_deger_tmp != 0)
                      {
                        coin_deger_basamak++;
                        coin_deger_tmp = coin_deger_tmp ~/ 10;
                      }

                      virgulden_sonraki_bas_sayisi = 7 - coin_deger_basamak;

                      String coin_deger_str = coin_deger.toStringAsFixed(virgulden_sonraki_bas_sayisi);

                      bool deger_son_saatte_artmis_mi = Globals.en_iyi_coinler[i]['quote']['USD']['percent_change_1h'] >= 0;

                      String fiyat_oku_sonucu = "down_arrow.png";
                      if(deger_son_saatte_artmis_mi)
                      {
                        fiyat_oku_sonucu = "up_arrow.png";
                      }
                      return Container(
                        height: 84.0,
                        width: 84.0,
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                //!< Kart icindeki 1. kolon
                                children: [
                                  Image.asset( 'assets/crypto_icons/'+Globals.en_iyi_coinler[i]['symbol'].toString().toLowerCase()+'.png',
                                    height: 24,
                                    width: 24,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Image.asset("assets/default_coin_icon.png",
                                          height: 24,
                                          width: 24,),
                                  ),
                                  Text(Globals.en_iyi_coinler[i]['symbol'],
                                      style: TextStyle( fontSize: 14, fontWeight: FontWeight.w800))
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              ),
                              Container(
                                child: Row(
                                  //!< Kart içindeki 2. kolon
                                  children: [
                                    Text('\$'+coin_deger_str,
                                      style: TextStyle(fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(77, 77, 77, 1)),),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Card(
                                      elevation: 0,
                                      child: Image.asset('assets/'+fiyat_oku_sonucu,
                                        height: 8,
                                        width: 8,
                                        color: deger_son_saatte_artmis_mi ? Colors.green : Colors.red,
                                      ),
                                      margin: EdgeInsets.fromLTRB(0, 0, 2, 1),
                                      shadowColor: Colors.transparent,
                                    ),
                                    Text(Globals.en_iyi_coinler[i]['quote']['USD']['percent_change_1h'].toStringAsFixed(2)+'%',
                                      style: TextStyle(fontSize: 10,

                                          color: deger_son_saatte_artmis_mi ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold),)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                )
            ),

            //!< En cok artan azalan kismi
            Card(
              child: Text(
                'En Çok Değişenler',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              margin: EdgeInsets.fromLTRB(4, 6, 0, 0),
              shadowColor: Colors.transparent,
              color: Colors.transparent,
            ),

            Expanded(
                child: ListView.builder(
                    itemCount: Globals.max_artan_azalan_coinler.length > 0 ? 10: 0,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int i) {

                      double coin_deger = Globals.max_artan_azalan_coinler[i]['quote']['USD']['price'];
                      int coin_deger_tmp = coin_deger.toInt();
                      int virgulden_sonraki_bas_sayisi = 7;
                      int coin_deger_basamak = 0;

                      while(coin_deger_tmp != 0)
                      {
                        coin_deger_basamak++;
                        coin_deger_tmp = coin_deger_tmp ~/ 10;
                      }

                      virgulden_sonraki_bas_sayisi = 7 - coin_deger_basamak;

                      String coin_deger_str = coin_deger.toStringAsFixed(virgulden_sonraki_bas_sayisi);

                      bool deger_son_saatte_artmis_mi = Globals.max_artan_azalan_coinler[i]['quote']['USD']['percent_change_1h'] >= 0;

                      String fiyat_oku_sonucu = "down_arrow.png";
                      if(deger_son_saatte_artmis_mi)
                      {
                        fiyat_oku_sonucu = "up_arrow.png";
                      }
                      return Container(
                        height: 84.0,
                        width: 84.0,
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                //!< Kart icindeki 1. kolon
                                children: [
                                  Image.asset( 'assets/crypto_icons/'+Globals.max_artan_azalan_coinler[i]['symbol'].toString().toLowerCase()+'.png',
                                    height: 24,
                                    width: 24,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Image.asset("assets/default_coin_icon.png",
                                          height: 24,
                                          width: 24,),
                                  ),
                                  Text(Globals.max_artan_azalan_coinler[i]['symbol'],
                                      style: TextStyle( fontSize: 14, fontWeight: FontWeight.w800))
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              ),
                              Container(
                                child: Row(
                                  //!< Kart içindeki 2. kolon
                                  children: [
                                    Text('\$'+coin_deger_str,
                                      style: TextStyle(fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(77, 77, 77, 1)),),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Card(
                                      elevation: 0,
                                      child: Image.asset('assets/'+fiyat_oku_sonucu,
                                        height: 8,
                                        width: 8,
                                        color: deger_son_saatte_artmis_mi ? Colors.green : Colors.red,
                                      ),
                                      margin: EdgeInsets.fromLTRB(0, 0, 2, 1),
                                      shadowColor: Colors.transparent,
                                    ),
                                    Text(Globals.max_artan_azalan_coinler[i]['quote']['USD']['percent_change_1h'].toStringAsFixed(2)+'%',
                                      style: TextStyle(fontSize: 10,

                                          color: deger_son_saatte_artmis_mi ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold),)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                )
            )
          ]
      ),
    );
  }
}