%%%-------------------------------------------------------------------
%%% @author Acer
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. maj 2019 14:11
%%%-------------------------------------------------------------------
-module(pollution_gen_server).
-author("Acer").
-behavior(gen_server).
%% API
-export([init/1, handle_call/3, handle_cast/2]).


init(Args) ->
  erlang:error(not_implemented).

handle_call(Request, From, State) ->
  erlang:error(not_implemented).

handle_cast(Request, State) ->
  erlang:error(not_implemented).