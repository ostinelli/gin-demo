local UsersController = {}

function UsersController:index()
    local Users = require 'app.models.users'
    local users = Users.all({ order = "first_name" })

    return 200, users
end

function UsersController:create()
    local Users = require 'app.models.users'

    local params = self:accepted_params({ 'first_name', 'last_name' }, self.request.body)
    local new_user = Users.create(params)

    return 201, new_user
end

function UsersController:show()
    local Users = require 'app.models.users'
    local user = Users.find_by({ first_name = self.params.first_name })

    if user then
        return 200, user
    else
        return 404
    end
end

return UsersController
