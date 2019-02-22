SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
 create procedure [dbo].[UpdateStatistics]
@WithFullscan bit=0
as
set nocount on

declare @StartTime datetime=getdate(), @NumTables varchar(20)

if object_id('tempdb..#TablesToUpdateStats') is not null 
begin
	drop table #TablesToUpdateStats
end


select s.[name] as SchemaName, t.[name] as TableName, sum(p.rows) as RowsInTable
into #TablesToUpdateStats
from sys.schemas s
left join sys.tables t on s.schema_id=t.schema_id
left join sys.partitions p on t.object_id=p.object_id
left join sys.allocation_units a on p.partition_id=a.container_id
where p.index_id in ( 0, 1 ) and p.rows is not null and a.type=1 -- row-data only, not LOB
group by s.[name], t.[name]

select @NumTables=@@rowcount

declare updatestats cursor for
select row_number() over (order by RowsInTable), SchemaName, TableName, RowsInTable
from #TablesToUpdateStats
order by RowsInTable

open updatestats

declare @TableNumber varchar(20), @SchemaName nvarchar(128), @tableName nvarchar(128), @RowsInTable varchar(20), @Statement nvarchar(300), @Status nvarchar(300), @FullScanSQL varchar(20)

if @WithFullscan=1 
begin
	select @FullScanSQL=' WITH FULLSCAN'
end
else 
begin --If @WithFullscan<>1 then set @FullScanSQL to empty string
	select @FullScanSQL=''
end

fetch next from updatestats into @TableNumber, @SchemaName, @tableName,
@RowsInTable
while ( @@fetch_status=0 ) 
begin

	set @Statement='UPDATE STATISTICS [' + @SchemaName + '].[' + @tableName + ']' + @FullScanSQL

	set @Status='Table ' + @TableNumber + ' of ' + @NumTables + ': Running ''' + @Statement + ''' (' + @RowsInTable + ' rows)'
	raiserror (@Status, 0, 1) with nowait --RAISERROR used to immediately output status

	exec sp_executesql @Statement

	fetch next from updatestats into @TableNumber, @SchemaName,
	@tableName, @RowsInTable
end

close updatestats
deallocate updatestats

drop table #TablesToUpdateStats

print 'Total Elapsed Time: ' + convert(varchar(100), datediff(ss, @StartTime, getdate())) + ' Secs'

GO
