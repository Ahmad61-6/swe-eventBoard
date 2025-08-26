class TRoutes {
  static const login = '/login';
  static const forgotPassword = '/forgotPassword';
  static const resetPassword = '/resetPassword';
  static const dashboard = '/dashboard';

  static const events = '/events';
  static const createEvent = '/createEvent';
  static const editEvent = '/editEvent';
  static const profile = '/profile';

  static List sidebarMenuItems = [
    dashboard,
    events,
    createEvent,
  ];
}
