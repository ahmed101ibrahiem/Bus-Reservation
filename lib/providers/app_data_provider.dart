
import 'package:bus_reservation_udemy/datasource/data_source.dart';
import 'package:bus_reservation_udemy/datasource/dummy_data_source.dart';
import 'package:bus_reservation_udemy/models/bus_schedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/but_route.dart';

class AppDataProvider extends ChangeNotifier{
  final DataSource _dataSource = DummyDataSource();
  List<BusSchedule> _scheduleList = [];
  List<BusSchedule> get scheduleList=>_scheduleList;
  Future<BusRoute?> getRouteByCityFromAndCityTo(
      {required String cityFrom,required String cityTo}) {
    return _dataSource.getRouteByCityFromAndCityTo(cityFrom, cityTo);
  }
  Future<List<BusSchedule>> getScheduleByRouteName({required String routeName})async{
   return _dataSource.getSchedulesByRouteName(routeName);
}
}