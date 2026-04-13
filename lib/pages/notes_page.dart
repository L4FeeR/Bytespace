import 'package:bytespace/custom_widgets/notes_widgets.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bytespace/auth/auth_class.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //color
  final List<Color> tileColors = [
    Colors.teal,
    Colors.purple,
    Colors.orange,
    Colors.blue,
    Colors.pink,
    Colors.green,
    Colors.indigo,
    Colors.amber,
    Colors.red,
  ];
  //access supabase client
  final supabase = Supabase.instance.client;

  //Methods For Notes Page
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> fetchNotes() async {
    final user = supabase.auth.currentUser;
    final data = await supabase
        .from('notes')
        .select()
        .eq('user_id', user!.id)
        .order('created_at', ascending: false);
    setState(() {
      notes = data;
    });
  }

  Future<void> createNote() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final data = await supabase.from('notes').insert({
      'user_id': user!.id,
      'content': 'New Note',
      'title': 'New Note',
    });
    fetchNotes();
  }

  Future<void> deleteNote() async {
    await supabase.from('notes').delete().eq('id', notes[0]['id']);
    fetchNotes();
  }

  void openEditor(Map note) {
    final titleController = TextEditingController(text: note['title']);
    final contentController = TextEditingController(text: note['content']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: TextField(
          controller: titleController,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            hintText: 'Title',
            border: InputBorder.none,
          ),
        ),
        content: TextField(
          controller: contentController,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: 'Write something...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await supabase.from('notes').delete().eq('id', note['id']);
              Navigator.pop(ctx);
              fetchNotes();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              await supabase
                  .from('notes')
                  .update({
                    'title': titleController.text,
                    'content': contentController.text,
                  })
                  .eq('id', note['id']);
              Navigator.pop(ctx);
              fetchNotes();
            },
            child: const Text('Save', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  List notes = [];
  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Byte Notes"),
        actions: [
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => openEditor(notes[index]),
            child: Tiles(
              title: notes[index]['title'],
              color: tileColors[index % tileColors.length],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: Icon(Icons.add),
      ),
    );
  }
}
