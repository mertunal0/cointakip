library my_prj.globals;

import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/firebase_sdk.dart';

FirebaseOptions api_cred = new FirebaseOptions( apiKey: api_key,
                                                  appId: app_id,
                                                  messagingSenderId: client_id,
                                                  projectId: project_id);

List en_iyi_coinler = [];
List max_artan_azalan_coinler = [];