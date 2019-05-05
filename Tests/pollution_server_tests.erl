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

pollutions_server_test() ->
  % creating new stations
  pollution_server:start(),
  pollution_server:addStation("aleje", {53.142, 49.123}),
  pollution_server:addStation("muzeum", {53.1, 49.91}),
  %% adding new readouts
  pollution_server:addValue("muzeum", {{2019, 5, 5}, {18, 21, 8}}, "PM10", 48),
  pollution_server:addValue("muzeum", {{2019, 5, 5}, {19, 21, 8}}, "PM2,5", 12),
  pollution_server:addValue("muzeum", {{2019, 5, 5}, {11, 21, 8}}, "PM2,5", 11),
  pollution_server:addValue("muzeum", {{2019, 5, 5}, {12, 12, 8}}, "PM2,5", 5),
  pollution_server:addValue("muzeum", {{2019, 5, 5}, {18, 15, 8}}, "PM10", 58),
  pollution_server:addValue("muzeum", {{2019, 5, 6}, {10, 23, 18}}, "PM10", 63),
  pollution_server:addValue("muzeum", {{2019, 5, 6}, {18, 21, 8}}, "PM10", 90),
  pollution_server:addValue("aleje", {{2019, 5, 6}, {10, 23, 18}}, "PM10", 43),
  pollution_server:addValue("aleje", {{2019, 5, 6}, {18, 21, 8}}, "PM10", 45),
  %% removing values
  pollution_server:removeValue("aleje", {{2019, 5, 6}, {10, 23, 18}}, "PM10"),
  pollution_server:removeValue("muzeum", {{2019, 5, 5}, {11, 21, 8}}, "PM2,5"),
  % checking outputs:
  timer:sleep(1),
%%  ?assert(pollution_server:getMinMaxValue("muzeum", {2019, 5, 5}, "PM10") == {48, 58}),
%%  ?assert(pollution_server:getStationMean({53.1, 49.91}, "2,5") == 8.5),
%%  ?assert(pollution_server:getOneValue("aleje", {{2019, 5, 6}, {10, 23, 18}}, "PM10") == 43),
%%  ?assert(pollution_server:getDailyMean({2019, 5, 6}, "PM10") == 59.333333333333336),
  timer:sleep(1),
  pollution_server:stop().

