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

addStation_test() ->
  ?assert(pollution:addStation("aleje", {50.2345, 18.3445}, pollution:createMonitor())
    == #monitor{stationProperties = #{"aleje" => {50.2345, 18.3445}},
      coordsToReadouts = #{{50.2345, 18.3445} => #{}}}).
addValue_test() ->
  ?assert(pollution:addValue({50.2345, 18.3445}, {{2019, 5, 5}, {17, 21, 8}}, "PM10", 59
    , #monitor{stationProperties = #{"aleje" => {50.2345, 18.3445}},
      coordsToReadouts = #{{50.2345, 18.3445} => #{}}})
    == #monitor{stationProperties = #{"aleje" => {50.2345, 18.3445}},
      coordsToReadouts = #{{50.2345, 18.3445} =>
      #{{{{2019, 5, 5}, {17, 21, 8}}, "PM10"} => 59}}}).

removeValue_test() ->
  ?assert(pollution:removeValue("aleje", {{2019, 5, 5}, {17, 21, 8}}, "PM10",
    #monitor{stationProperties = #{"aleje" => {50.2345, 18.3445}},
      coordsToReadouts = #{{50.2345, 18.3445} =>
      #{{{{2019, 5, 5}, {17, 21, 8}}, "PM10"} => 59}}})
    ==
    #monitor{stationProperties = #{"aleje" => {50.2345, 18.3445}},
      coordsToReadouts = #{{50.2345, 18.3445} => #{}}}).

getOneValue_test() ->
  ?assert(pollution:getOneValue({50.2345, 18.3445}, {{2019, 5, 5}, {17, 21, 8}}, "PM10",
    #monitor{stationProperties = #{"aleje" => {50.2345, 18.3445}},
      coordsToReadouts = #{{50.2345, 18.3445} =>
      #{{{{2019, 5, 5}, {17, 21, 8}}, "PM10"} => 59,
        {{{2019, 5, 6}, {17, 21, 8}}, "PM2,5"} => 65}}})
    == 59).

getDailyMean_test() ->
  ?assert(pollution:getDailyMean({2019, 5, 5}, "PM10",
    #monitor{stationProperties = #{"aleje" => {50.2345, 18.3445}},
      coordsToReadouts = #{{50.2345, 18.3445} =>
      #{{{{2019, 1, 6}, {17, 21, 8}}, "PM10"} => 61,
        {{{2019, 5, 5}, {17, 21, 8}}, "PM10"} => 59,
        {{{2019, 5, 5}, {19, 21, 8}}, "PM10"} => 55,
        {{{2019, 5, 6}, {17, 21, 8}}, "PM2,5"} => 65}}})
    == 57.0).

getMinMaxValue_test() ->
  ?assert(pollution:getMinMaxValue({50.2345, 18.3445}, {2019, 5, 5}, "PM10",
    #monitor{stationProperties = #{"aleje" => {50.2345, 18.3445}},
      coordsToReadouts = #{{50.2345, 18.3445} =>
      #{{{{2019, 1, 6}, {17, 21, 8}}, "PM10"} => 61,
        {{{2019, 5, 5}, {17, 21, 8}}, "PM10"} => 59,
        {{{2019, 5, 5}, {19, 21, 8}}, "PM10"} => 55,
        {{{2019, 5, 6}, {17, 21, 8}}, "PM2,5"} => 65}}})
    == {55, 59}).

getStationMean_test() ->
  ?assert(pollution:getStationMean("aleje", "PM10",
    #monitor{stationProperties = #{"aleje" => {50.2345, 18.3445}},
      coordsToReadouts = #{{50.2345, 18.3445} =>
      #{{{{2019, 1, 6}, {17, 21, 8}}, "PM10"} => 50,
        {{{2019, 5, 5}, {17, 21, 8}}, "PM10"} => 45,
        {{{2019, 5, 5}, {19, 21, 8}}, "PM10"} => 55,
        {{{2019, 5, 6}, {17, 21, 8}}, "PM2,5"} => 65}}})
    == 50.0).