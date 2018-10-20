DECLARE @M_Type varchar(50) = 'MG'
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
	, Ontology
	FROM [AmandaTasks].[dbo].[FileData] FD
	JOIN FileInfo FI ON FI.File_no = FD.File_No
	join M_Types MT on MT.M_Type_No = FI.M_Type_No
  --LEFT JOIN Category C ON FD.Name = C.Role_Name
  WHERE Gene= coalesce(@Gene,Gene)
  AND MT.M_Type_Name = coalesce(@M_Type,MT.M_Type_Name)
  And FI.IgnoreCompAna = 0
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
	,'5S rRNA' Gene
	, Count(*) AS Counted
	from
	cte
	where gene = 'RNA'
	and (name like '%5S rRNA%'
	or Ontology like '%5S rRNA%')
	group by
	Report_Description
	,Gene

  ),cte_rna_LSU as (

	select
	Report_Description
	,'23S rRNA' Gene
	, Count(*) AS Counted
	from
	cte
	where gene = 'RNA'
	and (name like '%LSU%'
	or Ontology like '%LSU%')
	group by
	Report_Description
	,Gene

  ),cte_rna_SSU as (

	select
	Report_Description
	,'16S rRNA' Gene
	, Count(*) AS Counted
	from
	cte
	where gene = 'RNA'
	and (name like '%SSU%'
	OR Ontology  like '%SSU%')
	group by
	Report_Description
	,Gene

  ),prePivot as (
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
)
/* below select generated pivot queries */
/*select distinct ',['+Gene+']',',coalesce(['+Gene+'],0) as ['+Gene+']' from prePivot*/
select
piv.Report_Description as Strain
/* generated code from here */
,coalesce([CDS],0) as [CDS]
,coalesce([CDS Known (Categorised)],0) as [CDS Known (Categorised)]
,coalesce([CDS Known (Uncategorised)],0) as [CDS Known (Uncategorised)]
,coalesce([CDS Hypothetic],0) as [CDS Hypothetic]
,coalesce([tRNA],0) as [tRNA]
,coalesce([RNA],0) as [RNA]
,coalesce([5S rRNA],0) as [5S rRNA]
,coalesce([16S rRNA],0) as [16S rRNA]
,coalesce([23S rRNA],0) as [23S rRNA]
/* dependent result*/
,coalesce([RNA],0) - (coalesce([5S rRNA],0) +coalesce([16S rRNA],0)+coalesce([23S rRNA],0) ) ncRNA


from
prePivot
pivot ( 
	/*select ',['+Gene+']',',coalesce(['+Gene+'],0) as ['+Gene+']' from FileInfo*/
	/*select ',['+Report_Description+']',',coalesce(['+Report_Description+'],0) as ['+Report_Description+']' from FileInfo*/
	max(Counted) for Gene in ([16S rRNA],[23S rRNA],[5S rRNA],[CDS Hypothetic],[CDS Known (Categorised)],[CDS Known (Uncategorised)],[CDS],[RNA],[tRNA])
) piv