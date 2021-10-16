defmodule KartWeb.OauthControllerTest do
  use KartWeb.ConnCase

  test "GET /oauth", %{conn: conn} do
    # conn = get(conn, "/oauth")
    # KartWeb.MockOauthToken
    # |> expect(:get_token!, fn _ -> "token" end)

    # assert html_response(conn, 200) =~ "token"
  end
end
