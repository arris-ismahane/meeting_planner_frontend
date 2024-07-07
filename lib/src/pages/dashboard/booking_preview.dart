import 'package:flutter/material.dart';
import 'package:meeting_planner/src/model/classes/booking.dart';
import 'package:meeting_planner/src/settings/basic_state.dart';
import 'package:meeting_planner/src/settings/lang.dart';

class BookingPreview extends StatelessWidget {
  final Booking booking;
  const BookingPreview({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    var lang = getLang(context);
    return SizedBox(
      height: 400,
      width: 600,
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  booking.name.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "${lang.type} : ${lang.meetingTypeName(booking.type.type)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text(
                "${lang.nbParticipants} : ${booking.nbParticipants} / ${booking.room.capacity}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (booking.bookedEquipements.isNotEmpty)
              ListTile(
                title: Text(
                  "${lang.equipments} :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (booking.bookedEquipements.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...booking.bookedEquipements
                        .map((e) => Text(" - " + e.equipment.name))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
