// class User {
//   final String email;
//   final String uid;
//   final String photoUrl;
//   final String username;
//   final String bio;
//   final List followers;
//   final List following;

//   const User(
//       {required this.username,
//       required this.uid,
//       required this.photoUrl,
//       required this.email,
//       required this.bio,
//       required this.followers,
//       required this.following});

//   static User fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;

//     return User(
//       username: snapshot["name"],
//       uid: snapshot["uID"],
//       email: snapshot["email"],
//       photoUrl: snapshot["imageProFile"],
//       bio: snapshot["status"],
//       followers: snapshot["followers"],
//       following: snapshot["following"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "username": username,
//         "uid": uid,
//         "email": email,
//         "photoUrl": photoUrl,
//         "bio": bio,
//         "followers": followers,
//         "following": following,
//       };
// }
