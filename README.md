# March Madness SQL Project: Forecasting the 2025 NCAA Basketball Tournaments

This project uses SQL to analyze historical NCAA basketball data and forecast the outcomes of the 2025 NCAA Basketball Tournaments (both men's and women's). The dataset is sourced from the Kaggle competition **March Machine Learning Mania 2025**, which provides comprehensive historical data on teams, games, seeds, and more.

## Goals
- Analyze historical team performance, tournament seeds, and advanced statistics.
- Simulate matchups in the tournament bracket.
- Incorporate external data (e.g., player statistics, coaching performance, team rankings) to improve predictions.
- Forecast the 2025 NCAA Basketball Tournaments, identifying potential dark horses and upsets.

## Table of Contents
1. [Dataset Overview](#dataset-overview)
2. [Database Schema](#database-schema)
3. [SQL Queries for Analysis](#sql-queries-for-analysis)
4. [Incorporating External Data](#incorporating-external-data)
5. [Simulating Matchups](#simulating-matchups)
6. [Forecasting the 2025 Tournament](#forecasting-the-2025-tournament)
7. [GitHub Repository Structure](#github-repository-structure)
8. [How to Use This Project](#how-to-use-this-project)
9. [Future Enhancements](#future-enhancements)

## Dataset Overview
The dataset includes key files:
- **Teams:** `MTeams.csv`, `WTeams.csv`
- **Seasons:** `MSeasons.csv`, `WSeasons.csv`
- **Regular Season Results:** `MRegularSeasonCompactResults.csv`, `WRegularSeasonCompactResults.csv`
- **Tournament Results:** `MNCAATourneyCompactResults.csv`, `WNCAATourneyCompactResults.csv`
- **Detailed Results:** `MRegularSeasonDetailedResults.csv`, `WRegularSeasonDetailedResults.csv`
- **Tournament Seeds:** `MNCAATourneySeeds.csv`, `WNCAATourneySeeds.csv`
- **Cities:** `Cities.csv`
- **Massey Ordinals:** `MMasseyOrdinals.csv`

## Database Schema
Example PostgreSQL schema for men's teams:
```sql
CREATE TABLE MTeams (
    TeamID INT PRIMARY KEY,
    TeamName VARCHAR(50),
    FirstD1Season INT,
    LastD1Season INT
);
```

Example for storing game results:
```sql
CREATE TABLE MRegularSeasonResults (
    Season INT,
    DayNum INT,
    WTeamID INT,
    WScore INT,
    LTeamID INT,
    LScore INT,
    WLoc CHAR(1),
    NumOT INT,
    PRIMARY KEY (Season, DayNum, WTeamID, LTeamID),
    FOREIGN KEY (WTeamID) REFERENCES MTeams(TeamID),
    FOREIGN KEY (LTeamID) REFERENCES MTeams(TeamID)
);
```

## SQL Queries for Analysis
### 1. Top 10 Teams with Most Wins (Men's)
```sql
SELECT t.TeamName, COUNT(*) AS TotalWins
FROM MRegularSeasonResults r
JOIN MTeams t ON r.WTeamID = t.TeamID
GROUP BY t.TeamName
ORDER BY TotalWins DESC
LIMIT 10;
```

### 2. Teams with Highest Average Score (Women's)
```sql
SELECT t.TeamName, ROUND(AVG(r.WScore), 2) AS AvgScore
FROM WRegularSeasonResults r
JOIN WTeams t ON r.WTeamID = t.TeamID
GROUP BY t.TeamName
ORDER BY AvgScore DESC
LIMIT 10;
```

### 3. Historical Tournament Performance by Seed (Men's)
```sql
SELECT SUBSTRING(s.Seed FROM 2)::INT AS Seed, COUNT(*) AS TotalGames,
       SUM(CASE WHEN r.WTeamID = s.TeamID THEN 1 ELSE 0 END) AS Wins,
       ROUND(SUM(CASE WHEN r.WTeamID = s.TeamID THEN 1 ELSE 0 END) * 1.0 / COUNT(*), 2) AS WinRate
FROM MNCAATourneyResults r
JOIN MNCAATourneySeeds s ON r.WTeamID = s.TeamID OR r.LTeamID = s.TeamID
GROUP BY Seed
ORDER BY Seed;
```

## Incorporating External Data
- **Player Statistics**: Star players, injuries, and performance metrics.
- **Coaching Performance**: Tournament win rates.
- **Team Rankings**: KenPom, ESPN rankings.

Example: Adding KenPom Rankings
```sql
CREATE TABLE KenPomRankings (
    Season INT,
    TeamID INT,
    KenPomRank INT,
    PRIMARY KEY (Season, TeamID),
    FOREIGN KEY (TeamID) REFERENCES MTeams(TeamID)
);
```

## Simulating Matchups
The following SQL simulates matchups, considering seeding and potential upsets:
```sql
WITH ranked_teams AS (
    SELECT t.TeamName, s.Seed,
           CAST(REGEXP_REPLACE(s.Seed, '[^0-9]', '', 'g') AS INT) AS SeedNumber,
           COUNT(r.WTeamID) AS TotalWins,
           AVG(r.WScore - r.LScore) AS AvgScoringMargin
    FROM MTeams t
    LEFT JOIN MRegularSeasonResults r ON t.TeamID = r.WTeamID
    LEFT JOIN MNCAATourneySeeds s ON t.TeamID = s.TeamID
    WHERE r.Season IN (2024, 2025)
    GROUP BY t.TeamName, s.Seed
)
SELECT Team1, Team2,
       CASE WHEN (UpsetProbability + RANDOM()) > 1 THEN Team2 ELSE Team1 END AS PredictedWinner
FROM ranked_teams;
```

## Forecasting the 2025 Tournament
- **Predicted winners**: Round of 64, Sweet 16, Elite 8, Final Four, Championship.
- **Identifying upsets and dark horses**.

## GitHub Repository Structure
```
/march-madness-sql-project
│
├── /data
│   ├── MTeams.csv
│   ├── WTeams.csv
│   ├── ...
│
├── /sql
│   ├── create_tables.sql
│   ├── load_data.sql
│   ├── analysis_queries.sql
│   ├── simulate_matchups.sql
│
├── /external_data
│   ├── kenpom_rankings.csv
│   ├── player_stats.csv
│
├── README.md
├── requirements.txt
└── LICENSE
```

## How to Use This Project
1. **Set Up PostgreSQL**: Install PostgreSQL and create a database.
2. **Load Data**: Use `load_data.sql` to load CSV files.
3. **Run Queries**: Execute SQL scripts for analysis.
4. **Incorporate External Data**: Add KenPom rankings and player statistics.
5. **Visualize Results**: Use Tableau or Python.

## Future Enhancements
- **Machine Learning Integration**: Python predictive models.
- **Real-Time Updates**: Live tournament data.
- **Interactive Dashboard**: Explore predictions visually.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

For questions or contributions, please open an issue or submit a pull request. Happy forecasting! 🏀
