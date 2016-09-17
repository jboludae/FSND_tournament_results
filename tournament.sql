-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- We drop database tournament so an error is not launched when it exists
DROP DATABASE tournament;
CREATE DATABASE tournament;
\c tournament;

CREATE TABLE players(
    id_player SERIAL PRIMARY KEY,
    name_player VARCHAR(80)
);

CREATE TABLE matches(
    id_game SERIAL PRIMARY KEY,
    winner INT REFERENCES players (id_player),
    loser INT REFERENCES players (id_player)
);

-- Create some auxiliary views so a the standings are easier to get
CREATE VIEW num_matches AS
    SELECT players.id_player,
    players.name_player,
    COUNT(matches) AS count_matches
    FROM players LEFT JOIN matches 
    ON players.id_player=matches.winner OR players.id_player=matches.loser 
    GROUP BY players.id_player;

CREATE VIEW num_wins AS
    SELECT players.id_player, 
    COUNT(matches) AS count_wins
    FROM players LEFT JOIN matches 
    ON players.id_player=matches.winner
    GROUP BY players.id_player;

-- The last two views allow us to create the standings table easily
CREATE VIEW ranking AS
    SELECT num_matches.id_player,
    num_matches.name_player,
    num_wins.count_wins,
    num_matches.count_matches
    FROM num_matches JOIN num_wins
    ON num_matches.id_player=num_wins.id_player
    ORDER BY count_wins DESC;
