defmodule ParkingappbackendWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :parkingappbackend

  socket "/socket", ParkingappbackendWeb.UserSocket,
    websocket: true,
    longpoll: false,
    origins: ["https://agile-project-tartu-university.appspot.com", "wss://agile-project-tartu-university.appspot.com"],
    check_origin: false


  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :parkingappbackend,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_parkingappbackend_key",
    signing_salt: "yeCDF3Nl"

  plug CORSPlug, origin: ["http://localhost:8081", "http://localhost:8080", "https://agile-project-tartu-university.appspot.com"]

  plug ParkingappbackendWeb.Router


end
