CREATE PROC [Telemetry].[usp_LogPipelineEvent] @PipelineRunId [UNIQUEIDENTIFIER],@PipelineName [VARCHAR](128),@StageName [VARCHAR](128),@ActivityName [VARCHAR](128),@EventType [VARCHAR](50),@EventTime [DATETIME2],@DurationSec [FLOAT],@RowsAffected [BIGINT],@Status [VARCHAR](50),@Message [VARCHAR](4000) AS
BEGIN
    INSERT INTO Telemetry.PipelineLog (
        PipelineRunId,PipelineName,StageName,ActivityName,EventType,EventTime,DurationSec,RowsAffected,Status,Message
    )
    VALUES (
        @PipelineRunId,@PipelineName,@StageName,@ActivityName,@EventType,@EventTime,@DurationSec,@RowsAffected,@Status,@Message
    );
END;
GO