module Backend exposing (..)

import Html
import Lamdera exposing (ClientId, SessionId)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { currentQuestion = "", state = NoQuestion, currentUsers = [] }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        ClientJoin s ->
            let
                m =
                    { model | currentUsers = { name = s, id = clientId } :: model.currentUsers }

                sendHello =
                    Lamdera.sendToFrontend clientId (ServerState m)
            in
            ( m
            , Cmd.batch [ sendHello ]
            )

        StartVote q ->
            let
                m =
                    { model | currentQuestion = q }
            in
            ( m, Cmd.none )
