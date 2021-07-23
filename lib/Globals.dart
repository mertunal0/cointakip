library my_prj.globals;

import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/firebase_sdk.dart';

FirebaseOptions api_cred = new FirebaseOptions( apiKey: api_key,
                                                  appId: app_id,
                                                  messagingSenderId: client_id,
                                                  projectId: project_id);

List en_iyi_coinler = [];
List max_artan_azalan_coinler = [];
List global_olcumler = [];

String GL_secili_degisim_kriteri_dropdown_item = '15 dakika';
String GL_secili_degisim_kriteri_data_ref = 'percent_change_15m';

bool alarm_kurulu_mu = false;
double alarm_fiyat_bilgisi = 0;
double alarm_kuruldugundaki_fiyat_bilgisi = 0;
String alarm_kurulan_coin_symbol = "";
