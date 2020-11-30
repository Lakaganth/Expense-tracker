import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleming_expense_tracker/controllers/auth_controller.dart';
import 'package:fleming_expense_tracker/model/trip_model.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // RxList<TripModel> adminTrips = [].obs;
  Rx<List<TripModel>> userTrips = Rx<List<TripModel>>();
  Rx<List<TripModel>> adminUserTrips = Rx<List<TripModel>>();

  RxString currentTripId = "".obs;
  Rx<TripModel> currentTrip = Rx<TripModel>();

  List<TripModel> get trips => userTrips.value;
  List<TripModel> get adminTrips => adminUserTrips.value;

  setcurrentTripId(val) {
    currentTripId.value = val;
    // print(currentTripId.value);
  }

  setcurrentTrip(val) => currentTrip.value = val;

  @override
  void onInit() {
    String uid = Get.find<AuthController>().firestoreUser.value.uid;
    getUserAllTrips(uid);
    getAdminAllTrips(uid);
  }

  void getUserAllTrips(String uid) {
    userTrips.bindStream(userTripsStream(uid));
  }

  Stream<List<TripModel>> userTripsStream(String uid) {
    return _db
        .collection("trip")
        .where("teamMembers", arrayContains: uid)
        .snapshots()
        .map((QuerySnapshot trip) {
      List<TripModel> userTripFromJson = List();
      trip.docs.forEach((element) {
        userTripFromJson.add(TripModel.fromMap(element.id, element));
      });
      return userTripFromJson;
    });
  }

  void getAdminAllTrips(String uid) {
    adminUserTrips.bindStream(adminTripsStream(uid));
  }

  Stream<List<TripModel>> adminTripsStream(String uid) {
    return _db
        .collection("trip")
        .where("tripAdminId", isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot trip) {
      List<TripModel> userTripFromJson = List();
      trip.docs.forEach((element) {
        userTripFromJson.add(TripModel.fromMap(element.id, element));
      });
      return userTripFromJson;
    });
  }
}
