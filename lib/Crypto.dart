import 'package:flutter/material.dart';
import 'package:myapp/Globals.dart' as Globals;

class Crypto extends StatefulWidget {
  @override
  _CryptoState createState() => _CryptoState();
}

class _CryptoState extends State<Crypto> {

  List crypto_list = [];

  String piyasa_degeri_azalan = "Piyasa Değeri (Azalan)";
  String piyasa_degeri_artan  = "Piyasa Değeri (Artan)";
  String fiyat_azalan         = "Fiyat (Azalan)";
  String fiyat_artan          = "Fiyat (Artan)";
  String en_cok_yukselenler   = "En Çok Yükselenler";
  String en_cok_dusenler      = "En Çok Düşenler";

  String secili_siralama_dropdown_item = "Piyasa Değeri (Azalan)";
  
  String on_bes_dakika    = '15 dakika';
  String bir_saat         = '1 saat';
  String yirmi_dort_saat  = '24 saat';
  String bir_hafta        = '1 hafta';
  String bir_ay           = '1 ay';
  
  String secili_degisim_kriteri_dropdown_item = Globals.GL_secili_degisim_kriteri_dropdown_item;

  String secili_degisim_kriteri_data_ref = Globals.GL_secili_degisim_kriteri_data_ref;

  void initState()
  {
    setState(() {
      crypto_list = Globals.en_iyi_coinler;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    void Kripto_Listesini_Sirala()
    {
      //!< Degisim kriterini guncelleyelim

      if(secili_degisim_kriteri_dropdown_item == on_bes_dakika)
      {
      setState(() {
        secili_degisim_kriteri_data_ref = 'percent_change_15m';
        Globals.GL_secili_degisim_kriteri_data_ref = 'percent_change_15m';
      });
      }
      if(secili_degisim_kriteri_dropdown_item == bir_saat)
      {
        setState(() {
          secili_degisim_kriteri_data_ref = 'percent_change_1h';
          Globals.GL_secili_degisim_kriteri_data_ref = 'percent_change_1h';
        });
      }
      else if(secili_degisim_kriteri_dropdown_item == yirmi_dort_saat)
      {
        setState(() {
          secili_degisim_kriteri_data_ref = 'percent_change_24h';
          Globals.GL_secili_degisim_kriteri_data_ref = 'percent_change_24h';
        });
      }
      else if(secili_degisim_kriteri_dropdown_item == bir_hafta)
      {
        setState(() {
          secili_degisim_kriteri_data_ref = 'percent_change_7d';
          Globals.GL_secili_degisim_kriteri_data_ref = 'percent_change_7d';
        });
      }
      else if(secili_degisim_kriteri_dropdown_item == bir_ay)
      {
        setState(() {
          secili_degisim_kriteri_data_ref = 'percent_change_30d';
          Globals.GL_secili_degisim_kriteri_data_ref = 'percent_change_30d';
        });
      }


      //!< Coinleri siralayalim
      if(secili_siralama_dropdown_item == fiyat_artan)
      {
        setState(() {
          crypto_list.sort( (a, b) => (a['quotes']['USD']['price'] >= b['quotes']['USD']['price'] ? 1:0 ) - (b['quotes']['USD']['price'] >= a['quotes']['USD']['price'] ? 1:0 ));
        });
      }
      else if(secili_siralama_dropdown_item == fiyat_azalan)
      {
        setState(() {
          crypto_list.sort( (a, b) => (a['quotes']['USD']['price'] < b['quotes']['USD']['price'] ? 1:0 ) - (b['quotes']['USD']['price'] < a['quotes']['USD']['price'] ? 1:0 ));
        });
      }
      else if(secili_siralama_dropdown_item == piyasa_degeri_artan)
      {
        setState(() {
          crypto_list.sort( (a, b) => (a['quotes']['USD']['market_cap'] >= b['quotes']['USD']['market_cap'] ? 1:0 ) - (b['quotes']['USD']['market_cap'] >= a['quotes']['USD']['market_cap'] ? 1:0 ));
        });
      }
      else if(secili_siralama_dropdown_item == piyasa_degeri_azalan)
      {
        setState(() {
          crypto_list.sort( (a, b) => (a['quotes']['USD']['market_cap'] < b['quotes']['USD']['market_cap'] ? 1:0 ) - (b['quotes']['USD']['market_cap'] < a['quotes']['USD']['market_cap'] ? 1:0 ));
        });
      }
      else if(secili_siralama_dropdown_item == en_cok_yukselenler)
      {
        setState(() {
          crypto_list.sort( (a, b) => (a['quotes']['USD'][secili_degisim_kriteri_data_ref] < b['quotes']['USD'][secili_degisim_kriteri_data_ref] ? 1:0 ) - (b['quotes']['USD'][secili_degisim_kriteri_data_ref] < a['quotes']['USD'][secili_degisim_kriteri_data_ref] ? 1:0 ));
        });
      }
      else if(secili_siralama_dropdown_item == en_cok_dusenler)
      {
        setState(() {
          crypto_list.sort( (a, b) => (a['quotes']['USD'][secili_degisim_kriteri_data_ref] >= b['quotes']['USD'][secili_degisim_kriteri_data_ref] ? 1:0 ) - (b['quotes']['USD'][secili_degisim_kriteri_data_ref] >= a['quotes']['USD'][secili_degisim_kriteri_data_ref] ? 1:0 ));
        });
      }
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //!< Siralama olcutu kolonu
                Column(
                  children: [
                    DropdownButton<String>(
                      value: secili_siralama_dropdown_item,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 14,
                      elevation: 0,
                      onChanged: (String? yeni_secili_item) {
                        setState(() {
                          secili_siralama_dropdown_item = yeni_secili_item!;
                        });
                        Kripto_Listesini_Sirala();
                      },
                      items: <String>[
                        piyasa_degeri_azalan,
                        piyasa_degeri_artan,
                        fiyat_azalan,
                        fiyat_artan,
                        en_cok_yukselenler,
                        en_cok_dusenler
                      ]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }
                      ).toList(),
                    )
                  ],
                ),

                //!< Degisim kriteri kolonu
                Column(
                  children: [
                    DropdownButton<String>(
                      value: secili_degisim_kriteri_dropdown_item,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 14,
                      elevation: 0,
                      onChanged: (String? yeni_secili_item) {
                        setState(() {
                          Globals.GL_secili_degisim_kriteri_dropdown_item = yeni_secili_item!;
                          secili_degisim_kriteri_dropdown_item = yeni_secili_item;
                        });
                        Kripto_Listesini_Sirala();
                      },
                      items: <String>[
                        on_bes_dakika,
                        bir_saat,
                        yirmi_dort_saat,
                        bir_hafta,
                        bir_ay,
                      ]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }
                      ).toList(),
                    )
                  ],
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
            shadowColor: Colors.transparent,
            color: Colors.transparent,
          ),

          Expanded(
              child: ListView.builder(
                  itemCount: crypto_list.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int i) {

                    double coin_deger = crypto_list[i]['quotes']['USD']['price'];
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

                    bool deger_son_saatte_artmis_mi = crypto_list[i]['quotes']['USD'][secili_degisim_kriteri_data_ref] >= 0;

                    String fiyat_oku_sonucu = "down_arrow.png";
                    if(deger_son_saatte_artmis_mi)
                    {
                      fiyat_oku_sonucu = "up_arrow.png";
                    }

                    int    coin_piyasa_degeri = crypto_list[i]['quotes']['USD']['market_cap'];
                    int    coin_piyasa_degeri_int = coin_piyasa_degeri.toInt();
                    int    coin_piyasa_deger_basamak = 0;
                    double coin_piyasa_degeri_tmp = 0;
                    String yanina_gelecek_carpan_str = '';
                    String coin_piyasa_degeri_str = '';

                    while(coin_piyasa_degeri_int != 0)
                    {
                      coin_piyasa_deger_basamak++;
                      coin_piyasa_degeri_int = coin_piyasa_degeri_int ~/ 10;
                    }

                    if(coin_piyasa_deger_basamak > 9)
                    {
                      yanina_gelecek_carpan_str = 'Bn';
                      coin_piyasa_degeri_tmp = coin_piyasa_degeri / 1000000000;
                    }
                    else if(coin_piyasa_deger_basamak > 6)
                    {
                      yanina_gelecek_carpan_str = 'Mn';
                      coin_piyasa_degeri_tmp = coin_piyasa_degeri / 1000000;
                    }
                    else if(coin_piyasa_deger_basamak > 3)
                    {
                      yanina_gelecek_carpan_str = 'k';
                      coin_piyasa_degeri_tmp = coin_piyasa_degeri / 1000;
                    }
                    else
                    {
                      yanina_gelecek_carpan_str = '';
                    }
                    coin_piyasa_degeri_str = coin_piyasa_degeri_tmp.toStringAsFixed(3);

                    return Container(
                      height: 50.0,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //!< Coin img kolonu
                                Expanded(flex: 2, child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset( 'assets/crypto_icons/'+crypto_list[i]['symbol'].toString().toLowerCase()+'.png',
                                      height: 20,
                                      width: 20,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.asset("assets/default_coin_icon.png",
                                            height: 20,
                                            width: 20,),
                                    ),
                                  ],
                                )),

                                //!< Isim, kisa isim, degisim kolonu
                                Expanded(flex: 6, child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(crypto_list[i]['name'],
                                        style:  TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600
                                        )
                                    ),
                                    Card(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(crypto_list[i]['symbol'],
                                                style:  TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w400
                                                )
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
                                                    margin: EdgeInsets.fromLTRB(4, 0, 2, 1),
                                                    shadowColor: Colors.transparent,
                                                  ),
                                                  Text(crypto_list[i]['quotes']['USD'][secili_degisim_kriteri_data_ref].toStringAsFixed(2)+'%',
                                                    style: TextStyle(fontSize: 9,
                                                        color: deger_son_saatte_artmis_mi ? Colors.green : Colors.red,
                                                        fontWeight: FontWeight.bold),)
                                                ],
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  ],
                                )),

                                //!< Buraya bi sey bulcaz
                                Expanded(flex: 6, child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                  ],
                                )),

                                //!< Guncel fiyat ve toplam market cap kolonu
                                Expanded(flex: 6, child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('\$'+coin_deger_str,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text('P.Değ: \$'+coin_piyasa_degeri_str+' '+yanina_gelecek_carpan_str,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(77, 77, 77, 1)
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            Divider(
                              color: Color.fromRGBO(247, 147, 26, 0.3),
                              height: 2,

                            )
                          ],
                        )
                      ),
                    );
                  }
              )
          ),
        ]
    );
  }
}