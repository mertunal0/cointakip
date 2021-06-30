import 'package:flutter/material.dart';
import 'package:myapp/Globals.dart' as Globals;

class Global extends StatefulWidget {
  @override
  _GlobalState createState() => _GlobalState();
}

class _GlobalState extends State<Global> {

  String Sayiyi_Para_Formatina_Cevir(double gelen_sayi, int virgulden_sonraki_basamak_sayisi, bool tam_sayi_mi)
  {
    String dondurulecek_str = '';
    double gelen_sayi_tmp = gelen_sayi;
    int gelen_sayi_int = gelen_sayi.toInt();
    int gelen_sayi_basamak_sayisi = 0;
    int stringe_eklenecek = 0;

    double gelen_sayi_virgulden_sonrasi = gelen_sayi % 1;

    while(gelen_sayi_int != 0)
    {
      gelen_sayi_basamak_sayisi++;
      gelen_sayi_int = gelen_sayi_int ~/ 10;
    }

    gelen_sayi_int = gelen_sayi.toInt();

    if(gelen_sayi_basamak_sayisi > 3)
    {
      for(int i = 3; i<gelen_sayi_basamak_sayisi; i=i+3)
      {
        dondurulecek_str = ',' + (gelen_sayi_int % 1000).toString() + dondurulecek_str;

        gelen_sayi_int = gelen_sayi_int ~/ 1000;
      }

      if(tam_sayi_mi == false)
      {
        dondurulecek_str = gelen_sayi_int.toString() + dondurulecek_str + gelen_sayi_virgulden_sonrasi.toStringAsFixed(virgulden_sonraki_basamak_sayisi);
      }
      else
      {
        dondurulecek_str = gelen_sayi_int.toString() + dondurulecek_str;
      }
    }
    else
    {
      dondurulecek_str = gelen_sayi.toStringAsFixed(virgulden_sonraki_basamak_sayisi);
    }


    return dondurulecek_str;
  }

  @override
  Widget build(BuildContext context) {
    return
        Card(
            margin: EdgeInsets.fromLTRB(6, 24, 6, 4),
            elevation: 0,
            color: Colors.transparent,
            child:
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(flex: 2, child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Color.fromRGBO(247, 147, 26, 1),
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text("Küresel Değerler",
                              style:
                              TextStyle(
                                  fontSize : 14,
                                  color: Color.fromRGBO(247, 147, 26, 1),
                                  fontWeight: FontWeight.w800
                              ),)
                          ]),
                        ],
                      ),
                    ],
                  )),

                  Divider(height: 2, color: Color.fromRGBO(247, 147, 26, 1)),

                  //!< 1. satir
                  Expanded(flex: 3, child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text("\$"+Sayiyi_Para_Formatina_Cevir(Globals.global_olcumler[0]['quote']['USD']['total_market_cap'], 3, false),
                              style:
                              TextStyle(
                                  fontSize : 11,
                                  color: Color.fromRGBO(247, 147, 26, 1),
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ]),
                          Row(children: [
                            Text("Toplam Piyasa Değeri (USD)",
                              style:
                              TextStyle(
                                  fontSize : 10,
                                  color: Color.fromRGBO(247, 147, 26, 0.6),
                              ),
                            )
                          ]),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text("\$"+Sayiyi_Para_Formatina_Cevir(Globals.global_olcumler[0]['quote']['USD']['total_volume_24h'], 3, false),
                              style:
                              TextStyle(
                                  fontSize : 11,
                                  color: Color.fromRGBO(247, 147, 26, 1),
                                  fontWeight: FontWeight.bold
                              ),)
                          ]),
                          Row(children: [
                            Text("24 Saat Toplam Hacim (USD)",
                              style:
                              TextStyle(
                                  fontSize : 10,
                                  color: Color.fromRGBO(247, 147, 26, 0.6),
                              ),)
                          ]),
                        ],
                      ),
                    ],
                  )),

                  Divider(height: 2, color: Color.fromRGBO(247, 147, 26, 0.3)),

                  //!< 2. satir
                  Expanded(flex: 3, child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text(Sayiyi_Para_Formatina_Cevir(Globals.global_olcumler[0]['btc_dominance'], 2, false) + "%",
                              style:
                              TextStyle(
                                  fontSize : 11,
                                  color: Color.fromRGBO(247, 147, 26, 1),
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ]),
                          Row(children: [
                            Text("BTC Dominansı",
                              style:
                              TextStyle(
                                  fontSize : 10,
                                  color: Color.fromRGBO(247, 147, 26, 0.6),
                              ),
                            )
                          ]),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text(Sayiyi_Para_Formatina_Cevir(Globals.global_olcumler[0]['eth_dominance'], 2, false) + "%",
                              style:
                              TextStyle(
                                  fontSize : 11,
                                  color: Color.fromRGBO(247, 147, 26, 1),
                                  fontWeight: FontWeight.bold
                              ),)
                          ]),
                          Row(children: [
                            Text("ETH Dominansı",
                              style:
                              TextStyle(
                                  fontSize : 10,
                                  color: Color.fromRGBO(247, 147, 26, 0.6),
                              ),)
                          ]),
                        ],
                      ),
                    ],
                  )),

                  Divider(height: 2, color: Color.fromRGBO(247, 147, 26, 0.3)),

                  //!< 3. satir
                  Expanded(flex: 3, child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text(Sayiyi_Para_Formatina_Cevir(Globals.global_olcumler[0]['total_cryptocurrencies']/1, 0, true),
                              style:
                              TextStyle(
                                  fontSize : 11,
                                  color: Color.fromRGBO(247, 147, 26, 1),
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ]),
                          Row(children: [
                            Text("Toplam Kripto Para",
                              style:
                              TextStyle(
                                  fontSize : 10,
                                  color: Color.fromRGBO(247, 147, 26, 0.6),
                              ),
                            )
                          ]),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text(Sayiyi_Para_Formatina_Cevir(Globals.global_olcumler[0]['active_cryptocurrencies']/1, 0, true),
                              style:
                              TextStyle(
                                  fontSize : 11,
                                  color: Color.fromRGBO(247, 147, 26, 1),
                                  fontWeight: FontWeight.bold
                              ),)
                          ]),
                          Row(children: [
                            Text("Aktif Kripto Para",
                              style:
                              TextStyle(
                                  fontSize : 10,
                                  color: Color.fromRGBO(247, 147, 26, 0.6),
                              ),)
                          ]),
                        ],
                      ),
                    ],
                  )),

                  Divider(height: 2, color: Color.fromRGBO(247, 147, 26, 0.3)),

                  //!< 4. satir
                  Expanded(flex: 3, child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text(Sayiyi_Para_Formatina_Cevir(Globals.global_olcumler[0]['active_market_pairs']/1, 0, true),
                              style:
                              TextStyle(
                                  fontSize : 11,
                                  color: Color.fromRGBO(247, 147, 26, 1),
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ]),
                          Row(children: [
                            Text("Aktif Piyasa Çiftleri",
                              style:
                              TextStyle(
                                  fontSize : 10,
                                  color: Color.fromRGBO(247, 147, 26, 0.6),
                              ),
                            )
                          ]),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text(Sayiyi_Para_Formatina_Cevir(Globals.global_olcumler[0]['active_exchanges']/1, 0, true),
                              style:
                              TextStyle(
                                  fontSize : 11,
                                  color: Color.fromRGBO(247, 147, 26, 1),
                                  fontWeight: FontWeight.bold
                              ),)
                          ]),
                          Row(children: [
                            Text("Aktif Exchange",
                              style:
                              TextStyle(
                                  fontSize : 10,
                                  color: Color.fromRGBO(247, 147, 26, 0.6),
                              ),)
                          ]),
                        ],
                      ),
                    ],
                  )),

                  Divider(height: 2, color: Color.fromRGBO(247, 147, 26, 0.3)),

                  //!< 5. satir
                  Expanded(flex: 9, child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text("reklam_alani",
                              style:
                              TextStyle(
                                  fontSize : 11,
                                  color: Color.fromRGBO(247, 147, 26, 1),
                              ),
                            )
                          ]),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Text("reklam_alani",
                              style:
                              TextStyle(
                                  fontSize : 11,
                                  color: Color.fromRGBO(247, 147, 26, 1),
                              ),)
                          ]),
                        ],
                      ),
                    ],
                  )),
                ]
            )
        );

  }
}
