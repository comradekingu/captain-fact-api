defmodule CaptainFactWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :captain_fact

  socket "/socket", CaptainFactWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :captain_fact, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  plug Plug.Static, at: "/resources", from: "./resources", gzip: false

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_captain_fact_key",
    signing_salt: "M8OYuALs"

  plug Corsica,
       max_age: 3600,
       allow_headers: ~w(Accept Content-Type Authorization),
       origins: {CaptainFactWeb.CORS, :check_origin}

  plug CaptainFactWeb.Router
end
