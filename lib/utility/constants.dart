// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:tomodachi/utility/palette.dart';

/// **********************************************
/// * Routes
/// **********************************************
const String MAIN_ROUTE = '/';
const String LOGIN_ROUTE = '/login';
const String SIGNUP_ROUTE = '/signup';
const String PROFILE_ROUTE = '/profile';
const String SEARCH_ROUTE = '/search';
const String FRIEND_REQUEST_ROUTE = '/friend/request';
const String FRIEND_ROUTE = '/friend/view';

const List<String> ROUTES = [
  MAIN_ROUTE,
  PROFILE_ROUTE,
  FRIEND_REQUEST_ROUTE,
  SEARCH_ROUTE
];

/// **********************************************
/// * Pages
/// * This will be used in the navigation bar.
/// **********************************************
const List<Map<String, dynamic>> PAGES = [
  {
    'index': 0,
    'title': 'TODO',
    'route': MAIN_ROUTE,
    'child': Text(''),
    'icon': Icons.task_alt_rounded,
    'color': Palette.RED,
    'overflow': false
  },
  {
    'index': 1,
    'title': 'Profile',
    'route': PROFILE_ROUTE,
    'child': Text(''),
    'icon': Icons.person,
    'color': Palette.ORANGE,
    'overflow': true
  },
  {
    'index': 2,
    'title': 'Requests',
    'route': FRIEND_REQUEST_ROUTE,
    'child': Text(''),
    'icon': Icons.person_add,
    'color': Palette.GREEN,
    'overflow': false
  },
  {
    'index': 3,
    'title': 'Search',
    'route': SEARCH_ROUTE,
    'child': Text(''),
    'icon': Icons.search,
    'color': Palette.BLUE,
    'overflow': false
  }
];

// * Prompt
const String SUCCESS_MESSAGE = 'Success!';

/// **********************************************
/// * Collection Names
/// **********************************************
const String USER_COLLECTION = 'users';
const String TASK_COLLECTION = 'tasks';

/// **********************************************
/// * Snackbar (Types of Alerts)
/// **********************************************
const String ERROR_SNACK = 'Error Snackbar';
const String SUCCESS_SNACK = 'Success Snackbar';
const String WARNING_SNACK = 'Warning Snackbar';
const String HELP_SNACK = 'Help Snackbar';

/// **********************************************
/// * Task Actions
/// **********************************************
const String ADD_TASK = 'Add Task';
const String EDIT_TASK = 'Edit Task';
const String DELETE_TASK = 'Delete Task';

// * Task (Status Types)
Map<String, Color> STATUS = {
  'Not Started': Palette.RED,
  'In Progress': Palette.ORANGE,
  'Completed': Colors.green
};

/// **********************************************
/// * Miscellaneous
/// **********************************************
const double HORIZONTAL_MARGIN = 20;
const String IMAGE_FOLDER = 'images/';
const double AUTH_ICON_SIZE = 320;

RegExp PASSWORD_REGEXP =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
