-- gin
local MySql = require 'db.mysql'
local SqlOrm = require 'gin.db.sql.orm'

-- define
return SqlOrm.define_model(MySql, 'users')
