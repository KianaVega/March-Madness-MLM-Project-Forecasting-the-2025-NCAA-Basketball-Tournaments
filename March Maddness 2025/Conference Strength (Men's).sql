SELECT 
    cf.Description AS Conference, 
    COUNT(*) AS TournamentWins
FROM 
    MNCAATourneyResults r
JOIN 
    MTeams t ON r.WTeamID = t.TeamID
JOIN 
    MTeamConferences tc ON t.TeamID = tc.TeamID AND r.Season = tc.Season
JOIN 
    Conferences cf ON tc.ConfAbbrev = cf.ConfAbbrev
GROUP BY 
    cf.Description
ORDER BY 
    TournamentWins DESC
LIMIT 68;

[
  {
    "conference": "Atlantic Coast Conference",
    "tournamentwins": "389"
  },
  {
    "conference": "Big Ten Conference",
    "tournamentwins": "338"
  },
  {
    "conference": "Big East Conference",
    "tournamentwins": "336"
  },
  {
    "conference": "Southeastern Conference",
    "tournamentwins": "287"
  },
  {
    "conference": "Big 12 Conference",
    "tournamentwins": "217"
  },
  {
    "conference": "Pacific-10 Conference",
    "tournamentwins": "141"
  },
  {
    "conference": "Atlantic 10 Conference",
    "tournamentwins": "95"
  },
  {
    "conference": "Big Eight Conference",
    "tournamentwins": "71"
  },
  {
    "conference": "Pacific-12 Conference",
    "tournamentwins": "66"
  },
  {
    "conference": "West Coast Conference",
    "tournamentwins": "61"
  },
  {
    "conference": "Conference USA",
    "tournamentwins": "60"
  },
  {
    "conference": "Missouri Valley Conference",
    "tournamentwins": "45"
  },
  {
    "conference": "Western Athletic Conference",
    "tournamentwins": "44"
  },
  {
    "conference": "Mountain West Conference",
    "tournamentwins": "31"
  },
  {
    "conference": "American Athletic Conference",
    "tournamentwins": "27"
  },
  {
    "conference": "Metropolitan Collegiate Athletic Conference",
    "tournamentwins": "26"
  },
  {
    "conference": "Big West Conference",
    "tournamentwins": "24"
  },
  {
    "conference": "Coastal Athletic Association",
    "tournamentwins": "23"
  },
  {
    "conference": "Southwest Conference",
    "tournamentwins": "22"
  },
  {
    "conference": "Mid-American Conference",
    "tournamentwins": "21"
  },
  {
    "conference": "Horizon League",
    "tournamentwins": "21"
  },
  {
    "conference": "Sun Belt Conference",
    "tournamentwins": "18"
  },
  {
    "conference": "Great Midwest Conference",
    "tournamentwins": "16"
  },
  {
    "conference": "Independent",
    "tournamentwins": "11"
  },
  {
    "conference": "Ivy League",
    "tournamentwins": "11"
  },
  {
    "conference": "Midwestern Collegiate Conference",
    "tournamentwins": "10"
  },
  {
    "conference": "Ohio Valley Conference",
    "tournamentwins": "10"
  },
  {
    "conference": "Metro Atlantic Athletic Conference",
    "tournamentwins": "10"
  },
  {
    "conference": "Southland Conference",
    "tournamentwins": "9"
  },
  {
    "conference": "Mid-Continent Conference",
    "tournamentwins": "8"
  },
  {
    "conference": "Atlantic Sun Conference",
    "tournamentwins": "8"
  },
  {
    "conference": "Southern Conference",
    "tournamentwins": "8"
  },
  {
    "conference": "Pacific Coast Athletic Association",
    "tournamentwins": "8"
  },
  {
    "conference": "Northeast Conference",
    "tournamentwins": "8"
  },
  {
    "conference": "Mid-Eastern Athletic Conference",
    "tournamentwins": "7"
  },
  {
    "conference": "Southwest Athletic Conference",
    "tournamentwins": "6"
  },
  {
    "conference": "Patriot League",
    "tournamentwins": "4"
  },
  {
    "conference": "Summit League",
    "tournamentwins": "4"
  },
  {
    "conference": "Big South Conference",
    "tournamentwins": "4"
  },
  {
    "conference": "America East Conference",
    "tournamentwins": "4"
  },
  {
    "conference": "Big Sky Conference",
    "tournamentwins": "3"
  },
  {
    "conference": "Midwestern City Conference",
    "tournamentwins": "2"
  },
  {
    "conference": "North Atlantic Conference",
    "tournamentwins": "2"
  },
  {
    "conference": "American South Conference",
    "tournamentwins": "1"
  },
  {
    "conference": "Eastern Collegiate Athletic Conference South",
    "tournamentwins": "1"
  }
]