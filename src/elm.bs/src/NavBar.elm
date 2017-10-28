module NavBar exposing (..)

import Bootstrap.Navbar as Navbar


-----------------------------------------------
--  M O D E L


type alias Model =
    Navbar.State



-----------------------------------------------
--  U P D A T E


type alias Msg =
    NavMsg Navbar.State
