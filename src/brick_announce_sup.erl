%%%-------------------------------------------------------------------
%% @doc brick_announce top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(brick_announce_sup).

-behaviour(supervisor).

-export([start_link/1]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link(Interface) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [Interface]).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([Interface]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    ChildSpecs = [#{id => announce_server,
                    start => {announce_server, start_link, [Interface]}}
                 ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
