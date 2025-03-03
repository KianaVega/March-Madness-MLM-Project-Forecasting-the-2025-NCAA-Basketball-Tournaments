WITH ranked_teams AS (
    SELECT 
        t.TeamName,
        s.Seed,
        CAST(REGEXP_REPLACE(s.Seed, '[^0-9]', '', 'g') AS INT) AS SeedNumber, -- Extract seed number (e.g., "W11b" -> 11)
        COUNT(r.WTeamID) AS TotalWins,
        SUM(CASE WHEN r.NumOT > 0 THEN 1 ELSE 0 END) AS OvertimeWins,
        AVG(r.WScore - r.LScore) AS AvgScoringMargin, -- Average scoring margin
        COUNT(r.WTeamID) FILTER (WHERE r.DayNum > 120) AS RecentWins -- Wins in the last 10 games (assuming DayNum > 120)
    FROM 
        MTeams t
    JOIN 
        MRegularSeasonResults r ON t.TeamID = r.WTeamID AND r.Season IN (2024, 2025) -- Filter for 2024 and 2025 seasons
    LEFT JOIN 
        MNCAATourneySeeds s ON t.TeamID = s.TeamID AND s.Season IN (2024, 2025) -- Filter for 2024 and 2025 seasons
    GROUP BY 
        t.TeamName, s.Seed
),
matchups AS (
    SELECT 
        t1.TeamName AS Team1,
        t1.Seed AS Seed1,
        t1.SeedNumber AS SeedNumber1,
        t1.TotalWins AS TotalWins1,
        t1.OvertimeWins AS OvertimeWins1,
        t1.AvgScoringMargin AS AvgScoringMargin1,
        t1.RecentWins AS RecentWins1,
        t2.TeamName AS Team2,
        t2.Seed AS Seed2,
        t2.SeedNumber AS SeedNumber2,
        t2.TotalWins AS TotalWins2,
        t2.OvertimeWins AS OvertimeWins2,
        t2.AvgScoringMargin AS AvgScoringMargin2,
        t2.RecentWins AS RecentWins2
    FROM 
        ranked_teams t1
    INNER JOIN 
        ranked_teams t2
    ON 
        t1.SeedNumber + t2.SeedNumber = 17 -- Pair seeds (1 vs. 16, 2 vs. 15, etc.)
    WHERE 
        t1.SeedNumber < t2.SeedNumber -- Ensure each matchup is listed only once
),
upset_probability AS (
    SELECT 
        Team1,
        Seed1,
        SeedNumber1,
        Team2,
        Seed2,
        SeedNumber2,
        -- Adjust upset probability based on seed difference
        CASE 
            WHEN SeedNumber1 - SeedNumber2 > 10 THEN 0.05 -- Very low chance for 1 vs. 16
            WHEN SeedNumber1 - SeedNumber2 > 6 THEN 0.1 -- Low chance for 2 vs. 15
            WHEN SeedNumber1 - SeedNumber2 > 4 THEN 0.2 -- Moderate chance for 5 vs. 12
            WHEN SeedNumber1 - SeedNumber2 > 2 THEN 0.3 -- Higher chance for 8 vs. 9
            ELSE 0.4 -- Toss-up for close seeds
        END AS UpsetProbability,
        -- Add bonuses for recent performance, overtime wins, and scoring margin
        CASE 
            WHEN RecentWins1 > RecentWins2 THEN 0.1 -- Higher chance if Team1 has better recent performance
            ELSE 0
        END AS RecentPerformanceBonus,
        CASE 
            WHEN OvertimeWins1 > OvertimeWins2 THEN 0.1 -- Higher chance if Team1 has more overtime wins
            ELSE 0
        END AS OvertimeBonus,
        CASE 
            WHEN AvgScoringMargin1 > AvgScoringMargin2 THEN 0.1 -- Higher chance if Team1 has a better scoring margin
            ELSE 0
        END AS ScoringMarginBonus
    FROM 
        matchups
),
-- Simulate Round of 64
round_of_64 AS (
    SELECT 
        Team1,
        Seed1,
        SeedNumber1,
        Team2,
        Seed2,
        SeedNumber2,
        UpsetProbability,
        RecentPerformanceBonus,
        OvertimeBonus,
        ScoringMarginBonus,
        CASE 
            WHEN (UpsetProbability + RecentPerformanceBonus + OvertimeBonus + ScoringMarginBonus) > RANDOM() THEN Team2
            ELSE Team1
        END AS PredictedWinner,
        CASE 
            WHEN (UpsetProbability + RecentPerformanceBonus + OvertimeBonus + ScoringMarginBonus) > RANDOM() THEN SeedNumber2
            ELSE SeedNumber1
        END AS PredictedWinnerSeedNumber
    FROM 
        upset_probability
),
-- Simulate Sweet 16
sweet_16 AS (
    SELECT 
        t1.PredictedWinner AS Team1,
        t1.Seed1 AS Seed1,
        t1.PredictedWinnerSeedNumber AS SeedNumber1,
        t2.PredictedWinner AS Team2,
        t2.Seed1 AS Seed2,
        t2.PredictedWinnerSeedNumber AS SeedNumber2,
        t1.UpsetProbability,
        t1.RecentPerformanceBonus,
        t1.OvertimeBonus,
        t1.ScoringMarginBonus,
        CASE 
            WHEN (t1.UpsetProbability + t1.RecentPerformanceBonus + t1.OvertimeBonus + t1.ScoringMarginBonus) > RANDOM() THEN t2.PredictedWinner
            ELSE t1.PredictedWinner
        END AS PredictedWinner,
        CASE 
            WHEN (t1.UpsetProbability + t1.RecentPerformanceBonus + t1.OvertimeBonus + t1.ScoringMarginBonus) > RANDOM() THEN t2.PredictedWinnerSeedNumber
            ELSE t1.PredictedWinnerSeedNumber
        END AS PredictedWinnerSeedNumber
    FROM 
        round_of_64 t1
    JOIN 
        round_of_64 t2
    ON 
        (t1.PredictedWinnerSeedNumber + t2.PredictedWinnerSeedNumber) IN (17, 9) -- Pair winners from Round of 64
    WHERE 
        t1.PredictedWinnerSeedNumber < t2.PredictedWinnerSeedNumber -- Ensure each matchup is listed only once
),
-- Simulate Elite 8
elite_8 AS (
    SELECT 
        t1.PredictedWinner AS Team1,
        t1.Seed1 AS Seed1,
        t1.PredictedWinnerSeedNumber AS SeedNumber1,
        t2.PredictedWinner AS Team2,
        t2.Seed1 AS Seed2,
        t2.PredictedWinnerSeedNumber AS SeedNumber2,
        t1.UpsetProbability,
        t1.RecentPerformanceBonus,
        t1.OvertimeBonus,
        t1.ScoringMarginBonus,
        CASE 
            WHEN (t1.UpsetProbability + t1.RecentPerformanceBonus + t1.OvertimeBonus + t1.ScoringMarginBonus) > RANDOM() THEN t2.PredictedWinner
            ELSE t1.PredictedWinner
        END AS PredictedWinner,
        CASE 
            WHEN (t1.UpsetProbability + t1.RecentPerformanceBonus + t1.OvertimeBonus + t1.ScoringMarginBonus) > RANDOM() THEN t2.PredictedWinnerSeedNumber
            ELSE t1.PredictedWinnerSeedNumber
        END AS PredictedWinnerSeedNumber
    FROM 
        sweet_16 t1
    JOIN 
        sweet_16 t2
    ON 
        (t1.PredictedWinnerSeedNumber + t2.PredictedWinnerSeedNumber) IN (17, 9) -- Pair winners from Sweet 16
    WHERE 
        t1.PredictedWinnerSeedNumber < t2.PredictedWinnerSeedNumber -- Ensure each matchup is listed only once
),
-- Simulate Final Four
final_four AS (
    SELECT 
        t1.PredictedWinner AS Team1,
        t1.Seed1 AS Seed1,
        t1.PredictedWinnerSeedNumber AS SeedNumber1,
        t2.PredictedWinner AS Team2,
        t2.Seed1 AS Seed2,
        t2.PredictedWinnerSeedNumber AS SeedNumber2,
        t1.UpsetProbability,
        t1.RecentPerformanceBonus,
        t1.OvertimeBonus,
        t1.ScoringMarginBonus,
        CASE 
            WHEN (t1.UpsetProbability + t1.RecentPerformanceBonus + t1.OvertimeBonus + t1.ScoringMarginBonus) > RANDOM() THEN t2.PredictedWinner
            ELSE t1.PredictedWinner
        END AS PredictedWinner,
        CASE 
            WHEN (t1.UpsetProbability + t1.RecentPerformanceBonus + t1.OvertimeBonus + t1.ScoringMarginBonus) > RANDOM() THEN t2.PredictedWinnerSeedNumber
            ELSE t1.PredictedWinnerSeedNumber
        END AS PredictedWinnerSeedNumber
    FROM 
        elite_8 t1
    JOIN 
        elite_8 t2
    ON 
        (t1.PredictedWinnerSeedNumber + t2.PredictedWinnerSeedNumber) IN (17, 9) -- Pair winners from Elite 8
    WHERE 
        t1.PredictedWinnerSeedNumber < t2.PredictedWinnerSeedNumber -- Ensure each matchup is listed only once
),
-- Simulate Championship
championship AS (
    SELECT 
        t1.PredictedWinner AS Team1,
        t1.Seed1 AS Seed1,
        t1.PredictedWinnerSeedNumber AS SeedNumber1,
        t2.PredictedWinner AS Team2,
        t2.Seed1 AS Seed2,
        t2.PredictedWinnerSeedNumber AS SeedNumber2,
        t1.UpsetProbability,
        t1.RecentPerformanceBonus,
        t1.OvertimeBonus,
        t1.ScoringMarginBonus,
        CASE 
            WHEN (t1.UpsetProbability + t1.RecentPerformanceBonus + t1.OvertimeBonus + t1.ScoringMarginBonus) > RANDOM() THEN t2.PredictedWinner
            ELSE t1.PredictedWinner
        END AS PredictedWinner,
        -- Include PredictedWinnerSeedNumber for consistency
        CASE 
            WHEN (t1.UpsetProbability + t1.RecentPerformanceBonus + t1.OvertimeBonus + t1.ScoringMarginBonus) > RANDOM() THEN t2.PredictedWinnerSeedNumber
            ELSE t1.PredictedWinnerSeedNumber
        END AS PredictedWinnerSeedNumber
    FROM 
        final_four t1
    JOIN 
        final_four t2
    ON 
        (t1.PredictedWinnerSeedNumber + t2.PredictedWinnerSeedNumber) IN (17, 9) -- Pair winners from Final Four
    WHERE 
        t1.PredictedWinnerSeedNumber < t2.PredictedWinnerSeedNumber -- Ensure each matchup is listed only once
)
-- Final Output
SELECT 'Round of 64' AS Round, * FROM round_of_64
UNION ALL
SELECT 'Sweet 16' AS Round, * FROM sweet_16
UNION ALL
SELECT 'Elite 8' AS Round, * FROM elite_8
UNION ALL
SELECT 'Final Four' AS Round, * FROM final_four
UNION ALL
SELECT 'Championship' AS Round, * FROM championship;