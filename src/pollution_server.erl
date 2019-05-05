%%%-------------------------------------------------------------------
%%% @author Acer
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. maj 2019 13:25
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("Acer").

%% API
-export([start/0, stop/0]).




start() ->
  ServerPID = spawn(fun() -> init() end),
  register(server, ServerPID),
  ServerPID.

stop() ->
  server ! terminate.

init() ->
  loop(pollution:createMonitor()).

loop(MonitorState) ->
  receive
    terminate -> ok;
    {request, PID, {addStation, Name, Coords}} -> NextState = pollution:addStation(Name, Coords, MonitorState),
      PID ! {reply, added},
      loop(NextState);
    {request, PID, {addValue, Key, Date, Type, Value}} ->
      NextState = pollution:addValue(Key, Date, Type, Value, MonitorState),
      PID ! {reply, value_added},
      loop(NextState);
    {request, PID, {removeValue, Key, Date, Type}} ->
      NextState = pollution:removeValue(Key, Date, Type, MonitorState),
      PID ! {reply, removed},
      loop(NextState)
  end.
