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
-export([createMonitor/0, addStation/3, addValue/5, removeValue/4, getOneValue/4, getStationMean/3, getDailyMean/3, getMinMaxValue/4]).
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
  #monitor{stationProperties = (Monitor#monitor.stationProperties)#{Name => Coords}, coordsToReadouts = (Monitor#monitor.coordsToReadouts)#{Coords => #{}}}.

checkIfExistsN(Name, Monitor) ->
  V = maps:get(Name, Monitor#monitor.stationProperties, default),
  case V of
    default -> error("station does not exist");
    _ -> ok
  end.

checkIfExistsC(Coords, Monitor) ->
  V = maps:get(Coords, Monitor#monitor.coordsToReadouts, default),
  case V of
    default -> error("station does not exist");
    _ -> ok
  end.

addValue(Key, Date, Type, Value, Monitor) when (is_float(Value) or is_integer(Value)) and is_record(Monitor, monitor) ->
  case is_tuple(Key) of
    true ->
      checkIfExistsC(Key, Monitor),
      Readouts = maps:get(Key, Monitor#monitor.coordsToReadouts),
      Val = maps:get({{Date, Type}}, Readouts, val),
      case Val of
        val ->      Monitor#monitor{coordsToReadouts = (Monitor#monitor.coordsToReadouts)#{Key => Readouts#{{Date, Type} => Value}}};
        _ -> error("this readout already exists")
      end;
    false ->
      checkIfExistsN(Key, Monitor),
      Coords = maps:get(Key, Monitor#monitor.stationProperties),
      Readouts = maps:get(Coords, Monitor#monitor.coordsToReadouts),
      Val = maps:get({{Date, Type}}, Readouts, val),
      case Val of
        val ->      Monitor#monitor{coordsToReadouts = (Monitor#monitor.coordsToReadouts)#{Coords => Readouts#{{Date, Type} => Value}}};
        _ -> error("this readout already exists")
      end
  end.


removeValue(Key, Date, Type, Monitor) ->
  case is_tuple(Key) of
    true ->
      checkIfExistsC(Key, Monitor),
      Readouts = maps:get(Key, Monitor#monitor.coordsToReadouts),
      Monitor#monitor{coordsToReadouts = (Monitor#monitor.coordsToReadouts)#{Key => maps:remove({Date, Type}, Readouts)}};
    false ->
      checkIfExistsN(Key, Monitor),
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
      Fun = fun(_, MVal, {S, C}) -> {S + MVal, C + 1} end,
      Pred = fun({_, Mtype}, _) -> Mtype =:= Type end,
      {Sum, Count} = maps:fold(Fun, {0, 0}, maps:filter(Pred, Readouts)),
      Sum / Count;
    false ->
      Readouts = maps:get(maps:get(Key, Monitor#monitor.stationProperties), Monitor#monitor.coordsToReadouts),
      Fun = fun(_, MVal, {S, C}) -> {S + MVal, C + 1} end,
      Pred = fun({_, Mtype}, _) -> Mtype =:= Type end,
      {Sum, Count} = maps:fold(Fun, {0, 0}, maps:filter(Pred, Readouts)),
      Sum / Count
  end.

getMean([], Sum, N) -> {Sum, N};
getMean([H | T], Sum, N) -> getMean(T, Sum + H, N + 1).

getDailyMean(Day, Type, Monitor) ->
  AllReadouts = maps:values(Monitor#monitor.coordsToReadouts),
  Predicate = fun({{Mday, _}, Mtype}, _) ->
    (Day =:= Mday) and (Mtype =:= Type) end,
  ProperValues = lists:map(fun(Map) -> maps:values(maps:filter(Predicate, Map)) end, AllReadouts),
  Flat = lists:flatten(ProperValues),
  {Sum, Count} = getMean(Flat, 0, 0),
  Sum / Count.

getMinMaxValue(Coords, Day, Type, Monitor) ->
  AllReadouts = maps:get(Coords, Monitor#monitor.coordsToReadouts),
  Predicate = fun({{Mday, _}, Mtype}, _) ->
    (Day =:= Mday) and (Mtype =:= Type) end,
  ProperValues = maps:values(maps:filter(Predicate, AllReadouts)),
  Min = getMin(ProperValues, 5000),
  Max = getMax(ProperValues, 0),
  {Min, Max}.

getMax([], N) -> N;
getMax([H | T], N) ->
  case N < H of
    true -> getMax(T, H);
    _ -> getMax(T, N)
  end.


getMin([], N) -> N;
getMin([H | T], N) ->
  case N > H of
    true -> getMin(T, H);
    _ -> getMin(T, N)
  end.

