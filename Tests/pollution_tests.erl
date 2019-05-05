%%%-------------------------------------------------------------------
%%% @author Acer
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. maj 2019 17:03
%%%-------------------------------------------------------------------
-module(pollution_tests).
-include_lib("eunit/include/eunit.hrl").
-author("Przemek").

%% API
-export([]).
-record(monitor, {stationProperties = #{}, coordsToReadouts = #{}}).

createMonitor_test() ->
  ?assert(pollution:createMonitor() == #monitor{stationProperties = #{}, coordsToReadouts = #{}}).