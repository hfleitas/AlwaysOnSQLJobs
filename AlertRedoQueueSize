
use fleitasarts
go
if not exists (select 1 from sysobjects where name='AlertRedoQueueSize' and type='P') exec('create proc AlertRedoQueueSize as set nocount on;')
go
--create or alter proc AlertRedoQueueSize
alter procedure AlertRedoQueueSize
as
set nocount on;
 
declare @warn int = 94371840, @crit int = 104857600, --(nKB/1GB) warn: 90GB, crit: 100GB.
              @rds bigint, @dbname nvarchar(128), @node varchar(128), 
              @msg nvarchar(max), @to varchar(max) = 'dba2.o@fleitasarts.com'
 
select top 1 @rds = coalesce(max(drs.redo_queue_size), 0), @dbname = db_name(drs.database_id), @node = ar.replica_server_name
from sys.dm_hadr_availability_replica_states ars
left join sys.availability_replicas ar on ar.replica_id = ars.replica_id
left join sys.availability_groups ag on ag.group_id = ars.group_id
left join sys.dm_hadr_database_replica_states drs on drs.replica_id = ars.replica_id
where ars.role_desc = 'secondary'
and drs.redo_queue_size > @warn
group by db_name(drs.database_id), ar.replica_server_name
order by coalesce(max(drs.redo_queue_size), 0) desc
 
if @rds > @warn and @rds < @crit 
begin
       select @msg = @node + '.' + @dbname + ': ' + convert(varchar(20), @rds);
       exec msdb.dbo.sp_send_dbmail @recipients = @to 
       ,@subject = 'Warn: Max redo_queue_size > 90GB'
       ,@body = @msg
end
if @rds >= @crit
begin
       set @msg = null;
       select @msg = @node + '.' + @dbname + ': ' + convert(varchar(20), @rds);
       exec msdb.dbo.sp_send_dbmail @recipients = @to
       ,@subject = 'Crit: Max redo_queue_size >= 100GB'
       ,@body = @msg
       ,@importance = 'high'
end
go
