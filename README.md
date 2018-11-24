Apino
-----

Apino is a resilient backend as a service system that can scale with your application.

Usage
=====

  ```bash
  # start the database
  docker-compose -p apino up -d
  # start the apino server
  mix phx.server
  ```

Architecture
============

- Builder - allows the creation of entities/collections and definning the types, 
  validations and triggers that will be executed with each new record.
- Management - allows the management of data that was created with the builder
- Admin - User interface for creating and managing the contents of the server

Tips
====

Generate the code as files and apps instead of checking the db for the filestructure for each of them.

Learning
========

- IN PROGRESS https://strapi.io/documentation/3.x.x/concepts/concepts.html
- TODO check out multiple existing libraries that can be used to build the application
- 

References
==========

- https://strapi.io
- https://github.com/h4cc/awesome-elixir
- https://github.com/zbarnes757/jeaux
- https://stackoverflow.com/questions/46853270/dynamic-models-in-phoenix-framework
- https://infismash.com/bootstrapping-an-api-only-backend-for-a-social-networking-app-using-elixir-f74a73b1da51
- https://stackoverflow.com/questions/38442334/source-code-generation-in-elixir


Standards
=========

- https://jsonapi.org/format/

Development steps
=================
> mix phx.new --umbrella --no-html --no-webpack apino
> cd apino_umbrella
> mix ecto.create
> mix phx.server

