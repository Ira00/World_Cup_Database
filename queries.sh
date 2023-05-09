#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals) + sum(opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(GREATEST(winner_goals, opponent_goals)) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) from games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name from games inner join teams on games.winner_id=teams.team_id WHERE winner_goals=(select max(winner_goals) from games WHERE year=2018) group by name")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT name
FROM (
  SELECT winning_team.name AS name
  FROM games
  INNER JOIN teams AS winning_team ON games.winner_id = winning_team.team_id
  WHERE games.round = 'Eighth-Final' AND games.year = 2014
  UNION
  SELECT losing_team.name AS name
  FROM games
  INNER JOIN teams AS losing_team ON games.opponent_id = losing_team.team_id
  WHERE games.round = 'Eighth-Final' AND games.year = 2014
) AS team_names
ORDER BY name;")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT name
  FROM games
  INNER JOIN teams ON games.winner_id = teams.team_id
  group by name
  order by name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year, name
FROM games
INNER JOIN teams ON games.winner_id = teams.team_id
GROUP BY year, name
HAVING COUNT(*) = (
  SELECT MAX(m)
  FROM (
    SELECT COUNT(*) AS m
    FROM games
    INNER JOIN teams ON games.winner_id = teams.team_id
    GROUP BY year, name
  ) AS win_counts
)
ORDER BY year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name from teams where name like 'Co%' order by name")"
