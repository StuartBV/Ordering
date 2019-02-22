CREATE TYPE [dbo].[SysComments] FROM varchar (100) NULL
GO
GRANT REFERENCES ON TYPE:: [dbo].[SysComments] TO [public]
GO
