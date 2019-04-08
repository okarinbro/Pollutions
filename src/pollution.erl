%%%-------------------------------------------------------------------
%%% @author Przemek
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. kwi 2019 15:04
%%%-------------------------------------------------------------------
-module(pollution).
-author("Przemek").
%% API
-export([createMonitor/0, addStation/3, addValue/5, removeValue/4, getOneValue/4,getStationMean/3, getDailyMean/3, getMinMaxValue/4]).
%%stationProperties is map from Name to Coordinates of station
-record(monitor, {stationProperties = #{}, coordsToReadouts = #{}}).

createMonitor() ->
  #monitor{stationProperties = #{}, coordsToReadouts = #{}}.

validateStation(Name, Monitor) ->
  V = maps:get(Name, Monitor#monitor.stationProperties, default),
  case V of
    default -> ok;
    _ -> error("Station with given name already exists!")
  end.
addStation(Name, Coords, Monitor) ->
  validateStation(Name, Monitor),
  #monitor{stationProperties = (Monitor#monitor.stationProperties)#{Name => Coords}, coordsToReadouts = (Monitor#monitor.stationProperties)#{Coords => #{}}}.

addValue(Key, Date, Type, Value, Monitor) when (is_float(Value) or is_integer(Value)) and is_record(Monitor, monitor) ->

  case is_tuple(Key) of
    true -> Readouts = maps:get(Key, Monitor#monitor.coordsToReadouts),
      Monitor#monitor{coordsToReadouts = (Monitor#monitor.coordsToReadouts)#{Key => Readouts#{{Date, Type} => Value}}};
    false -> Coords = maps:get(Key, Monitor#monitor.stationProperties),
      Readouts = maps:get(Coords, Monitor#monitor.coordsToReadouts),
      Monitor#monitor{coordsToReadouts = (Monitor#monitor.coordsToReadouts)#{Coords => Readouts#{{Date, Type} => Value}}}
  end.


removeValue(Key, Date, Type, Monitor) ->
  case is_tuple(Key) of
    true -> Readouts = maps:get(Key, Monitor#monitor.coordsToReadouts),
      Monitor#monitor{coordsToReadouts = (Monitor#monitor.coordsToReadouts)#{Key => maps:remove({Date, Type}, Readouts)}};
    false ->
      Coords = maps:get(Key, Monitor#monitor.stationProperties),
      Readouts = maps:get(Coords, Monitor#monitor.coordsToReadouts),
      Monitor#monitor{coordsToReadouts = (Monitor#monitor.coordsToReadouts)#{Coords => maps:remove({Date, Type}, Readouts)}}
  end.

getOneValue(Key, Date, Type, Monitor) ->
  case is_tuple(Key) of
    true -> V = maps:get({Date, Type}, maps:get(Key, Monitor#monitor.coordsToReadouts), default),
      case V of
        default -> not_found;
        _ -> V
      end;
    false -> Coords = maps:get(Key, Monitor#monitor.stationProperties),
      V = maps:get({Date, Type}, maps:get(Coords, Monitor#monitor.coordsToReadouts), default),
      case V of
        default -> not_found;
        _ -> V
      end
  end.

getStationMean(Key, Type, Monitor) ->
  case is_tuple(Key) of
    true ->
      Readouts = maps:get(Key, Monitor#monitor.coordsToReadouts),
      Fun = fun(MKey, MVal, {S,C}) -> {S + MVal, C + 1} end,
      Pred = fun({_, Mtype}, _) -> Mtype =:= Type end,
      {Sum, Count} = maps:fold(Fun, {0,0}, maps:filter(Pred,Readouts)),
      Sum/Count;
    false ->
      Readouts = maps:get(maps:get(Key,Monitor#monitor.stationProperties), Monitor#monitor.coordsToReadouts),
      Fun = fun(MKey, MVal, {S,C}) -> {S + MVal, C + 1} end,
      Pred = fun({_, Mtype}, _) -> Mtype =:= Type end,
      {Sum, Count} = maps:fold(Fun, {0,0}, maps:filter(Pred,Readouts)),
      Sum/Count
  end.

getDailyMean(Date, Type, Monitor) ->
  erlang:error(not_implemented).

getMinMaxValue(Coords,Date,Type, Monitor) ->
  erlang:error(not_implemented).