CREATE PROC [Control].[usp_InsertFileList] @FileName [VARCHAR](260),@FileDateString [CHAR](8),@PipelineName [VARCHAR](50),@EnqueueTime [DATETIME2] AS
BEGIN
    SET NOCOUNT ON;

    -- Only insert if this file/run isn’t already recorded
    IF NOT EXISTS (
        SELECT 1
          FROM Control.FileList  -- WITH (NOLOCK) optional
         WHERE FileName     = @FileName
           AND FileDateString     = @FileDateString
           AND PipelineName = @PipelineName
    )
    BEGIN
        INSERT INTO Control.FileList (
            FileName,
            FileDateString,
            PipelineName,
            EnqueueTime
        )
        VALUES (
            @FileName,
            @FileDateString,
            @PipelineName,
            @EnqueueTime
        );
    END
END
GO