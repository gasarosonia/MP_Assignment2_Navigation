import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(const ContactsApp());
}

class ContactsApp extends StatefulWidget {
  const ContactsApp({Key? key}) : super(key: key);

  @override
  _ContactsAppState createState() => _ContactsAppState();
}

class _ContactsAppState extends State<ContactsApp> {
  Iterable<Contact>? _contacts;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (!kIsWeb) {
      if (await Permission.contacts.request().isGranted) {
        final Iterable<Contact> contacts = await ContactsService.getContacts();
        setState(() {
          _contacts = contacts;
        });
      } else {
        // Handle permissions denied
      }
    } else {
      // Handle web platform
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
        ),
        body: _contacts != null
            ? ListView.builder(
                itemCount: _contacts!.length,
                itemBuilder: (context, index) {
                  final Contact contact = _contacts!.elementAt(index);
                  return ListTile(
                    leading:
                        (contact.avatar != null && contact.avatar!.isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar!),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                    title: Text(contact.displayName ?? ''),
                    subtitle: Text(contact.phones?.isNotEmpty == true
                        ? contact.phones!.first.value ?? 'No phone number'
                        : 'No phone number'),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
