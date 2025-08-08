// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../core/models/event_model.dart';
//
// class EventCard extends StatelessWidget {
//   final Event event;
//
//   const EventCard({super.key, required this.event});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 2,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () => Navigator.pushNamed(context, '/event-details', arguments: event),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       event.category,
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.primary,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   Icon(
//                     Icons.bookmark_border,
//                     color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 event.title,
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.calendar_today,
//                     size: 16,
//                     color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     DateFormat('MMM dd, yyyy • hh:mm a').format(event.date),
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.location_on,
//                     size: 16,
//                     color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     event.location,
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 14,
//                     backgroundImage: NetworkImage(event.organizerAvatar),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Hosted by ${event.organizerName}',
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                   const Spacer(),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       '${event.attendees} attending',
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.primary,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class EventCardShimmer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 80,
//                   height: 24,
//                   color: Colors.grey[200],
//                 ),
//                 const Spacer(),
//                 Container(
//                   width: 24,
//                   height: 24,
//                   color: Colors.grey[200],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Container(
//               width: double.infinity,
//               height: 20,
//               color: Colors.grey[200],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Container(
//                   width: 16,
//                   height: 16,
//                   color: Colors.grey[200],
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   width: 120,
//                   height: 16,
//                   color: Colors.grey[200],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Container(
//                   width: 16,
//                   height: 16,
//                   color: Colors.grey[200],
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   width: 150,
//                   height: 16,
//                   color: Colors.grey[200],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Container(
//                   width: 28,
//                   height: 28,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.grey[200],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   width: 100,
//                   height: 16,
//                   color: Colors.grey[200],
//                 ),
//                 const Spacer(),
//                 Container(
//                   width: 80,
//                   height: 24,
//                   color: Colors.grey[200],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
