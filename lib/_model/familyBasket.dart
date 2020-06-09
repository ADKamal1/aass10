import 'package:firebase_database/firebase_database.dart';

class familyBasket {

  /////// ---  ahmed change iin this class
  String about;
  String aboutArabic;
  String facebook;
  String twitter;
  String whatsApp;
  String telephone;
  String address;
  String arabicAddress;
  String Policy;

  //
  String arabicPolicy;
  String id;

  familyBasket(this.about, this.aboutArabic, this.facebook, this.twitter,
      this.whatsApp,this.telephone, this.address, this.arabicAddress , this.Policy,this.arabicPolicy);


  familyBasket.fromMap(Map<dynamic , dynamic> value , String key)
      : this.about = value["about"],
        this.aboutArabic = value["aboutArabic"],
        this.Policy = value["policy"],
        this.telephone = value["telephone"],
        this.facebook = value["facebook"],
        this.twitter = value["twitter"],
        this.address = value["address"],
        this.arabicAddress = value["arabicAddress"],
        this.arabicPolicy  = value["arabicPolicy"],
        this.whatsApp = value["whatsApp"];
  Map toJson() => {
        'about': about,
        'aboutArabic': aboutArabic,
        'facebook': facebook,
        'twitter': twitter,
        'whatsApp': whatsApp,
        'address': address,
        'arabicAddress': arabicAddress,
        'policy':Policy,
        'arabicPolicy':arabicPolicy,
        'id':id,
        'telephone':telephone
      };

  familyBasket.fromSnapshot(DataSnapshot snap)
      : this.about = snap.value["about"],
        this.aboutArabic = snap.value["aboutArabic"],
        this.Policy = snap.value["policy"],
        this.telephone = snap.value["telephone"],
        this.facebook = snap.value["facebook"],
        this.twitter = snap.value["twitter"],
        this.address = snap.value["address"],
        this.arabicAddress = snap.value["arabicAddress"],
        this.whatsApp = snap.value["whatsApp"],
        this.id=snap.value["id"],
        this.arabicPolicy=snap.value["arabicPolicy"];

  Map toMap() {
    return {
      'about': about,
      'aboutArabic': aboutArabic,
      'facebook': facebook,
      'twitter': twitter,
      'whatsApp': whatsApp,
      'address': address,
      'arabicAddress': arabicAddress,
      'policy':Policy,
      'arabicPolicy':arabicPolicy,
      'id':id,
      'telephone':telephone


    };
  }
}
