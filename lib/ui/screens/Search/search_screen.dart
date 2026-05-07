import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/search_item.dart';
import '/ui/screens/Settings/settings_screen_controller.dart';
import '../../widgets/modified_text_field.dart';
import '/ui/navigator.dart';
import 'search_screen_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchScreenController = Get.put(SearchScreenController());
    final settingsScreenController = Get.find<SettingsScreenController>();
    final topPadding = context.isLandscape ? 50.0 : 80.0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Row(
          children: [
            settingsScreenController.isBottomNavBarEnabled.isFalse
                ? Container(
                    width: 60,
                    color:
                        Theme.of(context).navigationRailTheme.backgroundColor,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: topPadding),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .color,
                            ),
                            onPressed: () {
                              Get.nestedKey(ScreenNavigationSetup.id)!
                                  .currentState!
                                  .pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(
                    width: 15,
                  ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: topPadding, left: 5),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "search".tr,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ModifiedTextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: searchScreenController.textInputController,
                      textInputAction: TextInputAction.search,
                      onChanged: searchScreenController.onChanged,
                      onSubmitted: (val) {
                        if (val.contains("https://")) {
                          searchScreenController.filterLinks(Uri.parse(val));
                          searchScreenController.reset();
                          return;
                        }
                        Get.toNamed(ScreenNavigationSetup.searchResultScreen,
                            id: ScreenNavigationSetup.id, arguments: val);
                        searchScreenController.addToHistryQueryList(val);
                      },
                      autofocus: settingsScreenController
                          .isBottomNavBarEnabled.isFalse,
                      cursorColor: Theme.of(context).textTheme.bodySmall!.color,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 5),
                          focusColor: Colors.white,
                          hintText: "searchDes".tr,
                          suffix: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Voice search implementation placeholder
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackbar(context, "comingSoon".tr,
                                          size: SanckBarSize.SMALL));
                                },
                                icon: const Icon(Icons.mic),
                                splashRadius: 16,
                                iconSize: 22,
                              ),
                              IconButton(
                                onPressed: searchScreenController.reset,
                                icon: const Icon(Icons.close),
                                splashRadius: 16,
                                iconSize: 19,
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                      child: Obx(() {
                        final isEmpty = searchScreenController
                                .suggestionList.isEmpty ||
                            searchScreenController.textInputController.text ==
                                "";
                        final list = isEmpty
                            ? searchScreenController.historyQuerylist.toList()
                            : searchScreenController.suggestionList.toList();
                        return ListView(
                            padding: const EdgeInsets.only(top: 5, bottom: 400),
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            children: searchScreenController.urlPasted.isTrue
                                ? [
                                    InkWell(
                                      onTap: () {
                                        searchScreenController.filterLinks(
                                            Uri.parse(searchScreenController
                                                .textInputController.text));
                                        searchScreenController.reset();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: SizedBox(
                                          width: double.maxFinite,
                                          height: 60,
                                          child: Center(
                                              child: Text(
                                            "urlSearchDes".tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          )),
                                        ),
                                      ),
                                    )
                                  ]
                                : [
                                    if (isEmpty &&
                                        searchScreenController
                                            .historyQuerylist.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "recent".tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Get.defaultDialog(
                                                  title: "clearAll".tr,
                                                  middleText:
                                                      "Are you sure you want to clear all search history?",
                                                  textConfirm: "clearAll".tr,
                                                  textCancel: "cancel".tr,
                                                  confirmTextColor:
                                                      Colors.white,
                                                  onConfirm: () {
                                                    searchScreenController
                                                        .clearAllHistory();
                                                    Get.back();
                                                  },
                                                );
                                              },
                                              child: Text(
                                                "clearAll".tr,
                                                style: const TextStyle(
                                                    color: Colors.redAccent),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ...list.map((item) => SearchItem(
                                        queryString: item,
                                        isHistoryString: isEmpty))
                                  ]);
                      }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
