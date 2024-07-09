import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

List<DocumentSnapshot> _medications = [];
String? _currentUserEmail;

Future<void> _fetchData() async {
  // Retrieve the current user's email
  _currentUserEmail = FirebaseAuth.instance.currentUser?.email;

  if (_currentUserEmail != null) {
    try {
      // Get a reference to the MedsForUser subcollection for the current user
      final medsCollectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUserEmail)
          .collection('MedsForUser');

      // Query the subcollection, order by a specific field (e.g., 'name')
      final querySnapshot = await medsCollectionRef.orderBy('name').get();

      // Update state with the retrieved medications
      _medications = querySnapshot.docs;

    } on FirebaseException catch (e) {
      // Handle errors (e.g., display an error message)
      if (kDebugMode) {
        print("Error fetching medications: ${e.message}");
      }
    }
  } else {
    // Handle no logged-in user
  }
}

Future<void> _updateCurrentQuantities() async {
  if (_currentUserEmail != null) {
    try {
      for (final medication in _medications) {
        final today = DateTime.now();
        var lastUpdatedDateTimestamp = medication['lastUpdatedDate'] as Timestamp;
        var lastUpdatedDate = lastUpdatedDateTimestamp.toDate();
        bool isTodaySameDay;

        if (lastUpdatedDateTimestamp.toDate().year == today.year &&
            lastUpdatedDateTimestamp.toDate().month == today.month &&
            lastUpdatedDateTimestamp.toDate().day == today.day) {
              // It's the same date
              isTodaySameDay = true;
           } else {
              // It's a different date
              isTodaySameDay = false;
           }
        
        if (!isTodaySameDay) {
          // Access the currentQuantity and takeQuantityPerDay from the medication document
          final currentQuantity = medication['currentQuantity'] as int;
          final takeQuantityPerDay = medication['takeQuantityPerDay'] as int;
          final takeMonday = medication['takeMonday'] as bool;
          final takeTuesday = medication['takeTuesday'] as bool;
          final takeWednesday = medication['takeWednesday'] as bool;
          final takeThursday = medication['takeThursday'] as bool;
          final takeFriday = medication['takeFriday'] as bool;
          final takeSaturday = medication['takeSaturday'] as bool;
          final takeSunday = medication['takeSunday'] as bool;
          final totalDoses = medication['totalDoses'] as int;

          bool isTodayMonday() { return today.weekday == DateTime.monday;}
          bool isTodayTuesday() { return today.weekday == DateTime.tuesday;}
          bool isTodayWednesday() { return today.weekday == DateTime.wednesday;}
          bool isTodayThursday() { return today.weekday == DateTime.thursday;}
          bool isTodayFriday() { return today.weekday == DateTime.friday;}
          bool isTodaySaturday() { return today.weekday == DateTime.saturday;}
          bool isTodaySunday() { return today.weekday == DateTime.sunday;}

          updateQuantity() {
            // Calculate the new quantity
            final newQuantity = currentQuantity - takeQuantityPerDay;
            // Ensure new quantity is not negative
            final updatedQuantity = newQuantity > 0 ? newQuantity : 0;

            // Calculate the estimated last days ignoring non-take days
            final totalDoses = updatedQuantity ~/ takeQuantityPerDay;
            // Ensure lastDays is not negative
            final updatedTotalDoses = totalDoses > 0 ? totalDoses : 0;
            // update date to be today
            lastUpdatedDate = today;

            // Return a Map containing the updated values
            return {'currentQuantity': updatedQuantity, 'totalDoses': updatedTotalDoses, 'lastUpdatedDate': lastUpdatedDate};
          }
          
          Map<String, dynamic>? updatedValues;

          if (takeMonday && isTodayMonday()) {
            updatedValues = updateQuantity();
          } else if (takeTuesday && isTodayTuesday()) {
            updatedValues = updateQuantity();
          } else if (takeWednesday && isTodayWednesday()) {
            updatedValues = updateQuantity();
          } else if (takeThursday && isTodayThursday()) {
            updatedValues = updateQuantity();
          } else if (takeFriday && isTodayFriday()) {
            updatedValues = updateQuantity();
          } else if (takeSaturday && isTodaySaturday()) {
            updatedValues = updateQuantity();
          } else if (takeSunday && isTodaySunday()) {
            updatedValues = updateQuantity();
          }      

          // Update the field in the database
          if (updatedValues != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_currentUserEmail)
                .collection('MedsForUser')
                .doc(medication.id)
                .update(updatedValues);
            
            // send notification
            if (totalDoses-1 <= 14) {
              AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: medication.id.hashCode,
                  channelKey: 'med_updates',
                  title: '${medication['name']} fogyóban van!',
                  body: 'Már csak ${totalDoses-1} napnyi van.'
                )
              );
            }
          }

        }

      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Error updating quantities: ${e.message}");
      }
    }
  } else {
    // Handle no logged-in user
  }
}

Future<void> calculateMedQuantities() async {
  await _fetchData();
  await _updateCurrentQuantities();
}