use tempdb
EXEC master.dbo.sp_BlitzIndex @getalldatabases = 1, @BringThePain = 1
EXEC master.dbo.sp_BlitzIndex @GetAllDatabases = 1, @Mode = 1 -- summarize database metrics
EXEC master.dbo.sp_BlitzIndex @GetAllDatabases = 1, @Mode = 2 -- index usage details

EXEC master..sp_BlitzIndex @DatabaseName = 'VDP' ,@BringThePain = 1 -- Bring only main issues
EXEC master..sp_BlitzIndex @DatabaseName = 'FMO' ,@BringThePain = 1 -- Bring only main issues
EXEC master..sp_BlitzIndex @DatabaseName = 'SRA' ,@BringThePain = 1 -- Bring only main issues

EXEC master..sp_BlitzIndex @DatabaseName = 'KYC_CI', @SchemaName = 'dbo', @TableName = 'tblRnELeadMaster'
EXEC master..sp_BlitzIndex @DatabaseName = 'Cosmo', @SchemaName = 'dbo', @TableName = 'rm_image_file'
EXEC master..sp_BlitzIndex @DatabaseName = 'Cosmo', @SchemaName = 'dbo', @TableName = 'rm_image_relevancy_link'
EXEC master..sp_BlitzIndex @DatabaseName = 'Cosmo', @SchemaName = 'dbo', @TableName = 'schedule_link'
EXEC master..sp_BlitzIndex @DatabaseName = 'Cosmo', @SchemaName = 'dbo', @TableName = 'schres_configuration'
EXEC master..sp_BlitzIndex @DatabaseName = 'Cosmo', @SchemaName = 'dbo', @TableName = 'source_tv'
go

/*	Store index Details into Table, and Analyze them one by one */
declare @database_name varchar(200) = 'KYC_CI'
declare @table_name varchar(200) = 'tbl_email_registration_otp_log_email'

declare @sql nvarchar(max);
set @sql = '
select [index_name] = i.database_name+''.''+i.schema_name+''.''+i.table_name+''.''+i.index_name, i.index_definition, i.index_size_summary,
		i.index_usage_summary, i.index_op_stats, i.data_compression_desc, i.fill_factor, i.create_date
		--,i.*
from tempdb..BlitzIndexOutput i
where i.database_name = @p_database_name
and i.table_name = @p_table_name
order by case when index_id <= 1 then ''1'' else i.key_column_names_with_sort_order end '
exec sp_executesql @sql, N'@p_database_name varchar(200), @p_table_name varchar(200)'
					,@p_database_name=@database_name, @p_table_name=@table_name;

exec sp_BlitzIndex @DatabaseName = @database_name, @TableName = @table_name


/*
exec sp_BlitzIndex @GetAllDatabases = 1, @Mode = 2, @BringThePain = 1
					,@OutputDatabaseName = 'tempdb', @OutputSchemaName = 'dbo', @OutputTableName = 'BlitzIndexOutput'
go
*/

--select top 10 * from tempdb..BlitzIndexOutput i