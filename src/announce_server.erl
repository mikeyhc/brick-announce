-module(announce_server).
-behaviour(gen_server).

%% public API
-export([start_link/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2]).

-define(BIND_ADDR, "172.17.0.2").
-define(REP_PORT, 5555).
-define(PEER_COUNT, 7).

-record(state, {socket :: pid() | undefined,
                peers=[] :: [string()]
               }).

%% public API

start_link() ->
    gen_server:start_link(?MODULE, [], []).

%% gen_server callbacks

init([]) ->
    % declare used atoms
    regsiter,
    deregister,
    gen_server:cast(self(), bind),
    {ok, #state{}}.

handle_call(_Msg, _From, State) ->
    {noreply, State}.

handle_cast(bind, State) ->
    {ok, Socket} = chumak:socket(rep, "announce-rep"),
    case chumak:bind(Socket, tcp, ?BIND_ADDR, ?REP_PORT) of
        {ok, _BindPid} ->
            logger:info("starting reply socket on pid ~p", [Socket]),
            SelfPid = self(),
            spawn_monitor(fun() -> recv_loop(Socket, SelfPid) end),
            {noreply, State#state{socket=Socket}};
        Err ->
            logger:error("failed to bind pubsub: ~p", [Err]),
            {stop, Err, State}
    end;
handle_cast({recv, Msg}, State=#state{socket=Socket, peers=Peers}) ->
    case erlang:binary_to_term(Msg, [safe]) of
        {register, Peer} ->
            OtherPeers = lists:filter(fun(X) -> X =/= Peer end, Peers),
            Reply = {peerlist, lists:sublist(OtherPeers, ?PEER_COUNT)},
            chumak:send(Socket, erlang:term_to_binary(Reply)),
            {noreply, State#state{peers=[Peer|OtherPeers]}}
    end.

%% helper methods

recv_loop(Socket, Pid) ->
    {ok, Reply} = chumak:recv(Socket),
    gen_server:cast(Pid, {recv, Reply}),
    recv_loop(Socket, Pid).
