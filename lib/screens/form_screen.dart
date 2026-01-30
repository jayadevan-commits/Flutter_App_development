import 'package:flutter/material.dart';
import '../services/api_service.dart';
//import 'form_details_list.dart';

class CreateFormScreen extends StatefulWidget {
  const CreateFormScreen({super.key});

  @override
  State<CreateFormScreen> createState() => _CreateFormScreenState();
}

class _CreateFormScreenState extends State<CreateFormScreen> {
  bool isLoading = false;

  final Map<String, TextEditingController> c = {
    'first_name': TextEditingController(),
    'last_name': TextEditingController(),
    'em_code': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'des_id': TextEditingController(),
    'dep_id': TextEditingController(),
    'gender': TextEditingController(),
    'blood_group': TextEditingController(),
    'phone': TextEditingController(),
    'dob': TextEditingController(),
    'joining_date': TextEditingController(),
  };

  @override
  void dispose() {
    for (var controller in c.values) {
      controller.dispose();
    }
    super.dispose();
  }

Future<void> pickDate(
  BuildContext context,
  TextEditingController controller,
) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), 
    firstDate: DateTime(1980), 
    lastDate: DateTime(2030),
    );
  if (pickedDate != null){
    final formattedDate=
    "${pickedDate.year.toString().padLeft(4,'0')}-"
    "${pickedDate.month.toString().padLeft(2,'0')}-"
    "${pickedDate.day.toString().padLeft(2,'0')}";

    setState(() {
      controller.text=formattedDate;
    });
  }
}
Widget buildTextField(String key,{ bool ispassword= false}){
  return Padding(
    padding: const EdgeInsets.only(bottom:12),
    child: TextField(
      controller: c[key],
      obscureText: ispassword,
      decoration: InputDecoration(
        labelText: key.replaceAll('_', ' ').toUpperCase(),
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

  void submit() async {
    setState(() => isLoading = true);

    final data = {
      "first_name": c['first_name']!.text.trim(),
      "last_name": c['last_name']!.text.trim(),
      "em_code": c['em_code']!.text.trim(),
      "email": c['email']!.text.trim(),
      "password": c['password']!.text.trim(),
      "des_id": int.tryParse(c['des_id']!.text) ?? 0,
      "dep_id": int.tryParse(c['dep_id']!.text)?? 0,
      "report_manager": "",
      "role": "employee",
      "gender": c['gender']!.text.trim(),
      "blood_group": c['blood_group']!.text.trim(),
      "phone": c['phone']!.text.trim(),
      "dob": c['dob']!.text.trim(),
      "joining_date": c['joining_date']!.text.trim(),
    };

    final success = await ApiService.createEmployee(data);

    setState(() => isLoading = false);

    if (success) {
      Navigator.pop(
        context,true
        // MaterialPageRoute(
        //   builder: (_) => const formListScreen(),
        // ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server timeout. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Employee'),
      backgroundColor:  Colors.teal                // Color(0xFFD81B60)
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          buildTextField('first_name'),
          buildTextField('last_name'),
          buildTextField('em_code'),
          buildTextField('email'),
          buildTextField('password',ispassword: true),
          buildTextField('des_id'),
          buildTextField('dep_id'),
          buildTextField('gender'),
          buildTextField('blood_group'),
          buildTextField('phone'),

          //DOB field (datePicker)
          TextField(
            controller: c['dob'],
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () => pickDate(context,c['dob']!),
          ),

          const SizedBox(height: 12),

          // Joining date field(datePicker)
          TextField(
            controller: c['joining_date'],
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'joining_date',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: ()=>pickDate(context,c['joining_date']!),
          ),

          const SizedBox(height:24),
         
         ElevatedButton(
          onPressed: isLoading ? null : submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF90CAF9),
            padding: const EdgeInsets.symmetric(vertical:14),
          ),
          child: isLoading
          ? const CircularProgressIndicator(color:  Colors.white)
          : const Text('create',style: TextStyle(color: Colors.white),
          ),
          ),
        ],
      ),
    );
  }
}
