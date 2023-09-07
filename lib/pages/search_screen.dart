import 'package:bus_reservation_udemy/providers/app_data_provider.dart';
import 'package:bus_reservation_udemy/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../datasource/temp_db.dart';
import '../utils/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? fromCity;
  String? toCity;
  DateTime? departureDate;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search'),),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            padding:const EdgeInsets.symmetric(horizontal: 16.0),
            shrinkWrap: true,
            children: [
              DropdownButtonFormField<String>(
                value: fromCity,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return emptyFieldErrMessage;
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
                  hintText: 'From'
                ),
                items: cities.map((city) =>
                  DropdownMenuItem<String>(
                    value: city,
                      child:  Text(city))).toList(),
                  onChanged: (value) {
                  setState(() {
                    fromCity = value;
                  });
                  },),
              const SizedBox(height: 24.0,),
              DropdownButtonFormField<String>(
                value: toCity,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return emptyFieldErrMessage;
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    errorStyle: TextStyle(color: Colors.white),
                    hintText: 'To'
                ),
                items: cities.map((city) =>
                    DropdownMenuItem<String>(
                        value: city,
                        child:  Text(city))).toList(),
                onChanged: (value) {
                  setState(() {
                    toCity = value;
                  });
                },),
              const SizedBox(height: 24.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: _selectDate,
                        child: const Text('Select Departure Date')),
                    Text(departureDate==null?'No date chosen':getFormattedDate(departureDate!, pattern: 'EEE MMM dd, yyyy')),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: 150.0,
                  child:
                  ElevatedButton(onPressed: _search
                      , child: const Text(
                    'SEARCH',
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate()async {
  final  selectDate =  await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 7))).then((value){
         setState(() {
           departureDate = value;
         });

    }).catchError((e){
      departureDate = 'Wrong Date' as DateTime?;
  });
  }

  void _search() {
    if(departureDate == null){
      showMsg(context: context, msg: emptyDateErrMessage);
       return;
    }
    if(_formKey.currentState!.validate()){
      Provider.of<AppDataProvider>(context,listen: false).
      getRouteByCityFromAndCityTo(cityFrom: fromCity!,cityTo: toCity!).then((route) {
        Navigator.pushNamed(context, routeNameSearchResultPage,
            arguments: [route,getFormattedDate(departureDate!)]);
      });

    }
  }
}
