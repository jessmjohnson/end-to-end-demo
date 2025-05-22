/*****************************************************************************************/
/** PlanDetails                                                                         **/
/**     What:   Stores full XML execution plans from Query Store.                       **/
/**                                                                                     **/
/**     Why:    Offers deep insight into operator choices for post‑mortem analysis.     **/
/*****************************************************************************************/


CREATE TABLE Telemetry.PlanDetails
(
  CaptureTime DATETIME2     NOT NULL,
  QueryId     BIGINT        NOT NULL,
  PlanId      BIGINT        NOT NULL,
  PlanXml     NVARCHAR(MAX) NOT NULL
)
WITH
(
  DISTRIBUTION = ROUND_ROBIN
);
