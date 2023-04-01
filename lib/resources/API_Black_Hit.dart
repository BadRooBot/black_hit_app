import 'dart:convert';
import 'package:http/http.dart' as http;

const baseURL = 'http://localhost:5000'; // Replace with your API URL
// Function to create a chat list table and add a chat to the user's chat list
/*
Future<void> makeChatListTableAndAddIdToList(
    String userId, String toUser) async {
  final response = await http.post(
    Uri.parse('http://localhost:5000/make_chat_list_table_and_add_id_to_list'),
    body: json.encode({
      'user_id': userId,
      'to': toUser,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    print(response.body); // Print the response body
  } else {
    throw Exception('Failed to make chat list table and add id to list');
  }
}
*/
// Function to delete a chat from the user's chat list
Future<void> deleteList(String chatId) async {
  final response = await http.post(
    Uri.parse('$baseURL/delete-list'),
    body: json.encode({
      'chat_id': chatId,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    print(response.body); // Print the response body
  } else {
    throw Exception('Failed to delete chat list');
  }
}

////////////////////////////////////////////////////////

class API {
  static Future<dynamic> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseURL/login'),
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return false;
    }
  }

  static Future<dynamic> signup(
    String username,
    String password,
    String email,
    String imageUrl,
    String gender,
    int points,
  ) async {
    final response = await http.post(
      Uri.parse('$baseURL/signup'),
      body: json.encode({
        'username': username,
        'password': password,
        'email': email,
        'image_url': imageUrl,
        'gender': gender,
        'points': points,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    if (response.statusCode == 200) {
      print("done");
      return json.decode(response.body);
    } else {
      print("not done");
      return false;
    }
  }

  static Future<bool> addPost(
      {required String userId,
      required String postText,
      required String postImageUrl,
      required int likes,
      required int dislike,
      required List<Map<String, String>> comments}) async {
    final url = Uri.parse('$baseURL/add-post');
    final response = await http.post(
      url,
      body: json.encode({
        'user_id': userId,
        'post_text': postText,
        'post_image_url': postImageUrl,
        'likes': "$likes",
        'dislike': "$dislike",
        'comments': comments,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<dynamic>> getPosts() async {
    final response = await http.get(Uri.parse('$baseURL/get-posts'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> getOneUser(int userId) async {
    final response = await http.post(
      Uri.parse('$baseURL/get-one-user'),
      body: jsonEncode({'user_id': "$userId"}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body)[0];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  Future<List<dynamic>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$baseURL/get-All-user'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<String> updateUserUsername(userId, String newUsername) async {
    var url = Uri.parse('$baseURL/update-user-name');

    var response = await http.post(
      url,
      body: jsonEncode({
        'user_id': userId.toString(),
        'new_username': newUsername,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      return responseData.toString();
    } else {
      throw Exception('Failed to update user username.');
    }
  }

  Future<String> updateUserPassword(userId, String newUsername) async {
    var url = Uri.parse('$baseURL/update-user-password');

    var response = await http.post(
      url,
      body: jsonEncode({
        'user_id': userId.toString(),
        'new_password': newUsername,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      return responseData.toString();
    } else {
      throw Exception('Failed to update user username.');
    }
  }

  Future<String> updateUserEmail(userId, String newUsername) async {
    var url = Uri.parse('$baseURL/update-user-email');

    var response = await http.post(
      url,
      body: jsonEncode({
        'user_id': userId.toString(),
        'new_email': newUsername,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      return responseData.toString();
    } else {
      throw Exception('Failed to update user username.');
    }
  }

  Future<String> updateUserImageUrl(userId, String newUsername) async {
    var url = Uri.parse('$baseURL/update-user-image-url');

    var response = await http.post(
      url,
      body: jsonEncode({
        'user_id': userId.toString(),
        'new_image_url': newUsername,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      return responseData.toString();
    } else {
      throw Exception('Failed to update user username.');
    }
  }

  Future<String> updateUserGender(userId, String newUsername) async {
    var url = Uri.parse('$baseURL/update-user-gender');

    var response = await http.post(
      url,
      body: jsonEncode({
        'user_id': userId.toString(),
        'new_gender': newUsername,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      return responseData.toString();
    } else {
      throw Exception('Failed to update user username.');
    }
  }

  Future<String> updateUserPoints(userId, String newUsername) async {
    var url = Uri.parse('$baseURL/update-user-points');

    var response = await http.post(
      url,
      body: jsonEncode({
        'user_id': userId.toString(),
        'new_points': newUsername,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      return responseData.toString();
    } else {
      throw Exception('Failed to update user username.');
    }
  }

  Future<List<dynamic>> getMyPosts(String userId) async {
    final url = Uri.parse('$baseURL/get-my-posts');
    final response = await http.post(
      url,
      body: jsonEncode({'user_id': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> addComment(int postId, int commentId, userId, String commentText,
      String commentImage) async {
    final url = Uri.parse('$baseURL/add-comment');
    final response = await http.post(
      url,
      body: jsonEncode({
        'post_id': postId,
        'comment_id': commentId,
        'user_id': userId,
        'comment_text': commentText,
        'comment_image': commentImage,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }
  }

  static Future<String> for_test() async {
    final url = '$baseURL/for-test';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Data was successfully fetched
      final data = response.body;
      print(data);
      // Do something with the data
      return data;
    } else {
      // Something went wrong while fetching data
      print('Failed to fetch data: ${response.statusCode}');
      return 'Failed to fetch data: ${response.statusCode}';
    }
  }

  static Future<bool> deleteUser(int userId) async {
    final response = await http.post(
      Uri.parse('$baseURL/delete-user'),
      body: {'user_id': userId.toString()},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
///////////////////////////////////////////////////////////////3

class Message {
  String to;
  String from;
  String message;
  String imageUrl;
  String videoUrl;
  DateTime time;
  bool isSeen;
  int messageId;

  Message({
    required this.to,
    required this.from,
    required this.message,
    required this.imageUrl,
    required this.videoUrl,
    required this.time,
    required this.isSeen,
    required this.messageId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      to: json['to_user'],
      from: json['from_user'],
      message: json['message'],
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      time: DateTime.parse(json['time'] ?? "20120227T132700"),
      isSeen: json['is_seen'],
      messageId: json['message_id'],
    );
  }
}

Future<List<Message>> getMessages(String chatId, String to) async {
  final response = await http.post(
    Uri.parse('$baseURL/get-message'),
    body: jsonEncode({
      'chat_id': "$chatId",
      'to': '$to',
    }),
    headers: {'Content-Type': 'application/json'},
  );
  print(response.body);
  if (response.statusCode == 200) {
    List<dynamic> messagesJson = jsonDecode(response.body);
    List<Message> messages =
        messagesJson.map((json) => Message.fromJson(json)).toList();
    return messages;
  } else {
    throw Exception('Failed to load messages');
  }
}

Future<void> sendMessage(String userId, String to, String from, String message,
    String imageUrl, String videoUrl, DateTime time) async {
  final response = await http.post(
    Uri.parse('$baseURL/send-message'),
    body: jsonEncode({
      'user_id': userId,
      'to': to,
      'from': from,
      'message': message,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'time': time.toIso8601String(),
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Success
  } else {
    throw Exception('Failed to send message');
  }
}

Future<void> updateMessageIsSeen(
    String userId, bool isSeen, int messageId) async {
  final response = await http.post(
    Uri.parse('$baseURL/update_message_is_seen'),
    body: jsonEncode({
      'user_id': userId,
      'is_seen': isSeen,
      'messageID': messageId,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Success
  } else {
    throw Exception('Failed to update message isSeen');
  }
}

Future<void> deleteMessage(String chatId, int messageId) async {
  final response = await http.post(
    Uri.parse('$baseURL/delete-message '),
    body: jsonEncode({
      'chat_id': chatId,
      'messageID': messageId,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Success
  } else {
    throw Exception('Failed to delete message');
  }
}
