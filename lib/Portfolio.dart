import 'package:flutter/material.dart';
import 'package:myapp/Globals.dart' as Globals;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:workmanager/workmanager.dart';

class Portfolio extends StatefulWidget {
  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {

  List crypto_list = [];

  int carousel_secili_idx = 0;

  String alarm_edit_text_deger = "";
  String arama_edit_text_deger = "";

  void initState()
  {
    setState(() {
      crypto_list = Globals.en_iyi_coinler;
      alarm_edit_text_deger = crypto_list[carousel_secili_idx]['quotes']['USD']['price'].toString();
    });
    super.initState();
  }

  void Secili_Coin_Icin_Fiyat_Alarmi_Kur()
  {
    if(this.alarm_edit_text_deger == "")
    {
      //!< Deger bos hatasi
      Globals.alarm_kurulu_mu = false;
    }
    else
    {
      Globals.alarm_kurulu_mu = true;
      Globals.alarm_fiyat_bilgisi = double.parse(this.alarm_edit_text_deger);
      Globals.alarm_kurulan_coin_symbol = crypto_list[carousel_secili_idx]['symbol'];
      Globals.alarm_kuruldugundaki_fiyat_bilgisi = crypto_list[carousel_secili_idx]['quotes']['USD']['price'];
    }
  }

  void Arama_Bari_Texti_ve_Listeyi_Degistir(String deger_str)
  {
    this.setState(() {
      arama_edit_text_deger = deger_str;
    });

    //!< Eger ki deger bossa
    if(deger_str == "")
    {
      //!< Tum coinleri atayalim
      this.setState(() {
        crypto_list = Globals.en_iyi_coinler;
        alarm_edit_text_deger = crypto_list[carousel_secili_idx]['quotes']['USD']['price'].toString();
      });
    }
    //!< Aksi taktirde filtreleme yapalim
    else
    {
      var list_tmp = [];

      //!< Listedeki her bir elemanin
      for(int i = 0; i<Globals.en_iyi_coinler.length; i++)
      {
        //!< texti iceriyor mu diye bakalim
        bool isim_texti_iceriyor_mu    = Globals.en_iyi_coinler[i]["name"].toString().toLowerCase().contains(deger_str);
        bool kisa_ad_texti_iceriyor_mu = Globals.en_iyi_coinler[i]["symbol"].toString().toLowerCase().contains(deger_str);

        //!< Iceriyorsa listeye ekleyelim
        if(isim_texti_iceriyor_mu || kisa_ad_texti_iceriyor_mu)
        {
          list_tmp.add(Globals.en_iyi_coinler[i]);
        }
      }

      //!< Crypyo listi guncelleyelim ve carouseli resetleyelim
      this.setState(() {
        crypto_list = list_tmp;
        if(carousel_secili_idx >= crypto_list.length)
        {
          alarm_edit_text_deger = crypto_list[crypto_list.length-1]['quotes']['USD']['price'].toString();
        }
        else
        {
          alarm_edit_text_deger = crypto_list[carousel_secili_idx]['quotes']['USD']['price'].toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //!< Arama kismi
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 85/100 * MediaQuery.of(context).size.width,
                  height: 32,
                  child:
                  TextFormField(
                    onChanged: (deger_str) => Arama_Bari_Texti_ve_Listeyi_Degistir(deger_str),
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: "Coin Bul",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                  ),
                ),
                Icon(Icons.search, color: Color.fromRGBO(247, 147, 26, 0.8),)
              ],
            )
          ),

          //!< Slider kismi
          CarouselSlider.builder(
            itemCount: crypto_list.length,
            carouselController:
            CarouselController(

            ),
            options: CarouselOptions(
              initialPage: 0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                this.setState(() {
                  carousel_secili_idx = index;
                  alarm_edit_text_deger = crypto_list[carousel_secili_idx]['quotes']['USD']['price'].toString();
                });
              }
            ),
            itemBuilder: (BuildContext context, int i, int pageViewIdx) {

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

              bool deger_son_saatte_artmis_mi = crypto_list[i]['quotes']['USD']['percent_change_1h'] >= 0;

              return Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //!< Coin fotosu kolonu
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset( 'assets/crypto_icons/'+crypto_list[i]['symbol'].toString().toLowerCase()+'.png',
                          width: 4/10 * MediaQuery.of(context).size.width,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset("assets/default_coin_icon.png",
                                width: 4/10 * MediaQuery.of(context).size.width,
                              ),
                        ),

                      ],
                    ),
                    //!< Coin bilgisi kolonu
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(crypto_list[i]['symbol'],
                            style: TextStyle( fontSize: 22, fontWeight: FontWeight.w900, color: Color.fromRGBO(77, 77, 77, 1))
                        ),
                        Text(crypto_list[i]['name'],
                            style: TextStyle( fontSize: 16, fontWeight: FontWeight.w800, color: Color.fromRGBO(77, 77, 77, 0.8))
                        ),
                        Text(crypto_list[i]['quotes']['USD']['percent_change_1h'].toStringAsFixed(2)+'%',
                          style:
                          TextStyle(
                              fontSize: 18,
                              color: deger_son_saatte_artmis_mi ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w900
                          ),
                        ),
                        Text('\$'+coin_deger_str,
                          style: TextStyle(fontSize: 16,
                              fontWeight: FontWeight.w600,
                            color: deger_son_saatte_artmis_mi ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
          ),

          //!< Alarm kurma kismi
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child:
                    TextFormField(
                      controller: TextEditingController(text: alarm_edit_text_deger),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Fiyat (\$)',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: Secili_Coin_Icin_Fiyat_Alarmi_Kur,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(247, 147, 26, 1))
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 8/10,
                      child: Text(
                        "Alarm Kur",
                      ),
                    )
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}