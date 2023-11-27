from data_generator import random_date 
if __name__ == "__main__":
    missions = []

    with open("mission_inserts.txt", "r") as fp:
        missions = fp.readlines()

    missions = [
        i.replace("INSERT INTO Mission(Name, EventName) VALUES (", "").split(", \'")[0]
        for i in missions
    ]
    
    players = ["R4ch3l", 'N0rm', 'Greg0r']
    with open('output.txt', 'w') as fp:
        for m in missions:
            for p in players:
                fp.write(f'INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES (\'{p}\', {m}, \'{random_date()}\');\n')


    
