ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Kart.Repo, :manual)

Mox.defmock(HTTPoison.MockBase, for: HTTPoison.Base)
Mox.defmock(Kart.MockOauthToken, for: Kart.OauthToken)

Application.put_env(:kart, :http_client, HTTPoison)
Application.put_env(:kart, :oauth_token, Kart.OauthToken)
