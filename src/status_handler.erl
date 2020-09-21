-module(status_handler).

-export([init/2]).

init(Req0, State) ->
    Headers = #{<<"content-type">> => <<"application/json">>},
    Body = jsone:encode(#{<<"status">> => <<"ok">>,
                          <<"version">> => <<"0.1.0">>
                         }),
    Req = cowboy_req:reply(200, Headers, Body, Req0),
    {ok, Req, State}.
