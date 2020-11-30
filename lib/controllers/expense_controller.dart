import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fleming_expense_tracker/model/expense_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class ExpenseController extends GetxController {
  RxString name = "".obs;
  RxDouble amount = 0.0.obs;
  RxString notes = "".obs;
  Rx<DateTime> date = DateTime.now().obs;
  RxBool isBusinessExpense = true.obs;
  RxString mileageFrom = "".obs;
  RxString mileageTo = "".obs;
  RxDouble mileageDistance = 0.0.obs;
  RxBool isExpenseUploading = false.obs;
  Rx<ExpenseType> expenseType = ExpenseType.business.obs;
  Rx<BusinessType> businessExpenseType = BusinessType.accomodation.obs;

  final StorageReference storageReference = FirebaseStorage.instance.ref();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Bill uploading
  RxBool isUploading = false.obs;
  RxBool cameraUpload = true.obs;
  final picker = ImagePicker();
  Rx<File> file = Rx<File>();

  RxString imageDownloadUrl = "".obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController mileageFromController = TextEditingController();
  TextEditingController mileageToController = TextEditingController();
  TextEditingController mileagedistanceController = TextEditingController();

  setName(val) => name.value = nameController.text;
  setDate(val) => date.value = val;

  setPersonalExpenseType() {
    isBusinessExpense.value = false;
    expenseType.value = ExpenseType.personel;
  }

  setBusinessExpenseType() {
    isBusinessExpense.value = true;
    expenseType.value = ExpenseType.business;
  }

  setBusinessType(val) {
    businessExpenseType.value = val;
  }

  setIsExpenseUploading(val) => isExpenseUploading.value = val;
  setMileageFrom(val) => mileageFrom.value = val;
  setMileageTo(val) => mileageTo.value = val;
  setMileageDistance(val) => mileageDistance.value = val;

  // Upload Bills
  setIsCamera(val) => cameraUpload.value = val;
  setIsLoading(val) => isUploading.value = val;
  setFile(val) => file.value = val;
  setImageDownloadUrl(val) => imageDownloadUrl.value = val;

  submitExpense(String tripId) async {
    setIsExpenseUploading(true);
    print(expenseType.value);

    ExpenseModel newExpense = ExpenseModel(
      tripId: tripId,
      date: date.value,
      name: nameController.text,
      expenseAmount: double.parse(amountController.text),
      expenseType: expenseType.value.toString(),
      businessType:
          isBusinessExpense.value ? businessExpenseType.value.toString() : null,
      mileageFrom: businessExpenseType.value == BusinessType.mileage
          ? mileageFromController.text
          : "",
      mileageTo: businessExpenseType.value == BusinessType.mileage
          ? mileageToController.text
          : "",
      mileageDistance: businessExpenseType.value == BusinessType.mileage
          ? double.parse(mileagedistanceController.text)
          : null,
      notes: notesController.text,
      billUrl: imageDownloadUrl.value != "" ? imageDownloadUrl.value : "",
    );

    var expenseId = await _db
        .collection("trip")
        .doc(tripId)
        .collection("expense")
        .add(newExpense.toJson());

    print(expenseId);
  }

  void handleTakePhoto() async {
    PickedFile tempFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxHeight: 675,
      maxWidth: 960,
    );
    print(tempFile.path);
    if (tempFile != null) {
      setFile(File(tempFile.path));
      uploadImage(file.value);
      print(imageDownloadUrl.value);
    } else {
      print("No Image Selected");
    }
  }

  void handleGalleryPhoto() async {
    PickedFile tempFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (tempFile != null) {
      setFile(File(tempFile.path));
      uploadImage(file.value);
    } else {
      print("No Image Selected");
    }
  }

  void clearImage() {
    setFile(null);
  }

  void compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.value.readAsBytesSync());
    final compressedImageFile = File('$path/test1.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setFile(compressedImageFile);
  }

  uploadImage(imageFile) async {
    setIsLoading(true);
    StorageUploadTask uploadTask =
        storageReference.child("bill_123").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    setImageDownloadUrl(downloadUrl);
    setIsLoading(false);
  }
}
