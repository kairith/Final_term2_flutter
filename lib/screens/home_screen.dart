import 'package:flutter/material.dart';

class RaceScreen extends StatelessWidget {
  const RaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Race screen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for image
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey,
                  child: const Center(
                    child: Text("Image"),
                  ),
                ),
                const SizedBox(width: 16),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Name: Sport Event", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      Text("5km: running", style: TextStyle(fontSize: 14)),
                      SizedBox(height: 4),
                      Text("Date: 04:20:25", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                // Ellipsis icon
                const Icon(Icons.more_vert),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add action
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
