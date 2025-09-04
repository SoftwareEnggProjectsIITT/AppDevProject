import 'package:flutter/material.dart';
import 'package:frontend/services/manage_messages.dart';

class NewChat extends StatefulWidget {
  const NewChat({super.key});

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  final _titleController = TextEditingController();
  var _isSubmitting = false;
  void _submit() async {
    if (_titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please make sure a valid title was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ));
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    await createConversation(_titleController.text);
    setState(() {
      _isSubmitting = false;
    });
    Navigator.pop(context);
    
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, _) {
        return SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Column(
                children: [
                  const Text("Create New Chat", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: _titleController,
                    maxLength: 20,
                    decoration: InputDecoration(label: Text('Title')),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed:_isSubmitting ? null : () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed:_isSubmitting ? null :  _submit,
                        child:_isSubmitting ? const CircularProgressIndicator() :  const Text('Create Chat'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
