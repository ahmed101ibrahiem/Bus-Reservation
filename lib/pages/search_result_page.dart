import 'package:bus_reservation_udemy/models/bus_schedule.dart';
import 'package:bus_reservation_udemy/models/but_route.dart';
import 'package:bus_reservation_udemy/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_data_provider.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    BusRoute route = argList[0];
    final String departDate = argList[1];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Resul'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text('Showing result for ${route.cityFrom} to ${route.cityTo} on $departDate',
          style: const TextStyle(
            fontSize: 18.0
          ),),
          Consumer<AppDataProvider>(
            builder: (context, provider, _) {
              return FutureBuilder(future: provider.getScheduleByRouteName(routeName: route.routeName),
                  builder: (context, snapshot) {
                    final scheduleList = snapshot.data;
                    if(snapshot.hasData){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: scheduleList!
                            .map((schedule) => ScheduleItemView(schedule: schedule, date: departDate))
                            .toList(),
                      );
                    }
                    if(snapshot.hasError){
                      return const Text('error data');
                    }
                    return const CircularProgressIndicator();
                  },);
            },
          )
        ],
      ),
    );
  }
}

class ScheduleItemView extends StatelessWidget {
  final String date;
  final BusSchedule schedule;
  const ScheduleItemView({Key? key,required this.schedule,required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Navigator.pushNamed(context, routeNameSeatPlanPage,arguments: [schedule,date]);
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        color: Colors.grey.shade800,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  schedule.bus.busName,
                ),
                subtitle: Text(schedule.bus.busType),
                trailing: Text('$currency${schedule.bus.totalSeat}',style: const TextStyle(
                  fontSize: 16.0
                ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('From ${schedule.busRoute.cityFrom}'),
                    Text('To ${schedule.busRoute.cityFrom}')
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Departure Time: ${schedule.departureTime}'),
                  Text('Total Seat: ${schedule.bus.totalSeat}')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
