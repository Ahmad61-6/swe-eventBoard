class TRoutes {
  static const login = '/login';
  static const forgotPassword = '/forgot-password/';
  static const resetPassword = '/reset-password/';
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
