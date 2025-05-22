/****************************************************************************************
 * Script : vw_QS_StatsTextPlan.sql
 * Schema : Telemetry
 * Purpose: Provides SQL text and plan alongside runtime stats for queries executed in the last hour.
 * Author : Jess Johnson
 * Created: 2025-05-19
 * Version: 1.0
 *
 * Description: Returns execution time, query text, CPU and duration metrics, and plan XML for recent query executions.
 *
 * Why: Enables deep troubleshooting by correlating textual SQL and execution plans with performance metrics.
 *
 * Usage: Query to review heavy queries in the last hour and their plans for optimization.
 *
 * Benefits: Quick identification of slow or resource-intensive queries with context.
 *
 * Dependencies:
 *   - sys.query_store_runtime_stats
 *   - sys.query_store_runtime_stats_interval
 *   - sys.query_store_plan
 *   - sys.query_store_query
 *   - sys.query_store_query_text
 *
 * Change History:
 * 2025-05-19 JJ-1.0 Initial creation
 ****************************************************************************************/

-- ======================================================================================
-- SECTION 1: Declarations
-- ======================================================================================
-- No parameters required.

-- ======================================================================================
-- SECTION 2: Main logic
-- ======================================================================================

CREATE VIEW [Telemetry].[vw_QS_StatsTextPlan]
AS SELECT
    i.start_time              AS ExecutionTime,
    qt.query_sql_text         AS SqlText,
    rs.avg_cpu_time           AS AvgCPU_ms,
    rs.avg_duration           AS AvgDuration_ms,
    rs.max_duration           AS MaxDuration_ms,
    rs.count_executions       AS ExecutionCount,
    p.query_plan              AS QueryPlanXml
FROM sys.query_store_runtime_stats     AS rs
JOIN sys.query_store_runtime_stats_interval AS i
    ON rs.runtime_stats_interval_id = i.runtime_stats_interval_id
JOIN sys.query_store_plan             AS p
    ON rs.plan_id = p.plan_id
JOIN sys.query_store_query            AS q
    ON p.query_id = q.query_id
JOIN sys.query_store_query_text       AS qt
    ON q.query_text_id = qt.query_text_id
-- optional: filter to recent executions
WHERE i.start_time >= DATEADD(HOUR, -1, SYSUTCDATETIME());
GO

-- ======================================================================================
-- SECTION 3: Cleanup / Reporting
-- ======================================================================================
-- No cleanup required.
GO