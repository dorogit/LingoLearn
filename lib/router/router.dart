import 'package:go_router/go_router.dart';
import 'package:lingolearn/views/grammar.dart';
import 'package:lingolearn/views/home.dart';
import 'package:lingolearn/views/intro.dart';
import 'package:lingolearn/views/profile.dart';
import 'package:lingolearn/views/text_improvements.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => const Intro(),
        name: 'introduction'),
    GoRoute(
        path: '/home', builder: (context, state) => Home(), name: 'homepage'),
    GoRoute(
        path: '/grammar_correction',
        builder: (context, state) => Grammar(),
        name: 'grammar'),
    GoRoute(
        path: '/text-improvement',
        builder: (context, state) => TextImprovement(
            'Hello I am Dhruv good to see you I was waiting for your response good that it came'),
        name: 'text-improvement'),
    GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
        name: 'profile'),
  ],
// redirect: (context,state){
//   var box = Hive.box('profile');
//   if (box.name!=''){
//     return '/home';
//   }else{
//     return '/intro';
//   }
// }
);
