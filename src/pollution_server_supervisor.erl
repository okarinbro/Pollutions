%%%-------------------------------------------------------------------
%%% @author Acer
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. maj 2019 13:30
%%%-------------------------------------------------------------------
-module(pollution_server_supervisor).
-author("Acer").

%% API
-export([start_link/0]).


start_link() ->
  spawn(fun init_super/0).

init_super() ->
  process_flag(trap_exit, true),
  register(server, spawn_link(pollution_server,init, [])),
  loop().

loop() ->
  receive
    {'EXIT', _, _} ->   register(server, spawn_link(pollution_server,init, [])),
      loop()
  end.




