DECLARE @M_Type varchar(50) = 'MS'
,@Gene varchar(20) = null--'CDS'

;WITH cte AS (
SELECT DISTINCT 
	FI.File_No
	, FI.Report_Description
	, Gene
	, Start
	, [End]
	, Strand
	, Name
	FROM [AmandaTasks].[dbo].[FileData] FD
	JOIN FileInfo FI ON FI.File_no = FD.File_No
	join M_Types MT on MT.M_Type_No = FI.M_Type_No
  --LEFT JOIN Category C ON FD.Name = C.Role_Name
  WHERE Gene= coalesce(@Gene,Gene)
  AND MT.M_Type_Name = coalesce(@M_Type,MT.M_Type_Name)
  ),cte_gene as (

	select
	Report_Description
	,Gene
	, Count(*) AS Counted
	from
	cte
	group by
	Report_Description
	,Gene

  )
  ,cte_cds_hypo as (

	select
	Report_Description
	,Gene + ' Hypothetic' Gene
	, Count(*) AS Counted
	from
	cte
	where gene = 'CDS'
	and name like '%hypoth%'
	group by
	Report_Description
	,Gene

  )
  ,cte_cds_knownC as (

	select
	Report_Description
	,Gene + ' Known (Categorised)' Gene
	, Count(*) AS Counted
	from
	cte
	join Category C on C.Role_Name = cte.Name
	where gene = 'CDS'
	and name not like '%hypoth%'
	group by
	Report_Description
	,Gene

  ),cte_cds_knownU as (

	select
	Report_Description
	,Gene + ' Known (Uncategorised)' Gene
	, Count(*) AS Counted
	from
	cte
	left join Category C on C.Role_Name = cte.Name
	where gene = 'CDS'
	and name not like '%hypoth%'
	and C.Category is null
	group by
	Report_Description
	,Gene

  ),cte_rna_5s as (

	select
	Report_Description
	,'5SrRNA' Gene
	, Count(*) AS Counted
	from
	cte
	where gene = 'RNA'
	and name like '%5S%'
	group by
	Report_Description
	,Gene

  ),cte_rna_LSU as (

	select
	Report_Description
	,'LSU' Gene
	, Count(*) AS Counted
	from
	cte
	where gene = 'RNA'
	and name like '%LSU%'
	group by
	Report_Description
	,Gene

  ),cte_rna_SSU as (

	select
	Report_Description
	,'SSU' Gene
	, Count(*) AS Counted
	from
	cte
	where gene = 'RNA'
	and name like '%SSU%'
	group by
	Report_Description
	,Gene

  )
select * from cte_gene
union
select * from cte_cds_hypo 
union
select * from cte_cds_knownC  
union
select * from cte_cds_knownU  
union
select * from cte_rna_5s  
union
select * from cte_rna_LSU  
union
select * from cte_rna_SSU

--select * from cte_gene  
  --,prePivot AS (

/*
)select
*
/* generated code from here */
--,coalesce([B1064_14_H3],0) as [B1064_14_H3]
--,coalesce([B1064_14_H4],0) as [B1064_14_H4]
--,coalesce([B1064_14_H5],0) as [B1064_14_H5]
--,coalesce([B1393_14_10],0) as [B1393_14_10]
--,coalesce([B1394_14_2],0) as [B1394_14_2]
--,coalesce([B1394_14_5],0) as [B1394_14_5]
--,coalesce([B2214_07],0) as [B2214_07]
--,coalesce([B458_15_1],0) as [B458_15_1]
--,coalesce([B458_15_11],0) as [B458_15_11]
--,coalesce([B458_15_5M],0) as [B458_15_5M]
--,coalesce([B458_15_6],0) as [B458_15_6]
--,coalesce([M Synoviae strain 53],0) as [M Synoviae strain 53]
from
prePivot
pivot ( /*select ',['+Report_Description+']',',coalesce(['+Report_Description+'],0) as ['+Report_Description+']' from FileInfo*/
	max(Counted) for Report_Description in ([B1064_14_H3],[B1064_14_H4],[B1064_14_H5],[B1393_14_10],[B1394_14_2],[B1394_14_5],[B2214_07],[B458_15_1],[B458_15_11],[B458_15_5M],[B458_15_6],[M Synoviae strain 53])
) piv*/