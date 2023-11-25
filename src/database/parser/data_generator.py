import argparse
import random
import json
import math
from datetime import datetime, timedelta

global n 
global items 
global item_types
global players
global pokemon
global pokemon_types
global pokemon_cp
global battles
global player_items
global player_pokemon
global xp 
global gyms 
global pokestops
global locations
global missions 
global mission_xp 
global player_missions
global item_effects
global item_types


def get_items():
    global items
    global n
    global item_effects
    global item_types

    with open('items.json', 'r') as fp:
        raw_items = json.load(fp)
        raw_items = random.sample(raw_items, min(n, len(raw_items)))

        for i in raw_items:
            if i["type"]["name"] not in item_types:
                item_effects.append({"Effect": i["type"]["name"][:100], "Type": i["type"]["name"][:20]})
                item_types.append({"Type": i["type"]["name"][:20], "Uses": 1})
            items.append({"Name": i["name"][:30], "Cost": random.randint(1, 10) * 100, "Effect": i["type"]["name"][:100]})

def get_players():
    global n 
    global players
    global xp

    with open('players.json', 'r') as fp:
        raw_players = json.load(fp)
        raw_players = random.sample(raw_players, min(n, len(raw_players)))

        temp_xp = {}

        for i in raw_players:
            pxp = random.randint(1, 100000)
            if pxp not in temp_xp:
                level = int(math.sqrt(pxp))
                xp.append({"XP": pxp, "PlayerLevel": level})
            team = random.choice(["Mystic", "Valor", "Instinct"])
            players.append({"Username": i["username"][:15], "XP": pxp, "TeamName": team})

def get_locations():
    global n 
    global locations
    global gyms 
    global pokestops
    biomes = ["Nature", "Water", "Snow", "Toxic", "Mountain", "Enchanted"]
    with open('locations.json', 'r') as fp:
        raw_locations = json.load(fp)

        for i in raw_locations:
            locations.append({
                "Country": i["location"]["country"][:50],
                "PostalCode": i["location"]["zip"][:10],
                "Name": i["location"]["street"][:50],
                "Biome": random.choice(biomes)
            })

            if random.choice([True, False]):
                gyms.append({
                    "Country": i["location"]["country"][:50],
                    "PostalCode": i["location"]["zip"][:10],
                    "Name": i["location"]["street"][:50],
                    "BadgeName": i["location"]["state"][:30],
                    "SponsorName": i["location"]["state"][:50]
                })

            if random.choice([True, False]):
                pokestops.append({
                    "Country": i["location"]["country"][:50],
                    "PostalCode": i["location"]["zip"][:10],
                    "Name": i["location"]["street"][:50],
                    "Rating": random.randint(1,10),
                    "SponsorName": i["location"]["state"][:50]
                })

def random_date():
    start_date = datetime(2016, 1, 1)
    end_date = datetime.now()

    # Calculate the range of days between start and end dates
    days_range = (end_date - start_date).days

    # Generate a random number of days to add to the start date
    random_days = random.randint(0, days_range)

    # Calculate the random date
    result_date = start_date + timedelta(days=random_days)

    formatted_date = result_date.strftime('%d-%b-%y')

    return formatted_date

def get_pokemon():
    global pokemon
    global n
    global pokemon_types
    global pokemon_cp
    global locations
    global gyms

    with open('pokemon.json', 'r') as fp:
        raw_pokemon = json.load(fp)
        raw_pokemon = random.sample(raw_pokemon, min(n,len(raw_pokemon)))
        pt = set()

        for i in raw_pokemon:
            if i["name"] not in pt:
                pt.add(i["name"])

                pokemon_types.append({
                    "SpeciesName": i["name"][:20],
                    "Type1": i["types"][0]["name"],
                    "Type2":"NULL" if len(i["types"]) == 1 else i["types"][1]["name"]
                })

            ids = set()
            for x in range(random.randint(1,10)):
                id = random.randint(10, 1000)
                while id in ids:
                    id = random.randint(10, 1000)
                ids.add(id)
                cp = random.randint(1, 8000)

                pokemon_cp.append({
                    "SpeciesName": i["name"][:20],
                    "CP": cp,
                    "HP": max(1, cp // 10),
                    "Attack": max(1, cp // 100)
                })

                p = {
                    "ID": id,
                    "SpeciesName": i["name"][:20],
                    "CP": cp,
                    "Distance": random.randint(1,1000)
                }

                if random.choice([True, False]):
                    p["Nickname"] = i["name"][:random.randint(0, max(1, len(i["name"]) - 6))]
                else:
                    p["Nickname"] = "NULL"

                if random.choice([True, False]):
                    g = random.choice(gyms)
                    p["GymCountry"] = g["Country"]
                    p["GymPostalCode"] = g["PostalCode"]
                    p["GymName"] = g["Name"]
                    p["StationedAtDate"] = random_date()
                else:
                    p["GymCountry"] = "NULL"
                    p["GymPostalCode"] = "NULL"
                    p["GymName"] = "NULL"

                    p["StationedAtDate"] = "NULL"

                if random.choice([True, False]):
                    l = random.choice(locations)
                    p["FoundCountry"] = l["Country"]
                    p["FoundPostalCode"] = l["PostalCode"]
                    p["FoundName"] = l["Name"]
                else:
                    p["FoundCountry"] = "NULL"
                    p["FoundPostalCode"] = "NULL"
                    p["FoundName"] = "NULL"

                pokemon.append(p)

def get_battles():
    global n 
    global players
    global battles

    dates = set()
    
    for i in range(n):
        winner = random.choice(players)
        loser = random.choice(players)
        d = random_date()

        while loser == winner:
            loser = random.choice(players)

        while d in dates:
            d = random_date()

        battles.append({
            "DateOccurred": d,
            "PlayerUsername1": winner["Username"], 
            "PlayerUsername2": loser["Username"],
            "League": random.choice(["Great League", "Ultra League", "Master League"]),
            "Time": random.randint(1,10)
        })


def get_player_pokemon():
    global n 
    global players 
    global pokemon
    global player_pokemon
    
    visited = set()
    for i in range(n):
        p = random.choice(pokemon)

        while p["ID"] in visited:
            p = random.choice(pokemon)
        visited.add(p["ID"])

        pp = random.choice(players)

        player_pokemon.append({
            "PlayerUsername": pp["Username"],
            "SpeciesID": p["ID"],
            "CapturedDate": random_date()
        })

def get_player_items():
    global n 
    global players 
    global items
    global player_items
    
    for i in range(n):
        i = random.choice(items)

        pp = random.choice(players)

        player_items.append({
            "PlayerUsername": pp["Username"],
            "ItemName": i["Name"],
            "Quantity": random.randint(1,100),
        })

def get_missions():
    global missions 
    global mission_xp

    with open('missions.txt', 'r') as fp:
        raw_missions = fp.readlines()
        for m in raw_missions:
            mm = m.split(' - ')
            mn = mm[0][:50]
            en = mm[1].replace(' ', '')[:50]
            mxp = set()
            if en not in mxp:
                mission_xp.append({"EventName": en, "XP": random.randint(1,15) * 100})

            missions.append({
                "Name": mn,
                "EventName": en
            })

def get_player_missions():
    global n 
    global players 
    global missions
    global player_missions
    
    for i in range(n):
        m = random.choice(missions)

        pp = random.choice(players)

        player_missions.append({
            "PlayerUsername": pp["Username"],
            "MissionName": m["Name"],
            "CompletedDate": random_date()
        })

def write_inserts(fp, table, data):
    for i in data:
        x = []
        for j in i.values():
            if type(j) == int:
                x.append(str(j))
            elif type(j) == str:
                z = j.replace('\'', '').replace('\n', '')
                if z != 'NULL':
                    x.append(f"'{z}'")
                else:
                    x.append(f"{z}")
            else:
                print(j)
        fp.write(f"INSERT INTO {table}({', '.join(i.keys())}) VALUES ({', '.join(x)});\n")

if __name__ == "__main__":
    global n 
    global items 
    global item_effects
    global item_types
    global players
    global pokemon
    global pokemon_types
    global pokemon_cp
    global battles
    global player_items
    global player_pokemon
    global xp 
    global locations
    global gyms 
    global pokestops
    global missions 
    global player_missions 
    global mission_xp

    n = 0
    items = []
    item_types= []
    item_effects= []
    players= []
    pokemon= []
    pokemon_types= []
    pokemon_cp= []
    battles= []
    player_items= []
    player_pokemon= []
    xp = []
    locations = []
    gyms = []
    pokestops = []
    missions = []
    player_missions = []
    mission_xp = []

    parser = argparse.ArgumentParser()
    parser.add_argument("-n", "--number", type=int)

    args = parser.parse_args()
    n = args.number

    if n == None:
        n = random.randint(1,100)

    get_items()
    get_players()
    get_locations()
    get_pokemon()
    get_battles()
    get_player_pokemon()
    get_player_items()
    get_missions()
    get_player_missions()

    with open('more_inserts.sql', 'w') as fp:
        write_inserts(fp, 'ItemTypeUses', item_types)
        write_inserts(fp, 'ItemEffectType', item_effects)
        write_inserts(fp, 'Item', items)
        write_inserts(fp, "PlayerXPLevel", xp)
        write_inserts(fp, 'Player', players)
        write_inserts(fp, 'Location', locations)
        write_inserts(fp, 'Gym', gyms)
        write_inserts(fp, 'Pokestop', pokestops)
        write_inserts(fp, 'PokemonSpeciesTypes',pokemon_types)
        write_inserts(fp, 'PokemonSpeciesCP',pokemon_cp)
        write_inserts(fp, 'Pokemon', pokemon)
        write_inserts(fp, 'Battle', battles)
        write_inserts(fp, 'MissionEventNameXP', mission_xp)
        write_inserts(fp, 'Mission', missions)
        write_inserts(fp, 'PlayerCompletedMission', player_missions)
        write_inserts(fp, 'PlayerCapturedPokemon', player_pokemon)
        write_inserts(fp, 'PlayerOwnsItem', player_items)

