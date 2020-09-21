%%%-------------------------------------------------------------------
%% @doc brick_announce public API
%% @end
%%%-------------------------------------------------------------------

-module(brick_announce_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [{"/", status_handler, []},
               {"/register", register_handler, []},
               {"/deregister", deregister_handler, []},
               {"/history", history_handler, []},
               {"/brick", brick_handler, []}]}
     ]),
    {ok, _} = cowboy:start_clear(announce_listener,
                                 [{port, 8080}],
                                 #{env => #{dispatch => Dispatch}}),
    brick_announce_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
