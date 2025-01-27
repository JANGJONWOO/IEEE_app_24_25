import 'package:flutter/material.dart';
import 'member_detail_screen.dart'; // Importing the details screen

class CouncilListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IEEE Council'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'IEEE Council',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: councilMembers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: councilMembers[index]['color'],
                  ),
                  title: Text(councilMembers[index]['name']),
                  subtitle: Text(councilMembers[index]['role']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemberDetailScreen(
                          member: councilMembers[index], 
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Add functionality for the button here
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Send Message'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Sample data for council members
final List<Map<String, dynamic>> councilMembers = [
  {'name': 'Gaurang Rane', 'role': 'CEO', 'color': Colors.grey},
  {'name': 'Anoushka Menon', 'role': 'CMO', 'color': Colors.green},
  {'name': 'Veydant Sharma', 'role': 'Founder', 'color': Colors.yellow},
  {'name': 'Ayush Patil', 'role': 'CTO', 'color': Colors.purple},
  {'name': 'Anshi Tiwary', 'role': 'Lead Designer', 'color': Colors.orange},
  {'name': 'Rakshit', 'role': 'UI Designer', 'color': Colors.blue},
  {'name': 'Shantanu Bhosale', 'role': 'Accountant', 'color': Colors.red},
];
