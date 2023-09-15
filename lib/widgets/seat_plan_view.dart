import 'package:bus_reservation_udemy/utils/colors.dart';
import 'package:bus_reservation_udemy/utils/constants.dart';
import 'package:flutter/material.dart';

class SeatPlanView extends StatelessWidget {
  final int totalSeat;
  final String bookedSeatNumber;
  final int totalSeatBooked;
  final bool isBusinessClass;
  final Function(bool,String) onSeatSelected;
  const SeatPlanView({Key? key,
  required this.totalSeat,
  required this.isBusinessClass,
  required this.bookedSeatNumber,
  required this.onSeatSelected,
  required this.totalSeatBooked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noOfRow = (isBusinessClass? totalSeat/3:totalSeat/4).toInt();
    final noOfColumn =isBusinessClass? 3: 4;
    List <List<String>> seatArrangement = [];
    for(int i =0;i<noOfRow;i++ ){
      List<String> columns =[];
      for(int j= 0; j<noOfColumn;j++){
        columns.add('${seatLabelList[i]}${j+1}');
      }
      seatArrangement.add(columns);
    }
    final List<String> bookedSeatList = bookedSeatNumber.isEmpty?[]:bookedSeatNumber.split(',');
    return  Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.sizeOf(context).width*0.90,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey,width: 2)
      ),
      child: Column(
        children: [
          const Text('FRONT',style: TextStyle(
            color: Colors.grey,
            fontSize: 30.0
          ),),
          const Divider(height: 2,color: Colors.black,),
          const SizedBox(height: 10.0,),
          Column(
            children: [
              for(int i=0;i<seatArrangement.length;i++)

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for(int j= 0;j<seatArrangement[i].length ;j++)
                    Row(
                      children: [
                        SeatWidget(label: seatArrangement[i][j],
                            isBooked: bookedSeatList.contains(seatArrangement[i][j]),
                            onSelect:(value){
                              onSeatSelected(value,seatArrangement[i][j]);
                            }),
                        if(isBusinessClass && j==0)const SizedBox(width: 24.0,),
                        if(!isBusinessClass && j==1)const SizedBox(width: 24.0,)

                      ],
                    )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class SeatWidget extends StatefulWidget {
  final String label;
  final bool isBooked;
  final Function(bool) onSelect;

  const SeatWidget({
    Key? key,
    required this.label,
    required this.isBooked,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<SeatWidget> createState() => _SeatWidgetState();
}

class _SeatWidgetState extends State<SeatWidget> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          selected = !selected;
        });
        widget.onSelect(selected);
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        height: 50.0,
        width: 50.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: widget.isBooked
                ? null
                : [
                    const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4, -4),
                        blurRadius: 5,
                        spreadRadius: 2),
                    BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(4, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
            color: widget.isBooked
                ? seatBookedColor
                : selected
                    ? seatSelectedColor
                    : seatAvailableColor),
        child: Text(
          widget.label,
          style: TextStyle(
              color: selected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16.0),
        ),
      ),
    );
  }
}
