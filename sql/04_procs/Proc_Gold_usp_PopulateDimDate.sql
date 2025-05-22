--DROP PROCEDURE Gold.usp_PopulateDimDate
CREATE PROCEDURE Gold.usp_PopulateDimDate
AS
BEGIN
    SET NOCOUNT ON;

    ----------------------------------------------------------------
    -- 1) Declare & set your date bounds and span
    ----------------------------------------------------------------
    DECLARE 
        @StartDate DATE,
        @EndDate   DATE,
        @Days      INT;

    SET @StartDate = '1950-01-01';
    SET @EndDate   = '2050-12-31';
    SET @Days      = DATEDIFF(DAY, @StartDate, @EndDate);

    ----------------------------------------------------------------
    -- 2) Empty the dimension
    ----------------------------------------------------------------
    TRUNCATE TABLE Gold.dimDate;

    ----------------------------------------------------------------
    -- 3) Build a 65K+ tally table and generate all dates set‑based
    ----------------------------------------------------------------
    ;WITH
    E1  AS (SELECT 1 AS n UNION ALL SELECT 1),
    E2  AS (SELECT 1 AS n FROM E1 a CROSS JOIN E1 b),     -- 4 rows
    E4  AS (SELECT 1 AS n FROM E2 a CROSS JOIN E2 b),     -- 16
    E8  AS (SELECT 1 AS n FROM E4 a CROSS JOIN E4 b),     -- 256
    E16 AS (SELECT 1 AS n FROM E8 a CROSS JOIN E8 b),     -- 65,536
    nums AS (
      SELECT TOP (@Days + 1)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS DayOffset
      FROM E16
    ),
    Calendar AS (
      SELECT DATEADD(DAY, DayOffset, @StartDate) AS d
      FROM nums
    )

    ----------------------------------------------------------------
    -- 4) Bulk‑insert 1950‑2050
    ----------------------------------------------------------------
    INSERT INTO Gold.dimDate
    (
        DateKey,
        FullDate,
        DayOfWeek,
        DayName,
        DayOfMonth,
        DayOfYear,
        WeekOfYear,
        MonthOfYear,
        MonthName,
        Quarter,
        QuarterName,
        [Year],
        IsWeekend
    )
    SELECT
        YEAR(d)*10000 + MONTH(d)*100 + DAY(d)            AS DateKey,
        d                                               AS FullDate,
        DATEPART(WEEKDAY, d)                            AS DayOfWeek,
        DATENAME(WEEKDAY, d)                            AS DayName,
        DAY(d)                                          AS DayOfMonth,
        DATEPART(DAYOFYEAR, d)                          AS DayOfYear,
        DATEPART(WEEK, d)                               AS WeekOfYear,
        MONTH(d)                                        AS MonthOfYear,
        DATENAME(MONTH, d)                              AS MonthName,
        DATEPART(QUARTER, d)                            AS Quarter,
        'Q' + CONVERT(VARCHAR(1), DATEPART(QUARTER, d)) AS QuarterName,
        YEAR(d)                                         AS [Year],
        CASE WHEN DATEPART(WEEKDAY, d) IN (1,7) THEN 1 ELSE 0 END
                                                       AS IsWeekend
    FROM Calendar;

    ----------------------------------------------------------------
    -- 5) Append the fixed 1900‑01‑01 row using *only* literals
    ----------------------------------------------------------------
    INSERT INTO Gold.dimDate
    (
        DateKey,
        FullDate,
        DayOfWeek,
        DayName,
        DayOfMonth,
        DayOfYear,
        WeekOfYear,
        MonthOfYear,
        MonthName,
        Quarter,
        QuarterName,
        [Year],
        IsWeekend
    )
    VALUES
    (
        19000101,      -- YYYYMDD
        '1900-01-01',  -- FullDate
        2,             -- Monday (1=Sunday→2=Monday)
        'Monday',
        1,
        1,
        1,
        1,
        'January',
        1,
        'Q1',
        1900,
        0
    );
END;
GO
