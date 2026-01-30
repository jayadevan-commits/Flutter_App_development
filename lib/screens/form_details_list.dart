import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'form_screen.dart';

class formListScreen extends StatefulWidget {
  const formListScreen({super.key});

  @override
  State<formListScreen> createState() => _formListScreenState();
}

class _formListScreenState extends State<formListScreen> {
  List allEmployees = [];
  List filteredEmployees = [];
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      final data = await ApiService.getManagerEmployees();
      setState(() {
        allEmployees = data;
        filteredEmployees = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void searchEmployee(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      filteredEmployees = allEmployees.where((e) {
        final name =
            '${e['first_name'] ?? ''} ${e['last_name'] ?? ''}'.toLowerCase();
        return name.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFF8BBD0),
      appBar: AppBar(
        title: const Text('Employees'),
        backgroundColor: Colors.teal          // Color(0xFFD81B60),
      ),

      body: Column(
        children: [
          // 🔍 SEARCH BAR (WhatsApp style)
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: searchEmployee,
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                  icon: const Icon (Icons.clear),
                  onPressed: (){
                    searchController.clear();
                    searchEmployee(''); //reset list
                    FocusScope.of(context).unfocus();// hide keyword
                  },
                )
                : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📋 EMPLOYEE LIST
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredEmployees.isEmpty
                    ? const Center(child: Text('No employees found'))
                    : ListView.builder(
                        itemCount: filteredEmployees.length,
                        itemBuilder: (context, index) {
                          final e = filteredEmployees[index];

                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${e['first_name']} ${e['last_name']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  infoRow(Icons.email,'Email',e['em_email']),
                                  infoRow(Icons.phone,'Phone',e['em_phone']),
                                  infoRow(Icons.person,'Gender',e['em_gender']),
                                  infoRow(Icons.bloodtype,
                                      'Blood Group',e['em_blood_group']),
                                  infoRow(Icons.cake,
                                  'DOB',e['em_birthday']),
                                  infoRow(Icons.date_range,
                                      'Joining Date',e['em_joining_date']),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),

      // ➕ Floating button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add),
        label: const Text('Add Employee'),
        onPressed: ()async {
          final created = await 
          // navigate to FormScreen 
          Navigator.push(context,
          MaterialPageRoute(
            builder:(context) => const CreateFormScreen(),
            ),
            );
            if (created == true) {
              loadEmployees();
            }
        },
      ),
    );
  }
  //Helper widget   
Widget infoRow (IconData icon, String label,String? value) {
  return Padding(padding: const EdgeInsets.symmetric(vertical: 4),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
  children:[
    Icon(icon, size: 18,color: Colors.teal,),
    const SizedBox(width: 8),
    Text(
      '$label:',
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color:Colors.black54,
      ),
    ),
    Expanded(child: Text(value ?? '-',
    style: const TextStyle(color: Colors.black87),
    ),
    ),
  ],
  ),
  );
}
}
