require 'spec.spec_helper'

local MySql = require 'db.mysql'
local Users = require 'app.models.users'

local function clean_db()
    MySql:execute("TRUNCATE TABLE users;")
end


describe("UsersController", function()
    before_each(function()
        clean_db()
    end)

    after_each(function()
        clean_db()
    end)

    describe("#index", function()
        before_each(function()
            roberto = Users.create({first_name = 'roberto', last_name = 'gin'})
            hedy = Users.create({first_name = 'hedy', last_name = 'tonic'})
        end)

        after_each(function()
            roberto = nil
            hedy = nil
        end)

        it("shows the list of users ordered by first name", function()
            local response = hit({
                method = 'GET',
                path = "/users"
            })

            assert.are.equal(200, response.status)

            assert.are.same({
                [1] = hedy,
                [2] = roberto
            }, response.body)
        end)
    end)

    describe("#create", function()
        it("adds a new user filtering out unaccepted params", function()
            local request_new_user = {
                first_name = 'new-user',
                last_name = 'gin',
                id = 400,
                nonexisent_param = 'non-existent'
            }

            local response = hit({
                method = 'POST',
                path = "/users",
                body = request_new_user
            })

            local new_user = Users.find_by({ first_name = 'new-user' })
            assert.are_not.equals(nil, new_user)

            assert.are.equal(201, response.status)

            assert.are.same('new-user', new_user.first_name)
            assert.are.same('gin', new_user.last_name)
            assert.are.not_equals(400, new_user.id)
            assert.are.not_equals('non-existent', new_user.nonexisent_param)
        end)
    end)

    describe("#show", function()
        describe("when the user can be found", function()
            before_each(function()
                roberto = Users.create({first_name = 'roberto', last_name = 'gin'})
            end)

            after_each(function()
                roberto = nil
            end)

            it("shows a user", function()
                local response = hit({
                    method = 'GET',
                    path = "/users/roberto"
                })

                assert.are.equal(200, response.status)
                assert.are.same(roberto, response.body)
            end)
        end)

        describe("when the user cannot be found", function()
            it("returns a 404", function()
                local response = hit({
                    method = 'GET',
                    path = "/users/roberto"
                })

                assert.are.equal(404, response.status)
                assert.are.same({}, response.body)
            end)
        end)
    end)
end)
