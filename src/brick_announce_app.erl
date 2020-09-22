%%%-------------------------------------------------------------------
%% @doc brick_announce public API
%% @end
%%%-------------------------------------------------------------------

-module(brick_announce_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    brick_announce_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
