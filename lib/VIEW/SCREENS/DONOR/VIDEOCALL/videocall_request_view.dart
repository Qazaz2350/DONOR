import 'package:donate/Utilis/extention.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class VideoCallScheduleUI extends StatelessWidget {
  final String orphanagename;
  final Map<String, dynamic> orphanage;
  final String username;
  final String useremail;
  final String userphone;

  const VideoCallScheduleUI({
    super.key,
    required this.orphanage,
    required this.orphanagename,
    required this.username,
    required this.useremail,
    required this.userphone,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonorViewModel(),
      child: Consumer<DonorViewModel>(
        builder: (context, vm, child) => DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Schedule Video Call'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Schedule'),
                  Tab(text: 'Video Call'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // Tab 1: Your existing scroll view
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _calendar(vm),
                      const SizedBox(height: 12),
                      _selectedDateView(vm),
                      const SizedBox(height: 24),
                      _timeField(context, vm),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          vm.submitVideoCall(
                            context: context,
                            orphanageData: orphanage,
                            donorName: username,
                            donorPhone: userphone,
                            donorEmail: useremail,
                          );
                        },
                        child: const Text('Request Video Call'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        orphanage['orphanagename'] ??
                            orphanage['name'] ??
                            'No Name',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.onSurface,
                          letterSpacing: 0.3,
                          height: 1.2,
                        ),
                      ),
                      Text(useremail),
                      Text(username),
                      Text(userphone),
                    ],
                  ),
                ),

                // Tab 2: Simple text
                Center(
                  child: Text(
                    'Video Call',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _calendar(DonorViewModel vm) {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: vm.focusedDay,
      selectedDayPredicate: (day) => isSameDay(vm.selectedDay, day),
      calendarFormat: CalendarFormat.month,
      onDaySelected: vm.onDateSelected,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  Widget _selectedDateView(DonorViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        vm.selectedDay == null
            ? 'No date selected'
            : 'Selected Date: ${vm.selectedDay!.day}/${vm.selectedDay!.month}/${vm.selectedDay!.year}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _timeField(BuildContext context, DonorViewModel vm) {
    return TextField(
      controller: vm.timeController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Select Time',
        hintText: 'Tap to open clock',
        prefixIcon: const Icon(Icons.access_time),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          vm.selectedTime = picked;
          vm.timeController.text = picked.format(context);
          vm.notifyListeners();
        }
      },
    );
  }
}
