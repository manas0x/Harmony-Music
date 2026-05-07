import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '/models/media_Item_builder.dart';
import '/ui/player/player_controller.dart';

class RecentlyPlayedWidget extends StatelessWidget {
  const RecentlyPlayedWidget({super.key});

  Future<List<MediaItem>> _loadRecentlyPlayed() async {
    final box = await Hive.openBox("LIBRP");
    if (box.isEmpty) return [];
    return box.values
        .toList()
        .reversed
        .map((e) => MediaItemBuilder.fromJson(Map<String, dynamic>.from(e)))
        .take(20)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MediaItem>>(
      future: _loadRecentlyPlayed(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        final songs = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                "recentlyPlayed".tr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: songs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final imageUrl = song.artUri?.toString() ?? '';
                  return GestureDetector(
                    onTap: () {
                      Get.find<PlayerController>().pushSongToQueue(song);
                    },
                    child: SizedBox(
                      width: 80,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              height: 65,
                              width: 65,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                height: 65,
                                width: 65,
                                color: Colors.grey[800],
                                child: const Icon(Icons.music_note,
                                    color: Colors.white54),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
