%%%-------------------------------------------------------------------
%% @doc brick_announce public API
%% @end
%%%-------------------------------------------------------------------

-module(brick_announce_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Interface = getenv_raise("ANNOUNCE_INTERFACE"),
    brick_announce_sup:start_link(Interface).

stop(_State) ->
    ok.

%% internal functions

getenv_raise(Key) ->
    case os:getenv(Key) of
        false -> throw({missing_envvar, Key});
        V -> V
    end.
