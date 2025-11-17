import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine if this is a small card
            final isSmall = constraints.maxWidth < 150;
            final isVerySmall = constraints.maxWidth < 120;
            final cardHeight = constraints.maxHeight;

            // Calculate dynamic padding based on card size
            final padding = isVerySmall ? 8.0 : (isSmall ? 10.0 : 12.0);

            // Calculate dynamic icon size
            final iconSize = isVerySmall ? 18.0 : (isSmall ? 20.0 : 24.0);

            // Calculate dynamic font sizes
            final valueFontSize = isVerySmall ? 18.0 : (isSmall ? 22.0 : 28.0);
            final titleFontSize = isVerySmall ? 10.0 : (isSmall ? 11.0 : 12.0);

            return Container(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(
                              isVerySmall ? 4 : (isSmall ? 6 : 8)),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: iconSize,
                          ),
                        ),
                      ),
                      if (onTap != null && !isVerySmall)
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.grey[400],
                        ),
                    ],
                  ),

                  // Spacer with flexible sizing
                  SizedBox(height: isVerySmall ? 4 : (isSmall ? 6 : 8)),

                  // Value and Title
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Value
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: valueFontSize,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        // Small spacing
                        SizedBox(height: 2),

                        // Title
                        Flexible(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class StatCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color color;
//   final VoidCallback? onTap;
//   final String? subtitle;

//   const StatCard({
//     Key? key,
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.color,
//     this.onTap,
//     this.subtitle,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             gradient: LinearGradient(
//               colors: [color.withOpacity(0.8), color],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(icon, color: Colors.white, size: 28),
//                   ),
//                   if (onTap != null)
//                     Icon(Icons.arrow_forward_ios,
//                         color: Colors.white, size: 16),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white.withOpacity(0.9),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               if (subtitle != null) ...[
//                 SizedBox(height: 4),
//                 Text(
//                   subtitle!,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.white.withOpacity(0.7),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
