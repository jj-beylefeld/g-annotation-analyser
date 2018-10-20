CREATE PROCEDURE sp_Import_GFF_generic
@tablename varchar(50) --= 'B878_14_M5'
,@folder varchar(500) --= 'C:\Personal\Amanda\Amanda-PhD\Mgallinaceum_MGa\GFF\'
,@M_Type_No int --= 4
AS
BEGIN

--declare @tablename varchar(50) = 'B878_14_M5'
--declare @folder varchar(500) = 'C:\Personal\Amanda\Amanda-PhD\Mgallinaceum_MGa\GFF\'
--declare @M_Type_No int = 4

declare @filename varchar(2000) = @folder+@tablename+'.gff'

declare @tmp varchar(300) ;
select @tmp = reverse(substring(reverse(@filename),1,charindex('\',reverse(@filename)) -1 ))


insert into FileInfo (M_Type_No,File_Name, Report_Description) 
select @M_Type_No,@filename ,replace(@tmp,'.gff','') Report_Description
where not exists(select * from FileInfo where M_Type_No=@M_Type_No and File_Name=@filename)

declare @sql nvarchar(max) =
'
delete from AmandaTasks.dbo.Generic
;BULK INSERT AmandaTasks.dbo.Generic FROM '''+@filename+''' 
WITH 
(
DATAFILETYPE = ''char''
, ROWTERMINATOR = ''0x0a''
,FIELDTERMINATOR = ''\t''
,firstrow=1
,KEEPNULLS) 
BEGIN TRY
BEGIN TRANSACTION
if object_ID(''AmandaTasks..'+@tablename+''') is null
select * into AmandaTasks..'+@tablename+' from AmandaTasks.dbo.Generic

declare @fileNo int = (select File_No from FileInfo where Report_Description='''+@tablename+''')
--select @fileNo

;with cte as (
select 
* 
,SUBSTRING(column9,1,charindex('';'',column9,1)-1) IDInfo
,SUBSTRING(column9,1+charindex('';'',column9,1),len(column9) - charindex('';'',column9,1)+1) NameInfo
,reverse(SUBSTRING(reverse(column9),1,charindex('';'',reverse(column9),1)-1)) OntInfo
from '+@tablename+'
), cte_fin as (

select 
column1 AS ContigInfo
, column2  AS FIG
, column3 AS Gene
, column4 AS Start
, column5 as [end]
, column6 as [Dot]
, column7 as Strand
, column8 as Number 
, IDInfo ID_text
, NameInfo Name_Text
, OntInfo Ont_Text
,SUBSTRING(IDInfo,1+charindex(''='',IDInfo,1),len(IDInfo) - charindex(''='',IDInfo,1)+1)		 IDInfo
,SUBSTRING(NameInfo,1+charindex(''='',NameInfo,1),len(NameInfo) - charindex(''='',NameInfo,1)+1) NameInfo
,SUBSTRING(OntInfo,1+charindex(''='',OntInfo,1),len(OntInfo) - charindex(''='',OntInfo,1)+1)	 OntInfo
from cte

)
insert into FileData (File_No,Contig_info, FIG, Gene, Start, [End], Dot, Strand, Number, ID, Name, Ontology)
select 
@fileNo
, ContigInfo
, FIG
, Gene
, Start
, [end]
, [Dot]
, Strand
, Number 
, IDInfo AS ID
, replace(NameInfo,'';''+Ont_Text,'''') NameInfo
, case when NameInfo=OntInfo then null else OntInfo end AS Ontology
from cte_fin
where not exists
(
	select * from FileData where
	1=1
	AND @fileNo = File_no
	AND cte_fin.FIG = FIG
	AND cte_fin.Gene = Gene
	AND cte_fin.ContigInfo = ContigInfo
	AND cte_fin.Start = Start
	AND cte_fin.[end] = [end]
)



COMMIT
END TRY
BEGIN CATCH
ROLLBACK
print ''rollback applied''
SELECT ERROR_MESSAGE() 
END CATCH
'

exec sp_executesql @sql

--COMMIT
--END TRY
--BEGIN CATCH
--ROLLBACK
--print 'rollback applied'
--SELECT ERROR_MESSAGE() 
--END CATCH
--select * from fileinfo
--delete from fileinfo where file_no = 1047
--select * from Filedata where file_no = 1049
--delete from Filedata where file_no = 1049


END