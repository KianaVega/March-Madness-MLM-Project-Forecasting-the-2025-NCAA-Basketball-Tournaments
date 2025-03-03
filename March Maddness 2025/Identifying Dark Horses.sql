WITH TeamPerformance AS (
    SELECT 
        t.TeamName,
        s.Seed,
        COUNT(r.WTeamID) AS TotalWins,
        SUM(CASE WHEN r.NumOT > 0 THEN 1 ELSE 0 END) AS OvertimeWins
    FROM 
        MTeams t
    LEFT JOIN 
        MRegularSeasonResults r ON t.TeamID = r.WTeamID
    LEFT JOIN 
        MNCAATourneySeeds s ON t.TeamID = s.TeamID AND r.Season = s.Season
    GROUP BY 
        t.TeamName, s.Seed
)
SELECT 
    TeamName, 
    Seed, 
    TotalWins, 
    OvertimeWins
FROM 
    TeamPerformance
WHERE 
    CAST(REGEXP_REPLACE(Seed, '[^0-9]', '', 'g') AS INT) > 8 -- Seed > 8
    AND TotalWins > 20 -- Total wins > 20
    AND OvertimeWins > 3 -- Overtime wins > 3 (adjusted for realistic numbers)
ORDER BY 
    TotalWins DESC;

    [
  {
    "teamname": "Gonzaga",
    "seed": "Z10",
    "totalwins": "71",
    "overtimewins": "4"
  },
  {
    "teamname": "Iona",
    "seed": "Y14",
    "totalwins": "63",
    "overtimewins": "5"
  },
  {
    "teamname": "Charlotte",
    "seed": "Y09",
    "totalwins": "60",
    "overtimewins": "4"
  },
  {
    "teamname": "Bucknell",
    "seed": "X14",
    "totalwins": "50",
    "overtimewins": "4"
  },
  {
    "teamname": "Col Charleston",
    "seed": "X13",
    "totalwins": "50",
    "overtimewins": "4"
  },
  {
    "teamname": "Harvard",
    "seed": "W12",
    "totalwins": "50",
    "overtimewins": "4"
  },
  {
    "teamname": "Siena",
    "seed": "X13",
    "totalwins": "49",
    "overtimewins": "4"
  },
  {
    "teamname": "Marshall",
    "seed": "W13",
    "totalwins": "48",
    "overtimewins": "4"
  },
  {
    "teamname": "Providence",
    "seed": "W11",
    "totalwins": "44",
    "overtimewins": "5"
  },
  {
    "teamname": "Connecticut",
    "seed": "Y09",
    "totalwins": "44",
    "overtimewins": "4"
  },
  {
    "teamname": "Hampton",
    "seed": "X16",
    "totalwins": "43",
    "overtimewins": "6"
  },
  {
    "teamname": "Florida St",
    "seed": "Z09",
    "totalwins": "42",
    "overtimewins": "4"
  },
  {
    "teamname": "UCLA",
    "seed": "W11b",
    "totalwins": "38",
    "overtimewins": "4"
  },
  {
    "teamname": "F Dickinson",
    "seed": "W16a",
    "totalwins": "34",
    "overtimewins": "4"
  },
  {
    "teamname": "NC Central",
    "seed": "W14",
    "totalwins": "26",
    "overtimewins": "4"
  },
  {
    "teamname": "Pittsburgh",
    "seed": "X09",
    "totalwins": "25",
    "overtimewins": "4"
  },
  {
    "teamname": "Holy Cross",
    "seed": "Z13",
    "totalwins": "25",
    "overtimewins": "4"
  },
  {
    "teamname": "Manhattan",
    "seed": "Y13",
    "totalwins": "25",
    "overtimewins": "4"
  },
  {
    "teamname": "Princeton",
    "seed": "W13",
    "totalwins": "24",
    "overtimewins": "4"
  },
  {
    "teamname": "Wyoming",
    "seed": "W12b",
    "totalwins": "24",
    "overtimewins": "4"
  },
  {
    "teamname": "Boise St",
    "seed": "W14",
    "totalwins": "24",
    "overtimewins": "4"
  },
  {
    "teamname": "Mercer",
    "seed": "Y14",
    "totalwins": "23",
    "overtimewins": "5"
  },
  {
    "teamname": "Akron",
    "seed": "Z15",
    "totalwins": "22",
    "overtimewins": "4"
  },
  {
    "teamname": "TX Southern",
    "seed": "Z15",
    "totalwins": "22",
    "overtimewins": "4"
  },
  {
    "teamname": "Temple",
    "seed": "Y12",
    "totalwins": "21",
    "overtimewins": "4"
  }
]

WITH TeamPerformance AS (
    SELECT 
        t.TeamName,
        s.Seed,
        COUNT(r.WTeamID) AS TotalWins,
        SUM(CASE WHEN r.NumOT > 0 THEN 1 ELSE 0 END) AS OvertimeWins
    FROM 
        MTeams t
    LEFT JOIN 
        MRegularSeasonResults r ON t.TeamID = r.WTeamID
    LEFT JOIN 
        MNCAATourneySeeds s ON t.TeamID = s.TeamID AND r.Season = s.Season
    GROUP BY 
        t.TeamName, s.Seed
)
SELECT 
    TeamName, 
    Seed, 
    TotalWins, 
    OvertimeWins,
    RANK() OVER (ORDER BY TotalWins DESC, OvertimeWins DESC) AS TeamRank
FROM 
    TeamPerformance
WHERE 
    CAST(REGEXP_REPLACE(Seed, '[^0-9]', '', 'g') AS INT) > 8 -- Seed > 8
    AND TotalWins > 20 -- Total wins > 20
    AND OvertimeWins > 3 -- Overtime wins > 3 (adjusted for realistic numbers)
ORDER BY 
    TotalWins DESC;