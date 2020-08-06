# WebSocket-Spring-Flutter
This example showcases how you can use a spring-boot backend with websockets to retrieve live upates of your database changes. You might find this similar to a SnapshotListener known from the Firebase SDK 🤓

# Usage

## Spring

Open the spring-project and start it. The database is already populated with some dummy data. After this you can access the website via localhost:8080

On the website you have to press "connect" in order to receive updates from the database. After this you can edit the name of a user in the database with the textfield and the "send" button.

## Flutter 

You can now start the flutter app and it will automatically connect to the backend via the class "StompSocket.dart".
As you change data on the website, the app will update all these changes in the ListView.
