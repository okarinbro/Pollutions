%%%-------------------------------------------------------------------
%%% @author Acer
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. maj 2019 18:02
%%%-------------------------------------------------------------------
-module(pollution_server_tests).
-include_lib("eunit/include/eunit.hrl").
-author("Acer").

%% API
-export([]).
-record(monitor, {stationProperties = #{}, coordsToReadouts = #{}}).

