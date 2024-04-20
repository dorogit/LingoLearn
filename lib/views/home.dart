import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lingolearn/controllers/pastEsssays.dart';
import 'package:lingolearn/views/pastEssay.dart';
import 'package:lingolearn/views/photo.dart';

class Home extends ConsumerWidget {
  Home({super.key});
  final Box<dynamic> profile = Hive.box('profile');

  Future<void> _checkAndInitializeStartDate(Box<dynamic> box) async {
    DateTime now = DateTime.now();
    DateTime? startDate = box.get('startDate');

    if (startDate == null || now.difference(startDate).inDays >= 7) {
      // Reset the start date if it's more than a week or doesn't exist
      await box.put('startDate', now);
    }
  }

  double _calculateProgress(Box<dynamic> box) {
    DateTime? startDate = box.get('startDate');
    DateTime now = DateTime.now();
    if (startDate != null) {
      int daysPassed = now.difference(startDate).inDays;
      double progress = daysPassed / 7;
      return progress <= 1.0 ? progress : 1.0; // Cap the progress at 1.0
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    final pastEssays = ref.watch(pastEssayProvider);

    return FutureBuilder(
      future: _checkAndInitializeStartDate(profile),
      builder: (context, snapshot) {
        double progress = snapshot.connectionState == ConnectionState.done
            ? _calculateProgress(profile)
            : 0.0;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: screenHeight / 5,
                flexibleSpace: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(40.0)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.shade900,
                            Colors.indigo.shade900,
                          ],
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight / 25),
                        Text(
                          'Hello ${profile.get('name')}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 24),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Ready to be fluent today?",
                          style: TextStyle(
                              color: Color.fromARGB(120, 255, 255, 255),
                              fontWeight: FontWeight.w500),
                        ),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "You learnt ${progress.toStringAsFixed(2)} days consecutively",
                          style: const TextStyle(
                              color: Color.fromARGB(120, 255, 255, 255),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )),
                elevation: 0,
                backgroundColor: Colors.white,
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: CircleAvatar(
                      backgroundImage: MemoryImage(profile.get('image')),
                    ),
                  )
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Daily Task',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Text(
                        "Listen to music: Ariana Grande's 'God is a Woman'!",
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  //here
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Start your session',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: SizedBox(
                        height: 200,
                        child: InkWell(
                          onTap: () {
                            // Hive.openBox('essays').then((Box value) => value.clear());
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const TakePictureScreen()));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            color: Theme.of(context).primaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.photo_camera,
                                  color: Color.fromARGB(120, 255, 255, 255),
                                  size: 50,
                                ),
                                Text(
                                  'Upload Essay',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(color: Colors.white),
                                ),
                                const Text(
                                  'Take photo of your essay',
                                  style: TextStyle(
                                      color: Color.fromARGB(120, 255, 255, 255),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      'Past sessions',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  FutureBuilder(
                    future: pastEssays,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.keys.isNotEmpty) {
                        // Ensuring snapshot data and keys are not null and not empty
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.keys.length,
                          itemBuilder: (context, idx) {
                            var key = snapshot.data!.keys.elementAt(
                                snapshot.data!.keys.length - 1 - idx);
                            var essay = snapshot.data![key];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: SizedBox(
                                  child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Essay #${idx + 1}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(color: Colors.black),
                                      ),
                                      // Center(
                                      //   child: Text(
                                      //     essay['text'][0] ?? 'No text',
                                      //     style: Theme.of(context)
                                      //         .textTheme
                                      //         .bodyLarge!
                                      //         .copyWith(color: Colors.black),
                                      //   ),
                                      // ),
                                      SizedBox(
                                          width: 300,
                                          child: FilledButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PastEssayView(
                                                                {
                                                                  'essay': essay[
                                                                      'text'][0],
                                                                  'id': idx,
                                                                },
                                                                essay[
                                                                    'grammar'],
                                                                essay[
                                                                    'improvements'])));
                                              },
                                              child: const Text(
                                                  'Mistakes & Improvements')))
                                    ],
                                  ),
                                ),
                              )),
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text(
                          'Start a Session!',
                          style: TextStyle(fontSize: 20),
                        ));
                      }
                    },
                  )

                  // Remaining parts of your SliverList
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
