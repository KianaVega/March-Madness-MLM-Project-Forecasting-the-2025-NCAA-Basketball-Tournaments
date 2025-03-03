SELECT 
    CAST(REGEXP_REPLACE(s.Seed, '[^0-9]', '', 'g') AS INT) AS Seed, 
    COUNT(*) AS TotalGames,
    SUM(CASE WHEN r.WTeamID = s.TeamID THEN 1 ELSE 0 END) AS Wins,
    ROUND(SUM(CASE WHEN r.WTeamID = s.TeamID THEN 1 ELSE 0 END) * 1.0 / NULLIF(COUNT(*), 0), 2) AS WinRate
FROM 
    MNCAATourneyResults r
LEFT JOIN 
    MNCAATourneySeeds s ON r.WTeamID = s.TeamID OR r.LTeamID = s.TeamID
GROUP BY 
    CAST(REGEXP_REPLACE(s.Seed, '[^0-9]', '', 'g') AS INT)
ORDER BY 
    Seed;


SELECT 
    CAST(REGEXP_REPLACE(s.Seed, '[^0-9]', '', 'g') AS INT) AS Seed, 
    COUNT(*) AS TotalGames,
    SUM(CASE WHEN r.WTeamID = s.TeamID THEN 1 ELSE 0 END) AS Wins,
    ROUND(SUM(CASE WHEN r.WTeamID = s.TeamID THEN 1 ELSE 0 END) * 1.0 / NULLIF(COUNT(*), 0), 2) AS WinRate
FROM 
    WNCAATourneyResults r
LEFT JOIN 
    WNCAATourneySeeds s ON r.WTeamID = s.TeamID OR r.LTeamID = s.TeamID
GROUP BY 
    CAST(REGEXP_REPLACE(s.Seed, '[^0-9]', '', 'g') AS INT)
ORDER BY 
    Seed;

[
  {
    "seed": 1,
    "totalgames": "13226",
    "wins": "9157",
    "winrate": "0.69"
  },
  {
    "seed": 2,
    "totalgames": "11366",
    "wins": "7577",
    "winrate": "0.67"
  },
  {
    "seed": 3,
    "totalgames": "8919",
    "wins": "5600",
    "winrate": "0.63"
  },
  {
    "seed": 4,
    "totalgames": "8924",
    "wins": "5582",
    "winrate": "0.63"
  },
  {
    "seed": 5,
    "totalgames": "7235",
    "wins": "4287",
    "winrate": "0.59"
  },
  {
    "seed": 6,
    "totalgames": "7400",
    "wins": "4314",
    "winrate": "0.58"
  },
  {
    "seed": 7,
    "totalgames": "6236",
    "wins": "3513",
    "winrate": "0.56"
  },
  {
    "seed": 8,
    "totalgames": "6505",
    "wins": "3805",
    "winrate": "0.58"
  },
  {
    "seed": 9,
    "totalgames": "5396",
    "wins": "2992",
    "winrate": "0.55"
  },
  {
    "seed": 10,
    "totalgames": "5419",
    "wins": "2882",
    "winrate": "0.53"
  },
  {
    "seed": 11,
    "totalgames": "4936",
    "wins": "2547",
    "winrate": "0.52"
  },
  {
    "seed": 12,
    "totalgames": "3254",
    "wins": "1459",
    "winrate": "0.45"
  },
  {
    "seed": 13,
    "totalgames": "1650",
    "wins": "460",
    "winrate": "0.28"
  },
  {
    "seed": 14,
    "totalgames": "1636",
    "wins": "471",
    "winrate": "0.29"
  },
  {
    "seed": 15,
    "totalgames": "1047",
    "wins": "189",
    "winrate": "0.18"
  },
  {
    "seed": 16,
    "totalgames": "1228",
    "wins": "217",
    "winrate": "0.18"
  }
]


[
  {
    "seed": 1,
    "totalgames": "8249",
    "wins": "6312",
    "winrate": "0.77"
  },
  {
    "seed": 2,
    "totalgames": "6339",
    "wins": "4494",
    "winrate": "0.71"
  },
  {
    "seed": 3,
    "totalgames": "4703",
    "wins": "3022",
    "winrate": "0.64"
  },
  {
    "seed": 4,
    "totalgames": "4469",
    "wins": "2802",
    "winrate": "0.63"
  },
  {
    "seed": 5,
    "totalgames": "3699",
    "wins": "2230",
    "winrate": "0.60"
  },
  {
    "seed": 6,
    "totalgames": "3303",
    "wins": "1887",
    "winrate": "0.57"
  },
  {
    "seed": 7,
    "totalgames": "3036",
    "wins": "1698",
    "winrate": "0.56"
  },
  {
    "seed": 8,
    "totalgames": "2444",
    "wins": "1244",
    "winrate": "0.51"
  },
  {
    "seed": 9,
    "totalgames": "2786",
    "wins": "1508",
    "winrate": "0.54"
  },
  {
    "seed": 10,
    "totalgames": "2267",
    "wins": "1123",
    "winrate": "0.50"
  },
  {
    "seed": 11,
    "totalgames": "2078",
    "wins": "977",
    "winrate": "0.47"
  },
  {
    "seed": 12,
    "totalgames": "1350",
    "wins": "449",
    "winrate": "0.33"
  },
  {
    "seed": 13,
    "totalgames": "904",
    "wins": "207",
    "winrate": "0.23"
  },
  {
    "seed": 14,
    "totalgames": "742",
    "wins": "130",
    "winrate": "0.18"
  },
  {
    "seed": 15,
    "totalgames": "533",
    "wins": "61",
    "winrate": "0.11"
  },
  {
    "seed": 16,
    "totalgames": "528",
    "wins": "30",
    "winrate": "0.06"
  }
]