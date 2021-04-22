// class User {
//   String uid;
//   String name;
//   String email;
//   String emailStatus;
//   String phoneNo;
//   String gender;
//   String address;
//   String photoURL = "";
//   String phoneNumberStatus = "Not Verified";
//   double ratingAsSeller = 0;
//   double ratingAsBuyer = 0;
//   int reviewsAsSeller = 0;
//   int reviewsAsBuyer = 0;
//   int completetionRate = 0;
//   int completedTask = 0;
//   String about = "";
//   String education = "";
//   String specialities = "";
//   String work = "";
//   String cnic = "Not Verified";
//   String paymentStatus = "Not Verified";
  

//   User({
//     this.uid,
//     this.name,
//     this.email,
//     this.emailStatus,
//     this.phoneNo,
//     this.gender,
//     this.address,
//     this.photoURL,
//     this.phoneNumberStatus,
//     this.ratingAsSeller,
//     this.ratingAsBuyer,
//     this.reviewsAsSeller,
//     this.reviewsAsBuyer,
//     this.completetionRate,
//     this.completedTask,
//     this.about,
//     this.education,
//     this.specialities,
//     this.work,
//     this.cnic,
//     this.paymentStatus,
//   });

//   Map toMap(User user) {
//     var data = Map<String, dynamic>();
//     data['Uid'] = user.uid;
//     data['Name'] = user.name;
//     data['Email'] = user.email;
//     data['Gender'] = user.uid;
//     data['Phone Number'] = user.name;
//     data['Address'] = user.email;
//     data["PhotoURL"] = user.photoURL;
//     data['Phone Number status'] = user.uid;
//     data['Rating as Seller'] = user.name;
//     data['Rating as Buyer'] = user.email;
//     data['Reviews as Buyer'] = user.uid;
//     data['Reviews as Seller'] = user.name;
//     data['Completion Rate'] = user.email;
//     data['Completed Task'] = user.uid;
//     data['About'] = user.name;
//     data['Education'] = user.email;
//     data['Specialities'] = user.uid;
//     data['Languages'] = user.name;
//     data['Work'] = user.email;
//     data['CNIC'] = user.uid;
//     data['Payment Status'] = user.name;
//     return data;
//   }

//   User.fromMap(Map<String, dynamic> mapData) {
//     this.uid = mapData['uid'];
//     this.name = mapData['name'];
//     this.email = mapData['email'];
//     this.photoURL = mapData['profile_photo'];
//   }
// }
