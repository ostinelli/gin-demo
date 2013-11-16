local SqlMigration = {}

-- specify the database used in this migration (needed by the Gin migration engine)
SqlMigration.db = require 'db.mysql'

function SqlMigration.up()
    -- Run your migration
    SqlMigration.db:execute([[
        CREATE TABLE users (
            id int NOT NULL AUTO_INCREMENT,
            first_name varchar(255) NOT NULL,
            last_name varchar(255),
            PRIMARY KEY (id),
            UNIQUE (first_name)
        );
    ]])
end

function SqlMigration.down()
    -- Run your rollback
    SqlMigration.db:execute([[
        DROP TABLE users;
    ]])
end

return SqlMigration
