from builtins import print

from firebase import firebase
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import time
from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json
import http.client
import sys
import operator

# Definelar
ANLIK_CEKILECEK_COIN_SAYISI     = 200
GLOBAL_DATA_CALISMA_FREKANSI_DK = 10
SUNUCU_CALISMA_FREKANSI_SN      = 10
DK_2_SN                         = 60
EN_COK_YUKS_AZL_VERI_SAYISI     = 5


cred = credentials.Certificate('firebase_sdk.json')
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://cointakip-eedc6-default-rtdb.firebaseio.com/'
})
db_en_buyukler_ref      = db.reference('/cmcap_en_buyuk_market_cap')
db_max_artan_azalan_ref = db.reference('/cmcap_max_artan_azalan')
db_global_ref           = db.reference('/cmcap_global_olcumler')

local_coinmarketcap_data = []
local_coinmarketcap_global_data = {}


# Coinmarketcap url
cmcap_en_buyukler_url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
cmcap_global_metr_url = 'https://pro-api.coinmarketcap.com/v1/global-metrics/quotes/latest'

cmcap_parameters = {
  'start': '1',
  'limit': ANLIK_CEKILECEK_COIN_SAYISI,
}

cmcap_headers = {
  'Accepts': 'application/json',
  'X-CMC_PRO_API_KEY': 'f8a3aa1f-932d-426a-81cd-c6c09a1dfcdb',
}

cmcap_session = Session()
cmcap_session.headers.update(cmcap_headers)


# Coinpaprika baglantisi
coinpaprika_conn = http.client.HTTPSConnection("coinpaprika1.p.rapidapi.com")
coinpaprika_headers = {
    'x-rapidapi-key': "cd5b0f4db4msh030ea178fa0ec37p1648f0jsnfa3539e73c2d",
    'x-rapidapi-host': "coinpaprika1.p.rapidapi.com"
    }

class CoinMarketCap_Verisi:
    def __init__(self):
        self.en_buyuk_market_cap_verisi = []
        self.en_cok_yukselen_azalan_verisi = []

    def coinmarketcap_global_metrics_cek_ve_firebase_pushla(self):
        try:
            cmcap_response = cmcap_session.get(cmcap_global_metr_url)
            cmcap_donut = json.loads(cmcap_response.text)

            db_global_ref.set(cmcap_donut['data'])

        except (ConnectionError, Timeout, TooManyRedirects) as e:
            print(e)


    def coinmarketcap_verisi_cek(self):
        try:
            global local_coinmarketcap_data
            coinpaprika_conn.request("GET", "/tickers", headers=coinpaprika_headers)
            res = coinpaprika_conn.getresponse()
            data = res.read()
            data_decoded = data.decode('utf-8')
            data_json = json.loads(data_decoded)

            local_coinmarketcap_data.clear()
            local_coinmarketcap_data = data_json

            self.market_cap_buyuklugune_gore_sirala()
            self.en_cok_yukselen_azalan_belirle()

        except (ConnectionError, Timeout, TooManyRedirects) as e:
            print(e)


    def market_cap_buyuklugune_gore_sirala(self):
        self.en_buyuk_market_cap_verisi = sorted(local_coinmarketcap_data, key=lambda k: k['quotes']['USD']['market_cap'], reverse=True)
        self.en_buyuk_market_cap_verisi = self.en_buyuk_market_cap_verisi[:ANLIK_CEKILECEK_COIN_SAYISI]

    def en_buyuk_market_cap_verisini_firebase_pushla(self):
        firebase_post_sorgusu_sonucu = db_en_buyukler_ref.set(self.en_buyuk_market_cap_verisi)

    def en_cok_yukselen_azalan_belirle(self):
        en_cok_yukselenler = sorted(local_coinmarketcap_data, key=lambda k: k['quotes']['USD']['percent_change_1h'], reverse=True)
        en_cok_azalanlar   = sorted(local_coinmarketcap_data, key=lambda k: k['quotes']['USD']['percent_change_1h'], reverse=False )

        for i in range(EN_COK_YUKS_AZL_VERI_SAYISI):
            self.en_cok_yukselen_azalan_verisi.append(en_cok_yukselenler[i])

        for i in range(EN_COK_YUKS_AZL_VERI_SAYISI):
            self.en_cok_yukselen_azalan_verisi.append(en_cok_azalanlar[i])

    def en_cok_yukselen_azalan_verisini_firebase_pushla(self):
        firebase_post_sorgusu_sonucu = db_max_artan_azalan_ref.set(self.en_cok_yukselen_azalan_verisi)

# Coinmarketcap verisini yaratalim
cmcap_veri = CoinMarketCap_Verisi()

sunucu_calisma_sayac = 0

while(True):
    # Coin Market Cap'den anlik veriyi cekelim
    cmcap_veri.coinmarketcap_verisi_cek()

    # Firebase'e anlik coin verisini pushlayalim
    cmcap_veri.en_buyuk_market_cap_verisini_firebase_pushla()
    cmcap_veri.en_cok_yukselen_azalan_verisini_firebase_pushla()

    # Global veriyi 10 dakikada bir guncelleyecegiz
    if(sunucu_calisma_sayac >= (GLOBAL_DATA_CALISMA_FREKANSI_DK * DK_2_SN) / SUNUCU_CALISMA_FREKANSI_SN ):
        cmcap_veri.coinmarketcap_global_metrics_cek_ve_firebase_pushla()

    print(local_coinmarketcap_data[0]['quotes']['USD']['percent_change_1h'])
    # Belirlenen sure boyunca prosesi uyutalim
    time.sleep(SUNUCU_CALISMA_FREKANSI_SN)

    sunucu_calisma_sayac += 1