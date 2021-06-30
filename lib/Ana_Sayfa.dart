import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/CmcapVeriler.dart';
import 'package:myapp/Globals.dart' as Globals;
import 'package:myapp/firebase_sdk.dart';
import 'ScrollingText.dart';
import 'Global.dart';

class Ana_Sayfa extends StatefulWidget {
  //late final ValueChanged<int> update_nav_id;
  //Ana_Sayfa({required this.update_nav_id});

  @override
  _Ana_SayfaState createState() => _Ana_SayfaState();
}

class _Ana_SayfaState extends State<Ana_Sayfa> {

  String kayan_text_str = '';

  @override
  Widget build(BuildContext context) {

    if(false == Globals.global_olcumler.isEmpty)
    {
      String aktif_coin_sayisi_str = Globals.global_olcumler[0]['active_cryptocurrencies'].toString();

      double btc_dominance = Globals.global_olcumler[0]['btc_dominance'];
      String btc_dominance_str = btc_dominance.toStringAsFixed(3);


      //!< Total market cap
      double toplam_coin_piyasa_degeri = Globals.global_olcumler[0]['quote']['USD']['total_market_cap'];
      int    toplam_coin_piyasa_degeri_tmp = toplam_coin_piyasa_degeri.toInt();
      String toplam_coin_piyasa_degeri_str = '';
      String total_market_cap_sonuna_gelecek = '';
      int    total_market_cap_basamak_sayisi = 0;

      while(toplam_coin_piyasa_degeri_tmp != 0)
      {
        total_market_cap_basamak_sayisi++;

        toplam_coin_piyasa_degeri_tmp = toplam_coin_piyasa_degeri_tmp ~/ 10;
      }

      if(total_market_cap_basamak_sayisi > 12)
      {
        total_market_cap_sonuna_gelecek = 'Tr';
        toplam_coin_piyasa_degeri /= 1000000000000;
      }
      else if(total_market_cap_basamak_sayisi > 9)
      {
        total_market_cap_sonuna_gelecek = 'Bn';
        toplam_coin_piyasa_degeri /= 1000000000;
      }
      else if(total_market_cap_basamak_sayisi > 6)
      {
        total_market_cap_sonuna_gelecek = 'Mn';
        toplam_coin_piyasa_degeri /= 1000000;
      }
      toplam_coin_piyasa_degeri_str = toplam_coin_piyasa_degeri.toStringAsFixed(5);


      //!< 24h Total Volume
      double toplam_hacim_degeri = Globals.global_olcumler[0]['quote']['USD']['total_volume_24h'];
      int    toplam_hacim_degeri_tmp = toplam_hacim_degeri.toInt();
      String toplam_hacim_degeri_str = '';
      String total_volume_sonuna_gelecek = '';
      int    total_volume_basamak_sayisi = 0;

      while(toplam_hacim_degeri_tmp != 0)
      {
        total_volume_basamak_sayisi++;

        toplam_hacim_degeri_tmp = toplam_hacim_degeri_tmp ~/ 10;
      }

      if(total_volume_basamak_sayisi > 12)
      {
        total_volume_sonuna_gelecek = 'Tr';
        toplam_hacim_degeri /= 1000000000000;
      }
      else if(total_volume_basamak_sayisi > 9)
      {
        total_volume_sonuna_gelecek = 'Bn';
        toplam_hacim_degeri /= 1000000000;
      }
      else if(total_volume_basamak_sayisi > 6)
      {
        total_volume_sonuna_gelecek = 'Mn';
        toplam_hacim_degeri /= 1000000;
      }
      toplam_hacim_degeri_str = toplam_hacim_degeri.toStringAsFixed(5);


      kayan_text_str += "Dünyadaki Aktif Coin Sayısı: " + aktif_coin_sayisi_str + "   •   ";
      kayan_text_str += "Bitcoin Dominansı: " + btc_dominance_str +"%" + "   •   ";
      kayan_text_str += "Toplam Coin Piyasası Değeri: \$" + toplam_coin_piyasa_degeri_str + " " + total_market_cap_sonuna_gelecek + "   •   ";
      kayan_text_str += "Son 24 Saatteki Hacim :\$" + toplam_hacim_degeri_str + " " + total_volume_sonuna_gelecek + "   •   ";

    }

    return Container(
      height: 100 * 2 + 36,
      margin: EdgeInsets.all(8),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //!< Genel olcumler
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              height: 28,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(77, 77, 77, 1)),
                  color: Color.fromRGBO(77, 77, 77, 1),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Global()),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child:
                    ScrollingText(
                      text: kayan_text_str,
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )
                    )
                  ],
                ),
              )
            ),

            //!< En buyukler
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

                      double coin_deger = Globals.en_iyi_coinler[i]['quotes']['USD']['price'];
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

                      bool deger_son_saatte_artmis_mi = Globals.en_iyi_coinler[i]['quotes']['USD']['percent_change_1h'] >= 0;

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
                                    Text(Globals.en_iyi_coinler[i]['quotes']['USD']['percent_change_1h'].toStringAsFixed(2)+'%',
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

                      double coin_deger = Globals.max_artan_azalan_coinler[i]['quotes']['USD']['price'];
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

                      bool deger_son_saatte_artmis_mi = Globals.max_artan_azalan_coinler[i]['quotes']['USD']['percent_change_1h'] >= 0;

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
                                  Image.asset( 'assets/crypto_icons/'+ Globals.max_artan_azalan_coinler[i]['symbol'].toString().toLowerCase()+'.png',
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
                                    Text(Globals.max_artan_azalan_coinler[i]['quotes']['USD']['percent_change_1h'].toStringAsFixed(2)+'%',
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