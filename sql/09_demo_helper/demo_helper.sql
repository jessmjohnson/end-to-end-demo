
 SELECT TOP (100) * FROM [Telemetry].[vw_WorkloadOverview]

 SELECT TOP (100) * FROM Telemetry.Requests_Snapshot

 SELECT TOP (100) * FROM Telemetry.QS_Snapshot

 SELECT TOP (100) * FROM Telemetry.vw_PerformanceSnapshot;

 SELECT TOP (100) * FROM Telemetry.PlanDetails;  --save as .sqlplan

SELECT TOP (100) * FROM Telemetry.vw_Troubleshoot_PipelineLog


 SELECT * FROM sys.query_store_query_text t
 JOIN sys.query_store_query q on q.query_text_id = t.query_text_id
 WHERE q.query_id = 4

-- sys.query_store_plan


-- then use these Query Store views to get stats + text + plan
CREATE VIEW Telemetry.vw_QS_StatsTextPlan AS
SELECT
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
WHERE i.start_time >= DATEADD(HOUR, -1, SYSUTCDATETIME())
