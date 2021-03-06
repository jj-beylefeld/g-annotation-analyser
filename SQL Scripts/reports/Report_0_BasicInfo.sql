/****** Script for SelectTopNRows command from SSMS  ******/
;with cte as (
SELECT distinct 
FI.File_No
,FI.Report_Description
,Gene
,Start
,[End]
,Strand
,Name
  FROM [AmandaTasks].[dbo].[FileData] FD
  join FileInfo FI on FI.File_no = FD.File_No
  And FI.IgnoreCompAna = 0
  )
select 
Report_Description
,Gene
,count(*) Counted
from cte
Group BY 
Gene
, Report_Description