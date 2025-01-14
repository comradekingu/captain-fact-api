defmodule CF.GraphQLWeb.Router do
  use CF.GraphQLWeb, :router

  @graphiql_route "/graphiql"

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :api_auth do
    plug(:accepts, ["json"])
    plug(CF.Graphql.AuthPipeline)
  end

  pipeline :basic_auth do
    plug(BasicAuth, use_config: {:cf_graphql, :basic_auth})
  end

  scope "/" do
    pipe_through(:api_auth)

    scope @graphiql_route do
      if Mix.env() == :prod, do: pipe_through(:basic_auth)

      forward(
        "/",
        Absinthe.Plug.GraphiQL,
        schema: CF.Graphql.Schema,
        analyze_complexity: true,
        max_complexity: 400
      )
    end

    forward(
      "/",
      Absinthe.Plug,
      schema: CF.Graphql.Schema,
      analyze_complexity: true,
      max_complexity: 400
    )
  end
end
