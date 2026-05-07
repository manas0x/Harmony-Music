import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'basic_container.dart';

class SearchShimmer extends StatelessWidget {
  const SearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[500]!,
      highlightColor: Colors.grey[300]!,
      enabled: true,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const ListTile(
            leading: BasicShimmerContainer(Size(50, 50)),
            title: BasicShimmerContainer(Size(150, 20)),
            subtitle: BasicShimmerContainer(Size(100, 15)),
          );
        },
      ),
    );
  }
}
