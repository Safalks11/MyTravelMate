import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:main_project/view/home/home_bloc.dart';
import 'package:main_project/widgets/app_bar.dart';
import 'package:main_project/widgets/drawer/drawer_view.dart';

import '../../data/dummy_data/dummy_data.dart';
import '../../widgets/background_container.dart';
import '../../widgets/bottomnavbar.dart';
import '../favourite_screen/favourite_screen.dart';
import '../hotels_list/hotels_list_screen.dart';
import '../search_screen/search_screen.dart';
import 'lists_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeFailure) {
              return Center(child: Text("Error: ${state.error}"));
            } else if (state is HomeSuccess) {
              return _HomeBody(); // Main content based on tabs
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final bloc = context.read<HomeBloc>();
            return BottomNavBar(
              currentIndex: bloc.currentIndex,
              onTap: (index) {
                bloc.add(NavigateToNextScreenEvent(index));
              },
            );
          },
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    switch (bloc.currentIndex) {
      case 0:
        return _HomeContent();
      case 1:
        return SearchScreen();
      case 2:
        return HotelsListScreen();
      case 3:
        return FavouriteScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    details.sort((a, b) => b['rating'].compareTo(a['rating']));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(
            "Explore",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            4,
            (index) => Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HomeData.catColors[index],
                  ),
                  width: 70,
                  height: 65,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      HomeData.category[index],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(HomeData.catName[index]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            SizedBox(width: 25),
            Text(
              "Popular",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 5,
            ),
            child: GridView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 180,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Get.toNamed(
                    'details',
                    arguments: {
                      'id': details[index]['id'],
                      'color': HomeData.gridItemColors[
                          index % HomeData.gridItemColors.length],
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(details[index]['profile']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            color: HomeData.gridItemColors[
                                index % HomeData.gridItemColors.length],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          height: 35,
                          width: double.infinity,
                          child: Center(child: Text(details[index]['title'])),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
