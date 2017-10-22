module Routes exposing (parser)

import UrlParser
import UrlParser exposing ((<?>))
import Main exposing (ModModel)


parser : UrlParser.Parser (ModModel -> a) a
parser =
    UrlParser.oneOf
        [ UrlParser.map (IndexModel Index.init) UrlParser.top
        , UrlParser.map (FindModel Find.initModel) (UrlParser.s "findconfig")

        --, UrlParser.map (FModel Find.execFind) (UrlParser.s "find")
        --, UrlParser.map (FModel Find.exec "sdfasdf") (UrlParser.s "find" <?> UrlParser.stringParam "txt")
        , UrlParser.map (FindModel Find.exec) (UrlParser.s "find")
        ]
