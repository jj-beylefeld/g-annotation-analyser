DECLARE @M_Type varchar(50) =null-- 'MS'
,@Gene varchar(20) = 'CDS'


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
  join M_Types MT on MT.M_Type_No = FI.M_Type_No
  --left join Category C on FD.Name
  where Gene= coalesce(@Gene,Gene)
  AND MT.M_Type_Name = coalesce(@M_Type,MT.M_Type_Name)
  And FI.IgnoreCompAna = 0
  )
select 
Report_Description
,Name
,count(*) Counted
from cte
--where Name like '%mobile%'
Group BY 
Name
, Report_Description