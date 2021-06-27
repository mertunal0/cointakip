from firebase import firebase
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import time
from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json
import sys
import operator

# Definelar
ANLIK_CEKILECEK_COIN_SAYISI = 200
SUNUCU_CALISMA_FREKANSI_DK  = 10
DK_2_SN                     = 60
EN_COK_YUKS_AZL_VERI_SAYISI = 5


cred = credentials.Certificate('firebase_sdk.json')
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://cointakip-eedc6-default-rtdb.firebaseio.com/'
})
db_en_buyukler_ref      = db.reference('/cmcap_en_buyuk_market_cap')
db_max_artan_azalan_ref = db.reference('/cmcap_max_artan_azalan')

local_coinmarketcap_data = [
        # {
        #    'id': '',
        #    'name': '',
        #    'symbol': '',
        #    'slug': '',
        #    'max_supply': 0,
        #    'circulating_supply': 0,
        #    'total_supply': 0,
        #    'cmc_rank': 0,
        #    'last_updated': '',
        #    'quote': {
        #        'USD': {
        #            'price': 0,
        #            'volume_24h': 0,
        #            'percent_change_1h': 0,
        #            'percent_change_24h': 0,
        #            'percent_change_7d': 0,
        #            'percent_change_30d': 0,
        #            'percent_change_90d': 0,
        #            'market_cap': 0,
        #        }
        #    },
        # },

    ]


# Coinmarketcap url
cmcap_url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'

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

class CoinMarketCap_Verisi:
    def __init__(self):
        self.en_buyuk_market_cap_verisi = []
        self.en_cok_yukselen_azalan_verisi = []

    def coinmarketcap_verisi_cek(self):
        try:
            cmcap_response = cmcap_session.get(cmcap_url, params=cmcap_parameters)
            cmcap_donut = json.loads(cmcap_response.text)
            for i in range(ANLIK_CEKILECEK_COIN_SAYISI):
                local_coinmarketcap_data.append(cmcap_donut['data'][i])

            self.market_cap_buyuklugune_gore_sirala()
            self.en_cok_yukselen_azalan_belirle()

        except (ConnectionError, Timeout, TooManyRedirects) as e:
            print(e)

    def market_cap_buyuklugune_gore_sirala(self):
        self.en_buyuk_market_cap_verisi = sorted(local_coinmarketcap_data, key=lambda k: k['quote']['USD']['market_cap'], reverse=True)

    def en_buyuk_market_cap_verisini_firebase_pushla(self):
        firebase_post_sorgusu_sonucu = db_en_buyukler_ref.set(self.en_buyuk_market_cap_verisi)

    def en_cok_yukselen_azalan_belirle(self):
        en_cok_yukselenler = sorted(local_coinmarketcap_data, key=lambda k: k['quote']['USD']['percent_change_1h'], reverse=True)
        en_cok_azalanlar   = sorted(local_coinmarketcap_data, key=lambda k: k['quote']['USD']['percent_change_1h'], reverse=False )

        for i in range(EN_COK_YUKS_AZL_VERI_SAYISI):
            self.en_cok_yukselen_azalan_verisi.append(en_cok_yukselenler[i])

        for i in range(EN_COK_YUKS_AZL_VERI_SAYISI):
            self.en_cok_yukselen_azalan_verisi.append(en_cok_azalanlar[i])

    def en_cok_yukselen_azalan_verisini_firebase_pushla(self):
        firebase_post_sorgusu_sonucu = db_max_artan_azalan_ref.set(self.en_cok_yukselen_azalan_verisi)

# Coinmarketcap verisini yaratalim
cmcap_veri = CoinMarketCap_Verisi()

while(True):
    # Coin Market Cap'den anlik veriyi cekelim
    cmcap_veri.coinmarketcap_verisi_cek()

    # Firebase'e anlik coin verisini pushlayalim
    cmcap_veri.en_buyuk_market_cap_verisini_firebase_pushla()
    cmcap_veri.en_cok_yukselen_azalan_verisini_firebase_pushla()

    # Belirlenen sure dakika prosesi uyutalim
    time.sleep(SUNUCU_CALISMA_FREKANSI_DK * DK_2_SN)