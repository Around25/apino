Apino
-----

Apino is a resilient backend as a service system that can scale with your application.

The scope is to be able to configure your API through a UI dashboard that when the changes
are published will generate all the files needed the create/list/show/update/delete these
entitites.

Motivation
==========

Currently there is no framework/service for Elixir that can allow you to build applications fast
through a user interface dedicated for non technical people or for developers who want to focus on
building a mobile app instead of the backend, but that can be extended with new functionality as the 
application grows with time.

The goal of the project is to be the start of such as system, similar to Parse Framework, Strapi or Firebase.

TODO/Improvements
=================
- DONE Generate basic app/app_web file structure
- DONE Generate migrations for entities/properties
- DONE Generate models for entities/properties
- Update entities/properties based on the changes made to the db configuration instead of 
  recreating the all the generated code
- Allow the user to change the configuration params of the generated app
- Auto restart the generated apps once a new deploy was made
- Generate the entire app outside the current application
- Auto generate deployment packages with distillery after a publish

Usage
=====

Clone the project in the apino_umbrella folder.

First create the database and start the application.

  ```bash
  # start the postgres database on port 15432 using Docker or locally with the same details
  docker-compose -p apino up -d
  # start the apino server
  mix phx.server
  ```

Then use the information in the /docs folder to call the API and define entities and properties.

A Postman collection is available in the folder with request/response examples and a db export 
in CSV format shows my test configuration. You can download postman from their 
website https://www.getpostman.com/ or you can also run the endpoints using curl.

Use the /api/publish endpoint to generate the app based on your database entity/property configuration.

You can also start the app using `iex -S mix phx.server` and then run `Apino.Generator.CreateApp.deploy(:fresh)`.
After the files are generated you can exit the server and restart it using `iex -S mix phx.server`.

So far the app has the following functionality:
- Start the APINO API server and create entities and properties (string, password or reference)
  by calling the appropriate endpoints as seen the postman collection from /docs or by checking the router api
- Call the /api/publish endpoint to generate the /apps/app and /apps/app_web apps.
- Check out the code migrated: code structure, migrations and ecto models
- Run `mix ecto.migrate` in order to generate the database tables.
- Restart the server and check that both the apino server is started on port 4000 and that 
  the new generated app is started on port 3000
- That's it for now... controllers and extra configs are next to be able to call endpoints on the new server

Issues
======
- The entities must be added based on their references so that the migrations will not fail.
  The migrations will be generated with the inserted_at data as the prefix instead of any other order.
- Currently the application does not overwrite any files previously generated so you will need to 
  remove the existing apps first before calling the /publish endpoint again.
- Generated configuration is hardcoded for now.


References
==========

- https://strapi.io
- https://github.com/h4cc/awesome-elixir
- https://github.com/zbarnes757/jeaux
- https://stackoverflow.com/questions/46853270/dynamic-models-in-phoenix-framework
- https://infismash.com/bootstrapping-an-api-only-backend-for-a-social-networking-app-using-elixir-f74a73b1da51
- https://stackoverflow.com/questions/38442334/source-code-generation-in-elixir
- https://phoenixframework.org
- https://strapi.io/documentation/3.x.x/concepts/concepts.html


Standards
=========

- https://jsonapi.org/format/

Development steps
=================

Some development notes used in the project and that will be useful for new projects
  
  ```bash 
  # create umbrella app 
  mix phx.new --umbrella --no-html --no-webpack apino
  cd apino_umbrella
  # create database schema
  mix ecto.create
  # start phoenix server
  mix phx.server
  cd apps/apino_web
  # generate schema models (entity/property) and api
  mix phx.gen.json Schema Entity entities --table apino_entities name:string table_name:string status:string
  mix phx.gen.json Schema Property properties --table apino_properties \
  name:string field_name:string label:string status:string default_value:string \
  is_primary:boolean is_binary:boolean is_autogenerated:boolean is_unique:boolean entity_id:references:apino_entities
  # run migrations 
  mix ecto.migrate
  ```

