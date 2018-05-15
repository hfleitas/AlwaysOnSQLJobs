--TSQL step
--database: tempdb

if exists (select 1 
	from  sys.dm_hadr_availability_replica_states as ars
	inner join sys.availability_group_listeners as agl on ars.group_id = agl.group_id
	inner join sys.availability_replicas as arcn on arcn.replica_id = ars.replica_id
	where ars.role_desc = 'PRIMARY'
	and ars.operational_state_desc = 'ONLINE'
	and agl.dns_name = 'LGName1'
	and arcn.replica_server_name = @@SERVERNAME)

begin
	--job step here:
	execute WideWorldImporters.dbo.Report;
end

else begin
	print 'Server is not Primary for LG.'
end


--SSIS step
--database: master

if exists (select 1 
	from  sys.dm_hadr_availability_replica_states as ars
	inner join sys.availability_group_listeners as agl on ars.group_id = agl.group_id
	inner join sys.availability_replicas as arcn on arcn.replica_id = ars.replica_id
	where ars.role_desc = 'PRIMARY'
	and ars.operational_state_desc = 'ONLINE'
	and agl.dns_name = 'LGName1'
	and arcn.replica_server_name = @@SERVERNAME)

begin
	--job step here:
	EXEC xp_cmdshell 'dtexec /f "D:\SSIS\Export.dtsx" /CHECKPOINTING OFF /REPORTING E';
end

else begin
	print 'Server is not Primary for LG.'
end