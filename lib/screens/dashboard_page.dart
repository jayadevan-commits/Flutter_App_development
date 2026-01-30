import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentStep =0;
  Widget _stepContent(String text, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 28, color: Colors.teal),
        const SizedBox(height: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Page'),
        backgroundColor: Colors.teal,
        ),
        body:  SafeArea (
          child: SingleChildScrollView(
          padding:const EdgeInsets.all(16.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // carousel slider fixed height 
              SizedBox(
                height: 150,
                child: CarouselSlider(
                 options: CarouselOptions(
                  height: 140,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                 ),

                 items: const [
                  _DashboardBanner(title: 'Welcome Back', 
                  subtitle: "Have a Productive Day", 
                  icon: Icons.waving_hand, ),

                  _DashboardBanner(title: "Total Employees", 
                  subtitle: "5 Active Employee",
                   icon:Icons.people,
                  ),
                  _DashboardBanner(title: "Pending Approvals", 
                  subtitle: "3 Requests Waiting", 
                  icon: Icons.pending_actions,
                  ),
                 ],
                 ),
              ),

              const SizedBox(height:16),

              // Horizontal stepper
               SizedBox(
                height: 140, //Fixed height
                child: Stepper(
                type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepTapped: (step) {
                setState(() {
                  _currentStep = step;
                });
              },
              controlsBuilder: (context,details) {
                return const SizedBox.shrink(); // hides button
              },
              steps: [
                Step(
                  title: const Text("Add"),
                 content: _stepContent("Add Employee", Icons.person_add),
                 isActive: _currentStep >= 0,
                 state : _currentStep > 0
                 ? StepState.complete
                 : StepState.indexed,
                 ),

                  Step(
                    title:Text( "Approve"),
                  content: _stepContent("Approve Request", Icons.check_circle),
                  isActive: _currentStep >=1,
                  state: _currentStep > 1
                  ? StepState.complete
                  : StepState.indexed,
                  ),

                   Step(title: Text("complete"),
                   content:  _stepContent("Process Done", Icons.done_all),
                   isActive: _currentStep >=2,
                   state: _currentStep == 2
                   ? StepState.complete
                   : StepState.indexed
                   ),
              ],
                ),

              ),
              const SizedBox(height:12),
               // 🔹 QUICK ACTIONS TITLE
              const Text(
                "Recent Activities",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Gridview

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children:  const[
                  _DashboardCard ( icon: Icons.person_add, title: "Add Employee"),
                  _DashboardCard ( icon: Icons.list, title: "Employee List"),
                  _DashboardCard (icon: Icons.access_time, title: " Attendance"),
                  _DashboardCard (icon: Icons.bar_chart, title:" Reports")
                ],
              ),

              const SizedBox(height: 20),

              // Recent Activities Title
              const Text('Employee Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              ),

              const SizedBox(height:12),

              // List View
                ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: const  NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
                    return Card(
                      margin: const EdgeInsets.only(bottom:10),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text("employee ${index + 1}"),
                        trailing: Icon(Icons.arrow_back_ios,size: 16,),
                      ),
                    );
                  },
                  ),
            ],
                  ),      
          ),
           ),
    );
  }
}
// Reusable Dashboard Card

class _DashboardCard extends StatelessWidget{
  final IconData icon;
  final String title;
  
  const _DashboardCard({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon( icon, size: 32, color:  Colors.teal,
          ),

          const SizedBox(height: 8),
          
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );  
  }
}

// DashboardBanner carousel 
class _DashboardBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

 const _DashboardBanner({
  required this.title,
  required this. subtitle,
  required this. icon,
 });

 @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        ),
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Icon(icon, size: 40, color: Colors.teal),
          const SizedBox(width: 16),
          Column( 
            crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 4),
            Text(subtitle,)
          ],
          ),
          ],
          ),
          ),
    );
  }
}