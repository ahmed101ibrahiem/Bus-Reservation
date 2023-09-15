import 'package:bus_reservation_udemy/models/bus_schedule.dart';
import 'package:bus_reservation_udemy/utils/colors.dart';
import 'package:bus_reservation_udemy/utils/constants.dart';
import 'package:flutter/material.dart';
import '../widgets/seat_plan_view.dart';

class SeatPlanPage extends StatefulWidget {
  const SeatPlanPage({Key? key}) : super(key: key);

  @override
  State<SeatPlanPage> createState() => _SeatPlanPageState();
}

class _SeatPlanPageState extends State<SeatPlanPage> {
  late BusSchedule schedule;
  late String departDate;
  int totalSeatBooked = 0;
  String bookSeatNumber = '';
  List<String> selectSeats = [];
  bool isFirst = true;
  bool isDataLoading = true;
  ValueNotifier<String> selectedSeatStringNotifier = ValueNotifier('');

  @override
  void didChangeDependencies() {
    final route = ModalRoute.of(context)!.settings.arguments as List;
    schedule = route[0];
    departDate = route[1];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seat Plan'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 20.0,
                        width: 20.0,
                        color: seatBookedColor,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      const Text(
                        'Booked',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                 const SizedBox(width: 20.0,),
                  Row(
                    children: [
                      Container(
                        height: 20.0,
                        width: 20.0,
                        color: seatAvailableColor,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      const Text(
                        'Available',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: selectedSeatStringNotifier,
              builder: (context, value, _) {
                return Text(
                  'Selected: $value',
                  style: const TextStyle(fontSize: 16.00),
                );
              },
            ),
            Expanded(child: SingleChildScrollView(child: SeatPlanView(
               onSeatSelected: (value,seat){
                 if(value){
                   selectSeats.add(seat);
                 }else{
                   selectSeats.remove(seat);
                 }
                 selectedSeatStringNotifier.value= selectSeats.join(',');
               },
              totalSeatBooked: totalSeatBooked,
              totalSeat: schedule.bus.totalSeat,
              bookedSeatNumber: bookSeatNumber,
              isBusinessClass: schedule.bus.busType==busTypeACBusiness,

            ),)),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
